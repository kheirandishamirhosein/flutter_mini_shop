import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/in_memory_checkout_local_data_source.dart';
import 'package:mini_shop/domain/entities/cart_item.dart';
import 'package:mini_shop/domain/entities/checkout_request.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  test('creates an order ID for each mock checkout', () async {
    final dataSource = InMemoryCheckoutLocalDataSource();
    final request = _checkoutRequest();

    final firstOrder = await dataSource.placeOrder(request);
    final secondOrder = await dataSource.placeOrder(request);

    expect(firstOrder.id, 'MS-0001');
    expect(secondOrder.id, 'MS-0002');
    expect(firstOrder.request, same(request));
  });
}

CheckoutRequest _checkoutRequest() {
  return CheckoutRequest(
    fullName: 'Amirhosein Sharifi',
    phoneNumber: '09120000000',
    address: 'Tehran',
    paymentMethod: CheckoutPaymentMethod.cashOnDelivery,
    items: const [
      CartItem(
        product: Product(
          id: '1',
          title: 'Test product',
          description: 'Description',
          imageUrl: '',
          category: ProductCategory.electronics,
          price: 10,
        ),
        quantity: 1,
      ),
    ],
  );
}
