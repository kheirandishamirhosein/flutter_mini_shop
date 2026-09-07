import '../../domain/entities/product.dart';
import 'favorite_local_data_source.dart';

/// A temporary favorites store that keeps data while the app is running.
///
/// A persistent data source can replace this class later without changing the
/// repository contract or presentation layer.
class InMemoryFavoriteLocalDataSource implements FavoriteLocalDataSource {
  final Map<String, Product> _favoritesByProductId = {};

  @override
  Future<List<Product>> getFavoriteProducts() async {
    return List<Product>.unmodifiable(_favoritesByProductId.values);
  }

  @override
  Future<void> addFavorite(Product product) async {
    _favoritesByProductId[product.id] = product;
  }

  @override
  Future<void> removeFavorite(String productId) async {
    _favoritesByProductId.remove(productId);
  }

  @override
  Future<bool> isFavorite(String productId) async {
    return _favoritesByProductId.containsKey(productId);
  }
}
