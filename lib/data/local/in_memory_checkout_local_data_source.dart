import '../../domain/entities/checkout_order.dart';
import '../../domain/entities/checkout_request.dart';
import 'checkout_local_data_source.dart';

/// A temporary order creator for the mock checkout flow.
///
/// This does not charge a customer or contact a backend. It can later be
/// replaced with a remote data source without changing the domain contract.
class InMemoryCheckoutLocalDataSource implements CheckoutLocalDataSource {
  int _nextOrderNumber = 1;

  @override
  Future<CheckoutOrder> placeOrder(CheckoutRequest request) async {
    final orderId = 'MS-${_nextOrderNumber.toString().padLeft(4, '0')}';
    _nextOrderNumber++;

    return CheckoutOrder(
      id: orderId,
      request: request,
      createdAt: DateTime.now(),
    );
  }
}
