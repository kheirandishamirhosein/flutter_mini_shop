import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/checkout/usecases/place_order_use_case.dart';
import 'package:mini_shop/domain/entities/cart_item.dart';
import 'package:mini_shop/domain/entities/checkout_order.dart';
import 'package:mini_shop/domain/entities/checkout_request.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/repo/checkout_repository.dart';
import 'package:mini_shop/presentation/checkout/view_model/checkout_view_model.dart';

void main() {
  test('emits submitting then success when an order is placed', () async {
    final viewModel = CheckoutViewModel(
      PlaceOrderUseCase(_FakeCheckoutRepository()),
    );
    final statuses = <CheckoutStatus>[];
    viewModel.addListener(() => statuses.add(viewModel.state.status));

    final completed = await viewModel.submitOrder(_checkoutRequest());

    expect(completed, isTrue);
    expect(statuses, [CheckoutStatus.submitting, CheckoutStatus.success]);
    expect(viewModel.state.order?.id, 'MS-0001');
  });

  test('emits failure when placing an order fails', () async {
    final viewModel = CheckoutViewModel(
      PlaceOrderUseCase(_FakeCheckoutRepository(shouldFail: true)),
    );

    final completed = await viewModel.submitOrder(_checkoutRequest());

    expect(completed, isFalse);
    expect(viewModel.state.status, CheckoutStatus.failure);
    expect(viewModel.state.errorMessage, isNotEmpty);
  });
}

class _FakeCheckoutRepository implements CheckoutRepository {
  _FakeCheckoutRepository({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<CheckoutOrder> placeOrder(CheckoutRequest request) async {
    if (shouldFail) {
      throw Exception('Mock checkout failure');
    }

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
