import '../../domain/entities/checkout_order.dart';
import '../../domain/entities/checkout_request.dart';

/// Local storage contract for temporary checkout orders.
abstract class CheckoutLocalDataSource {
  Future<CheckoutOrder> placeOrder(CheckoutRequest request);
}
