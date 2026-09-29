import '../../../domain/entities/checkout_order.dart';
import '../../../domain/entities/checkout_request.dart';
import '../../../domain/repo/checkout_repository.dart';
import '../../local/checkout_local_data_source.dart';

/// Coordinates temporary checkout storage for the domain layer.
class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this._localDataSource);

  final CheckoutLocalDataSource _localDataSource;

  @override
  Future<CheckoutOrder> placeOrder(CheckoutRequest request) {
    return _localDataSource.placeOrder(request);
  }

  @override
  Future<List<CheckoutOrder>> getOrders() {
    return _localDataSource.getOrders();
  }
}
