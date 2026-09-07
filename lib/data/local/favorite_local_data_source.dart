import '../../domain/entities/product.dart';

/// Local storage contract for favorite products.
abstract class FavoriteLocalDataSource {
  Future<List<Product>> getFavoriteProducts();

  Future<void> addFavorite(Product product);

  Future<void> removeFavorite(String productId);

  Future<bool> isFavorite(String productId);
}
