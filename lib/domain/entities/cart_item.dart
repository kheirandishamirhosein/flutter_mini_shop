import 'product.dart';

/// One product and its selected quantity inside the shopping cart.
class CartItem {
  const CartItem({required this.product, required this.quantity})
      : assert(quantity > 0);

  final Product product;
  final int quantity;

  double get totalPrice => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }
}
