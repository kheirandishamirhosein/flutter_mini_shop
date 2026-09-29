import '../../entities/checkout_order.dart';
import '../../repo/checkout_repository.dart';

/// Gets previously placed mock orders.
class GetOrderHistoryUseCase {
  const GetOrderHistoryUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<List<CheckoutOrder>> call() => _repository.getOrders();
}
