import '../../entities/product.dart';
import '../../repo/product_repository.dart';

/// Retrieves one product for the Product Details feature.
class GetProductDetailsUseCase {
  const GetProductDetailsUseCase(this._repository);

  final ProductRepository _repository;

  Future<Product> call({required String productId}) {
    if (productId.trim().isEmpty) {
      throw ArgumentError.value(productId, 'productId', 'Must not be empty.');
    }

    return _repository.getProductDetails(productId: productId);
  }
}
