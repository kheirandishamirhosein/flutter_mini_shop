import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/key_value_storage.dart';
import 'package:mini_shop/data/local/shared_preferences_checkout_local_data_source.dart';
import 'package:mini_shop/domain/entities/cart_item.dart';
import 'package:mini_shop/domain/entities/checkout_request.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  test('persists mock orders after the data source is recreated', () async {
    final storage = _FakeKeyValueStorage();
    final dataSource = SharedPreferencesCheckoutLocalDataSource(storage);

    final firstOrder = await dataSource.placeOrder(_request());
    final recreatedDataSource = SharedPreferencesCheckoutLocalDataSource(
      storage,
    );
    final orders = await recreatedDataSource.getOrders();

    expect(firstOrder.id, 'MS-0001');
    expect(orders, hasLength(1));
    expect(orders.single.id, 'MS-0001');
    expect(orders.single.request.items.single.quantity, 2);
    expect(orders.single.request.totalPrice, 31);
  });

  test('generates the next order ID from saved orders', () async {
    final dataSource = SharedPreferencesCheckoutLocalDataSource(
      _FakeKeyValueStorage(),
    );

    await dataSource.placeOrder(_request());
    final secondOrder = await dataSource.placeOrder(_request());

    expect(secondOrder.id, 'MS-0002');
  });

  test('returns no orders for malformed stored data', () async {
    final dataSource = SharedPreferencesCheckoutLocalDataSource(
      _FakeKeyValueStorage()..values['checkout_orders'] = 'not valid json',
    );

    expect(await dataSource.getOrders(), isEmpty);
  });
}

CheckoutRequest _request() {
  return CheckoutRequest(
    fullName: 'Amirhosein Sharifi',
    phoneNumber: '09120000000',
    address: 'Tehran',
    paymentMethod: CheckoutPaymentMethod.cardOnDelivery,
    items: const [
      CartItem(
        product: Product(
          id: '1',
          title: 'Test product',
          description: 'Description',
          imageUrl: 'https://example.com/product.png',
          category: ProductCategory.electronics,
          price: 15.5,
          rating: 4.5,
          reviewCount: 12,
        ),
        quantity: 2,
      ),
    ],
  );
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
