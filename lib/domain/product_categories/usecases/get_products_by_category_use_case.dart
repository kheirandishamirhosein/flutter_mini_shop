import '../../entities/product.dart';
import '../../repo/product_repository.dart';

class GetProductsByCategoryUseCase {
  const GetProductsByCategoryUseCase(this._repository);

  final ProductRepository _repository;

  Future<List<Product>> call({required ProductCategory category}) {
    return _repository.getProductsByCategory(category: category);
  }
}
