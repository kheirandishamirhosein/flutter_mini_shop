import 'cart_item.dart';

enum CheckoutPaymentMethod { cashOnDelivery, cardOnDelivery }

/// The information required to create an order from the current cart.
class CheckoutRequest {
  const CheckoutRequest({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.paymentMethod,
    required this.items,
  })  : assert(fullName != ''),
        assert(phoneNumber != ''),
        assert(address != ''),
        assert(items.length > 0);

  final String fullName;
  final String phoneNumber;
  final String address;
  final CheckoutPaymentMethod paymentMethod;
  final List<CartItem> items;

  int get totalQuantity =>
      items.fold(0, (total, item) => total + item.quantity);

  double get totalPrice =>
      items.fold(0, (total, item) => total + item.totalPrice);
}
