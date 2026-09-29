import '../entities/checkout_order.dart';
import '../entities/checkout_request.dart';

/// Domain contract for submitting an order.
abstract class CheckoutRepository {
  Future<CheckoutOrder> placeOrder(CheckoutRequest request);

  Future<List<CheckoutOrder>> getOrders();
}
