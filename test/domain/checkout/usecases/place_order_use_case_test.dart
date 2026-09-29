import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/cart_item.dart';
import 'package:mini_shop/domain/entities/checkout_order.dart';
import 'package:mini_shop/domain/entities/checkout_request.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/checkout/usecases/place_order_use_case.dart';
import 'package:mini_shop/domain/repo/checkout_repository.dart';

void main() {
  test('forwards the checkout request to the repository', () async {
    final repository = _FakeCheckoutRepository();
    final useCase = PlaceOrderUseCase(repository);
    final request = CheckoutRequest(
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
          quantity: 2,
        ),
      ],
    );

    final order = await useCase(request);

    expect(repository.receivedRequest, same(request));
    expect(order.request.totalQuantity, 2);
    expect(order.request.totalPrice, 20);
  });
}

class _FakeCheckoutRepository implements CheckoutRepository {
  CheckoutRequest? receivedRequest;

  @override
  Future<List<CheckoutOrder>> getOrders() async => const [];

  @override
  Future<CheckoutOrder> placeOrder(CheckoutRequest request) async {
    receivedRequest = request;
    return CheckoutOrder(
      id: 'order-1',
      request: request,
      createdAt: DateTime(2026),
    );
  }
}
