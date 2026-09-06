import 'package:flutter/foundation.dart';

import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/repo/cart_repository.dart';

enum CartStatus { loading, success, failure }

class CartState {
  const CartState({
    required this.status,
    this.items = const [],
    this.errorMessage,
  });

  const CartState.loading() : this(status: CartStatus.loading);

  final CartStatus status;
  final List<CartItem> items;
  final String? errorMessage;

  bool get isEmpty => items.isEmpty;
  int get totalQuantity =>
      items.fold(0, (total, item) => total + item.quantity);
  double get subtotal =>
      items.fold(0, (total, item) => total + item.totalPrice);
}

/// Shared presentation state for all cart actions and the Cart screen.
class CartViewModel extends ChangeNotifier {
  CartViewModel(this._repository);

  final CartRepository _repository;
  CartState _state = const CartState.loading();

  CartState get state => _state;

  Future<void> loadCart() async {
    _state = const CartState.loading();
    notifyListeners();

    try {
      final items = await _repository.getCartItems();
      _state = CartState(status: CartStatus.success, items: items);
    } catch (_) {
      _setFailure();
    }

    notifyListeners();
  }

  Future<bool> addProduct(Product product) {
    return _performMutation(() => _repository.addProduct(product));
  }

  Future<bool> updateQuantity({
    required String productId,
    required int quantity,
  }) {
    return _performMutation(
      () => _repository.updateQuantity(
        productId: productId,
        quantity: quantity,
      ),
    );
  }

  Future<bool> removeProduct(String productId) {
    return _performMutation(() => _repository.removeProduct(productId));
  }

  Future<bool> _performMutation(Future<void> Function() mutation) async {
    try {
      await mutation();
      final items = await _repository.getCartItems();
      _state = CartState(status: CartStatus.success, items: items);
      notifyListeners();
      return true;
    } catch (_) {
      _setFailure();
      notifyListeners();
      return false;
    }
  }

  void _setFailure() {
    _state = const CartState(
      status: CartStatus.failure,
      errorMessage: 'Unable to update your cart. Please try again.',
    );
  }
}
