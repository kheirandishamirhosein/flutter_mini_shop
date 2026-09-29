import 'dart:convert';

import '../../domain/entities/product.dart';
import 'favorite_local_data_source.dart';
import 'key_value_storage.dart';
import 'product_local_mapper.dart';

/// Stores favorite products locally so they survive app restarts.
class SharedPreferencesFavoriteLocalDataSource
    implements FavoriteLocalDataSource {
  const SharedPreferencesFavoriteLocalDataSource(this._storage);

  static const _favoritesKey = 'favorite_products';

  final KeyValueStorage _storage;

  @override
  Future<List<Product>> getFavoriteProducts() async {
    final encodedProducts = await _storage.getString(_favoritesKey);
    if (encodedProducts == null) {
      return const [];
    }

    try {
      final decodedProducts = jsonDecode(encodedProducts);
      if (decodedProducts is! List) {
        return const [];
      }

      return decodedProducts
          .map(ProductLocalMapper.fromJson)
          .toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> addFavorite(Product product) async {
    final productsById = <String, Product>{
      for (final existingProduct in await getFavoriteProducts())
        existingProduct.id: existingProduct,
      product.id: product,
    };

    await _saveProducts(productsById.values.toList());
  }

  @override
  Future<void> removeFavorite(String productId) async {
    final products = await getFavoriteProducts();
    await _saveProducts(
      products.where((product) => product.id != productId).toList(),
    );
  }

  @override
  Future<bool> isFavorite(String productId) async {
    final products = await getFavoriteProducts();
    return products.any((product) => product.id == productId);
  }

  Future<void> _saveProducts(List<Product> products) {
    return _storage.setString(
      _favoritesKey,
      jsonEncode(products.map(ProductLocalMapper.toJson).toList()),
    );
  }
}
