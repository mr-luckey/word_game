import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:word_game/core/constants/product_ids.dart';
import 'package:word_game/core/constants/shop_products.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/core/services/analytics_service.dart';
import 'package:word_game/core/services/progress_sync_service.dart';
import 'package:word_game/core/services/vip_service.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

abstract class ShopState extends Equatable {
  const ShopState();
  @override
  List<Object?> get props => [];
}

class ShopInitial extends ShopState {
  const ShopInitial();
}

class ShopLoading extends ShopState {
  const ShopLoading();
}

class ShopLoaded extends ShopState {
  const ShopLoaded({
    required this.products,
    required this.fallbackPacks,
  });

  final List<ProductDetails> products;
  final List<ShopPackFallback> fallbackPacks;

  @override
  List<Object?> get props => [products, fallbackPacks];
}

class ShopUnavailable extends ShopState {
  const ShopUnavailable();
}

class ShopPurchaseSuccess extends ShopState {
  const ShopPurchaseSuccess({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class ShopPurchaseError extends ShopState {
  const ShopPurchaseError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class ShopCubit extends Cubit<ShopState> {
  ShopCubit(this._wallet, this._adService, this._vip, this._sync, this._analytics)
      : super(const ShopInitial()) {
    _init();
  }

  final WalletRepository _wallet;
  final AdService _adService;
  final VipService _vip;
  final ProgressSyncService _sync;
  final AnalyticsService _analytics;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  List<ProductDetails> _products = [];

  Future<void> _init() async {
    emit(const ShopLoading());
    if (kIsWeb) {
      emit(const ShopUnavailable());
      return;
    }
    final available = await _iap.isAvailable();
    if (!available) {
      emit(const ShopUnavailable());
      return;
    }
    final response = await _iap.queryProductDetails(ProductIds.all);
    _products = response.productDetails;
    emit(
      ShopLoaded(
        products: _products,
        fallbackPacks: ShopProducts.fallbackPacks,
      ),
    );
    _sub = _iap.purchaseStream.listen(_onPurchases);
  }

  Future<void> buy(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    if (ShopProducts.consumableIds.contains(product.id)) {
      await _iap.buyConsumable(purchaseParam: param);
    } else {
      // Subscriptions and one-time unlocks both use buyNonConsumable.
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> buyFallback(ShopPackFallback pack) async {
    await _deliver(pack.id);
    emit(ShopPurchaseSuccess(message: 'Purchased ${pack.title}!'));
    _emitLoaded();
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _deliver(p.productID).then((_) {
            emit(ShopPurchaseSuccess(message: 'Purchase successful!'));
            _emitLoaded();
          });
          if (p.pendingCompletePurchase) {
            _iap.completePurchase(p);
          }
        case PurchaseStatus.error:
          emit(ShopPurchaseError(
            message: p.error?.message ?? 'Purchase failed',
          ));
          _emitLoaded();
        case PurchaseStatus.canceled:
          _emitLoaded();
        case PurchaseStatus.pending:
          break;
      }
    }
  }

  void _emitLoaded() {
    emit(
      ShopLoaded(
        products: _products,
        fallbackPacks: ShopProducts.fallbackPacks,
      ),
    );
  }

  Future<void> _deliver(String productId) async {
    if (productId == ShopProducts.removeAds) {
      await _adService.setAdsRemoved(true);
    } else if (VipService.productGrantsVip(productId)) {
      await _vip.setVipActive(true);
    } else {
      final coins = ShopProducts.coinRewards[productId];
      if (coins != null && coins > 0) {
        await _wallet.addCoins(coins);
      }
    }
    await _sync.recordPurchaseAndSync(productId);
    unawaited(_analytics.logPurchase(productId));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
