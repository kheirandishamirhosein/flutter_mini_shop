import 'package:flutter/foundation.dart';

import '../../../domain/checkout/usecases/get_order_history_use_case.dart';
import '../../../domain/entities/checkout_order.dart';

enum OrderHistoryStatus { loading, success, failure }

class OrderHistoryState {
  const OrderHistoryState({
    required this.status,
    this.orders = const [],
    this.errorMessage,
  });

  const OrderHistoryState.loading() : this(status: OrderHistoryStatus.loading);

  final OrderHistoryStatus status;
  final List<CheckoutOrder> orders;
  final String? errorMessage;

  bool get isEmpty => orders.isEmpty;
}

/// Presentation state for the user's locally stored mock orders.
class OrderHistoryViewModel extends ChangeNotifier {
  OrderHistoryViewModel(this._getOrderHistoryUseCase);

  final GetOrderHistoryUseCase _getOrderHistoryUseCase;
  OrderHistoryState _state = const OrderHistoryState.loading();

  OrderHistoryState get state => _state;

  Future<void> loadOrders() async {
    _state = const OrderHistoryState.loading();
    notifyListeners();

    try {
      final orders = await _getOrderHistoryUseCase();
      final newestFirst = List<CheckoutOrder>.of(orders)
        ..sort((first, second) => second.createdAt.compareTo(first.createdAt));
      _state = OrderHistoryState(
        status: OrderHistoryStatus.success,
        orders: newestFirst,
      );
    } catch (_) {
      _state = const OrderHistoryState(
        status: OrderHistoryStatus.failure,
        errorMessage: 'Unable to load your order history. Please try again.',
      );
    }

    notifyListeners();
  }
}
