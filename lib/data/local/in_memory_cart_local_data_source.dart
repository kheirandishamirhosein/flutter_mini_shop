import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import 'cart_local_data_source.dart';

/// A temporary local cart store.
///
/// It intentionally keeps data only while the app process is alive. A later
/// persistence feature can replace this class without changing the repository
/// or presentation layers.
class InMemoryCartLocalDataSource implements CartLocalDataSource {
  final Map<String, CartItem> _itemsByProductId = {};

  @override
  Future<List<CartItem>> getCartItems() async {
    return List<CartItem>.unmodifiable(_itemsByProductId.values);
  }

  @override
  Future<void> addProduct(Product product) async {
    final existingItem = _itemsByProductId[product.id];
    _itemsByProductId[product.id] = existingItem == null
        ? CartItem(product: product, quantity: 1)
        : existingItem.copyWith(quantity: existingItem.quantity + 1);
  }

  @override
  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    final existingItem = _itemsByProductId[productId];
    if (existingItem == null) {
      return;
    }

    if (quantity <= 0) {
      _itemsByProductId.remove(productId);
      return;
    }

    _itemsByProductId[productId] = existingItem.copyWith(quantity: quantity);
  }

  @override
  Future<void> removeProduct(String productId) async {
    _itemsByProductId.remove(productId);
  }
}
