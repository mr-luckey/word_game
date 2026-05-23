import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:word_game/core/services/ad_service.dart';
import 'package:word_game/features/game/domain/repositories/level_repository.dart';

const kProductIds = {
  'coins_500',
  'coins_1500',
  'coins_5000',
  'remove_ads',
  'vip_monthly',
  'starter_pack',
};

const kProductCoins = {
  'coins_500': 500,
  'coins_1500': 1500,
  'coins_5000': 5000,
  'starter_pack': 200,
};

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
  const ShopLoaded({required this.products});
  final List<ProductDetails> products;
  @override
  List<Object?> get props => [products];
}

class ShopUnavailable extends ShopState {
  const ShopUnavailable();
}

class ShopCubit extends Cubit<ShopState> {
  ShopCubit(this._wallet, this._adService) : super(const ShopInitial()) {
    _init();
  }

  final WalletRepository _wallet;
  final AdService _adService;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  Future<void> _init() async {
    emit(const ShopLoading());
    final available = await _iap.isAvailable();
    if (!available) {
      emit(const ShopUnavailable());
      return;
    }
    final response = await _iap.queryProductDetails(kProductIds);
    emit(ShopLoaded(products: response.productDetails));
    _sub = _iap.purchaseStream.listen(_onPurchases);
  }

  Future<void> buy(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final p in purchases) {
      if (p.status == PurchaseStatus.purchased ||
          p.status == PurchaseStatus.restored) {
        _deliver(p.productID);
        if (p.pendingCompletePurchase) {
          _iap.completePurchase(p);
        }
      }
    }
  }

  Future<void> _deliver(String productId) async {
    if (productId == 'remove_ads') {
      await _adService.setAdsRemoved(true);
      return;
    }
    final coins = kProductCoins[productId];
    if (coins != null) {
      await _wallet.addCoins(coins);
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
