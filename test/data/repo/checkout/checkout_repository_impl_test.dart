import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/checkout_local_data_source.dart';
import 'package:mini_shop/data/repo/checkout/checkout_repository_impl.dart';
import 'package:mini_shop/domain/entities/cart_item.dart';
import 'package:mini_shop/domain/entities/checkout_order.dart';
import 'package:mini_shop/domain/entities/checkout_request.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  test('delegates a checkout request to the local data source', () async {
    final dataSource = _FakeCheckoutLocalDataSource();
    final repository = CheckoutRepositoryImpl(dataSource);
    final request = _checkoutRequest();

    final order = await repository.placeOrder(request);

    expect(dataSource.receivedRequest, same(request));
    expect(order.id, 'MS-0001');
  });
}

class _FakeCheckoutLocalDataSource implements CheckoutLocalDataSource {
  CheckoutRequest? receivedRequest;

  @override
  Future<List<CheckoutOrder>> getOrders() async => const [];

  @override
  Future<CheckoutOrder> placeOrder(CheckoutRequest request) async {
    receivedRequest = request;
    return CheckoutOrder(
      id: 'MS-0001',
      request: request,
      createdAt: DateTime(2026),
    );
  }
}

CheckoutRequest _checkoutRequest() {
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
          imageUrl: '',
          category: ProductCategory.electronics,
          price: 10,
        ),
        quantity: 1,
      ),
    ],
  );
}
