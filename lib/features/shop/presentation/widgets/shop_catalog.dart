import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:word_game/core/constants/product_ids.dart';
import 'package:word_game/core/constants/shop_products.dart';

ProductDetails? shopFindProduct(List<ProductDetails> products, String id) {
  for (final p in products) {
    if (p.id == id) return p;
  }
  return null;
}

List<ProductDetails> shopCoinProducts(List<ProductDetails> products) {
  final out = <ProductDetails>[];
  for (final id in ProductIds.coinPacks) {
    final p = shopFindProduct(products, id);
    if (p != null) out.add(p);
  }
  return out;
}

List<ProductDetails> shopExtraProducts(List<ProductDetails> products) {
  final out = <ProductDetails>[];
  for (final id in ShopProducts.extraPackIds) {
    final p = shopFindProduct(products, id);
    if (p != null) out.add(p);
  }
  return out;
}
