import 'dart:convert';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import 'cart_local_data_source.dart';
import 'key_value_storage.dart';
import 'product_local_mapper.dart';

/// Stores the cart locally so it survives app restarts.
class SharedPreferencesCartLocalDataSource implements CartLocalDataSource {
  const SharedPreferencesCartLocalDataSource(this._storage);

  static const _cartKey = 'cart_items';

  final KeyValueStorage _storage;

  @override
  Future<List<CartItem>> getCartItems() async {
    final encodedItems = await _storage.getString(_cartKey);
    if (encodedItems == null) {
      return const [];
    }

    try {
      final decodedItems = jsonDecode(encodedItems);
      if (decodedItems is! List) {
        return const [];
      }

      return decodedItems.map(_cartItemFromJson).toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    final items = await getCartItems();
    final itemIndex = items.indexWhere((item) => item.product.id == product.id);
    final updatedItems = List<CartItem>.of(items);

    if (itemIndex == -1) {
      updatedItems.add(CartItem(product: product, quantity: 1));
    } else {
      final existingItem = updatedItems[itemIndex];
      updatedItems[itemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    }

    await _saveItems(updatedItems);
  }

  @override
  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    final items = await getCartItems();
    final itemIndex = items.indexWhere((item) => item.product.id == productId);
    if (itemIndex == -1) {
      return;
    }

    final updatedItems = List<CartItem>.of(items);
    if (quantity <= 0) {
      updatedItems.removeAt(itemIndex);
    } else {
      updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
        quantity: quantity,
      );
    }

    await _saveItems(updatedItems);
  }

  @override
  Future<void> removeProduct(String productId) async {
    final items = await getCartItems();
    await _saveItems(
      items.where((item) => item.product.id != productId).toList(),
    );
  }

  @override
  Future<void> clearCart() => _saveItems(const []);

  Future<void> _saveItems(List<CartItem> items) {
    return _storage.setString(
      _cartKey,
      jsonEncode(items.map(_cartItemToJson).toList(growable: false)),
    );
  }

  CartItem _cartItemFromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Cart item is not an object.');
    }

    final quantity = json['quantity'];
    if (quantity is! int || quantity <= 0) {
      throw const FormatException('Cart item has invalid values.');
    }

    return CartItem(
      product: ProductLocalMapper.fromJson(json),
      quantity: quantity,
    );
  }

  Map<String, Object> _cartItemToJson(CartItem item) {
    return <String, Object>{
      ...ProductLocalMapper.toJson(item.product),
      'quantity': item.quantity,
    };
  }
}
