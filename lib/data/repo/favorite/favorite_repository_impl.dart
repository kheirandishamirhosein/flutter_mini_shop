import '../../../domain/entities/product.dart';
import '../../../domain/repo/favorite_repository.dart';
import '../../local/favorite_local_data_source.dart';

/// Coordinates local favorite storage for the domain layer.
class FavoriteRepositoryImpl implements FavoriteRepository {
  const FavoriteRepositoryImpl(this._localDataSource);

  final FavoriteLocalDataSource _localDataSource;

  @override
  Future<List<Product>> getFavoriteProducts() {
    return _localDataSource.getFavoriteProducts();
  }

  @override
  Future<void> addFavorite(Product product) {
    return _localDataSource.addFavorite(product);
  }

  @override
  Future<void> removeFavorite(String productId) {
    return _localDataSource.removeFavorite(productId);
  }

  @override
  Future<bool> isFavorite(String productId) {
    return _localDataSource.isFavorite(productId);
  }
}
