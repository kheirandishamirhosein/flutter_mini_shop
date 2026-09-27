import '../../repo/cart_repository.dart';

class ClearCartUseCase {
  const ClearCartUseCase(this._repository);

  final CartRepository _repository;

  Future<void> call() {
    return _repository.clearCart();
  }
}
