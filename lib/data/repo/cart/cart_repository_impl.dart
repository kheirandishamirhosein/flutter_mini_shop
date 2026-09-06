import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repo/cart_repository.dart';
import '../../local/cart_local_data_source.dart';

/// Coordinates cart data storage without exposing its implementation to UI.
class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._localDataSource);

  final CartLocalDataSource _localDataSource;

  @override
  Future<List<CartItem>> getCartItems() => _localDataSource.getCartItems();

  @override
  Future<void> addProduct(Product product) =>
      _localDataSource.addProduct(product);

  @override
  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) {
    return _localDataSource.updateQuantity(
      productId: productId,
      quantity: quantity,
    );
  }

  @override
  Future<void> removeProduct(String productId) {
    return _localDataSource.removeProduct(productId);
  }
}
