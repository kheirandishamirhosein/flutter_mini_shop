import '../entities/cart_item.dart';
import '../entities/product.dart';

/// Domain contract for managing items in the user's shopping cart.
abstract class CartRepository {
  Future<List<CartItem>> getCartItems();

  Future<void> addProduct(Product product);

  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  });

  Future<void> removeProduct(String productId);
}
