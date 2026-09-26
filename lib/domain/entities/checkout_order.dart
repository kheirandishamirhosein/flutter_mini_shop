import 'checkout_request.dart';

/// A successfully created order.
class CheckoutOrder {
  const CheckoutOrder({
    required this.id,
    required this.request,
    required this.createdAt,
  });

  final String id;
  final CheckoutRequest request;
  final DateTime createdAt;
}
