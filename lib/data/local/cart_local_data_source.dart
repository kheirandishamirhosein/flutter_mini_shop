import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';

/// Local storage contract for cart data.
abstract class CartLocalDataSource {
  Future<List<CartItem>> getCartItems();

  Future<void> addProduct(Product product);

  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  });

  Future<void> removeProduct(String productId);
}
