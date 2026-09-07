import '../../entities/product.dart';
import '../../repo/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<Product>> call() {
    return _repository.getProducts();
  }
}
