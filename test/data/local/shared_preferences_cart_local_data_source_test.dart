import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/key_value_storage.dart';
import 'package:mini_shop/data/local/shared_preferences_cart_local_data_source.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  const product = Product(
    id: '1',
    title: 'Wireless headphones',
    description: 'A product used by the persistent cart test.',
    imageUrl: 'https://example.com/product.png',
    category: ProductCategory.electronics,
    price: 15.5,
    rating: 4.5,
    reviewCount: 12,
  );

  test('restores cart items after the data source is recreated', () async {
    final storage = _FakeKeyValueStorage();
    final dataSource = SharedPreferencesCartLocalDataSource(storage);

    await dataSource.addProduct(product);
    await dataSource.addProduct(product);

    final recreatedDataSource = SharedPreferencesCartLocalDataSource(storage);
    final items = await recreatedDataSource.getCartItems();

    expect(items, hasLength(1));
    expect(items.single.product.id, product.id);
    expect(items.single.product.category, ProductCategory.electronics);
    expect(items.single.quantity, 2);
  });

  test('persists cart changes and clears the stored cart', () async {
    final storage = _FakeKeyValueStorage();
    final dataSource = SharedPreferencesCartLocalDataSource(storage);

    await dataSource.addProduct(product);
    await dataSource.updateQuantity(productId: product.id, quantity: 3);

    expect((await dataSource.getCartItems()).single.quantity, 3);

    await dataSource.clearCart();

    expect(await dataSource.getCartItems(), isEmpty);
  });

  test('returns an empty cart for malformed stored data', () async {
    final dataSource = SharedPreferencesCartLocalDataSource(
      _FakeKeyValueStorage()..values['cart_items'] = 'not valid json',
    );

    expect(await dataSource.getCartItems(), isEmpty);
  });
}

class _FakeKeyValueStorage implements KeyValueStorage {
  final values = <String, String>{};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }
}
