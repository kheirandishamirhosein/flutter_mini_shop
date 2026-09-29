import 'dart:convert';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import 'cart_local_data_source.dart';
import 'key_value_storage.dart';

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

    final id = json['id'];
    final title = json['title'];
    final description = json['description'];
    final imageUrl = json['imageUrl'];
    final categoryName = json['category'];
    final price = json['price'];
    final rating = json['rating'];
    final reviewCount = json['reviewCount'];
    final quantity = json['quantity'];

    if (id is! String ||
        title is! String ||
        description is! String ||
        imageUrl is! String ||
        categoryName is! String ||
        price is! num ||
        rating is! num ||
        reviewCount is! int ||
        quantity is! int ||
        quantity <= 0) {
      throw const FormatException('Cart item has invalid values.');
    }

    final category = ProductCategory.values
        .where((value) => value.name == categoryName)
        .firstOrNull;
    if (category == null) {
      throw const FormatException('Cart item has an invalid category.');
    }

    return CartItem(
      product: Product(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        category: category,
        price: price.toDouble(),
        rating: rating.toDouble(),
        reviewCount: reviewCount,
      ),
      quantity: quantity,
    );
  }

  Map<String, Object> _cartItemToJson(CartItem item) {
    final product = item.product;
    return <String, Object>{
      'id': product.id,
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'category': product.category.name,
      'price': product.price,
      'rating': product.rating,
      'reviewCount': product.reviewCount,
      'quantity': item.quantity,
    };
  }
}
