import '../../entities/product.dart';
import '../../repo/product_repository.dart';

class GetProductCategoriesUseCase {
  const GetProductCategoriesUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<ProductCategory>> call() {
    return _repository.getProductCategories();
  }
}
