import '../../entities/checkout_order.dart';
import '../../entities/checkout_request.dart';
import '../../repo/checkout_repository.dart';

class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<CheckoutOrder> call(CheckoutRequest request) {
    return _repository.placeOrder(request);
  }
}
