import 'package:flutter/foundation.dart';

import '../../../domain/cart/usecases/clear_cart_use_case.dart';
import '../../../domain/checkout/usecases/place_order_use_case.dart';
import '../../../domain/entities/checkout_order.dart';
import '../../../domain/entities/checkout_request.dart';

enum CheckoutStatus { editing, submitting, success, failure }

class CheckoutState {
  const CheckoutState({
    required this.status,
    this.order,
    this.errorMessage,
  });

  const CheckoutState.editing() : this(status: CheckoutStatus.editing);

  final CheckoutStatus status;
  final CheckoutOrder? order;
  final String? errorMessage;

  bool get isSubmitting => status == CheckoutStatus.submitting;
}

/// Presentation state for submitting a checkout order.
class CheckoutViewModel extends ChangeNotifier {
  CheckoutViewModel(this._placeOrderUseCase, this._clearCartUseCase);

  final PlaceOrderUseCase _placeOrderUseCase;
  final ClearCartUseCase _clearCartUseCase;
  CheckoutState _state = const CheckoutState.editing();

  CheckoutState get state => _state;

  Future<bool> submitOrder(CheckoutRequest request) async {
    if (_state.isSubmitting) {
      return false;
    }

    _state = const CheckoutState(status: CheckoutStatus.submitting);
    notifyListeners();

    try {
      final order = await _placeOrderUseCase(request);
      await _clearCartUseCase();
      _state = CheckoutState(status: CheckoutStatus.success, order: order);
      notifyListeners();
      return true;
    } catch (_) {
      _state = const CheckoutState(
        status: CheckoutStatus.failure,
        errorMessage: 'Unable to place your order. Please try again.',
      );
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _state = const CheckoutState.editing();
    notifyListeners();
  }
}
