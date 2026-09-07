import '../entities/product.dart';

/// Domain contract for managing the user's favorite products.
abstract class FavoriteRepository {
  Future<List<Product>> getFavoriteProducts();

  Future<void> addFavorite(Product product);

  Future<void> removeFavorite(String productId);

  Future<bool> isFavorite(String productId);
}
