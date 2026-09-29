import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/checkout/usecases/get_order_history_use_case.dart';
import 'package:mini_shop/domain/entities/cart_item.dart';
import 'package:mini_shop/domain/entities/checkout_order.dart';
import 'package:mini_shop/domain/entities/checkout_request.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/repo/checkout_repository.dart';
import 'package:mini_shop/presentation/order_history/view_model/order_history_view_model.dart';

void main() {
  test('loads orders newest first', () async {
    final viewModel = OrderHistoryViewModel(
      GetOrderHistoryUseCase(_FakeCheckoutRepository()),
    );

    await viewModel.loadOrders();

    expect(viewModel.state.status, OrderHistoryStatus.success);
    expect(viewModel.state.orders.map((order) => order.id),
        ['MS-0002', 'MS-0001']);
  });
}

class _FakeCheckoutRepository implements CheckoutRepository {
  @override
  Future<List<CheckoutOrder>> getOrders() async => [
        CheckoutOrder(
          id: 'MS-0001',
          request: _request(),
          createdAt: DateTime(2026, 1, 1),
        ),
        CheckoutOrder(
          id: 'MS-0002',
          request: _request(),
          createdAt: DateTime(2026, 1, 2),
        ),
      ];

  @override
  Future<CheckoutOrder> placeOrder(CheckoutRequest request) {
    throw UnimplementedError();
  }
}

CheckoutRequest _request() {
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
