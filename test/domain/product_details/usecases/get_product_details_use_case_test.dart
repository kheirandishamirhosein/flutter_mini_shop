import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/product_details/usecases/get_product_details_use_case.dart';
import 'package:mini_shop/domain/repo/product_repository.dart';

void main() {
  test('forwards the requested product ID to the repository', () async {
    final repository = _FakeProductRepository();
    final useCase = GetProductDetailsUseCase(repository);

    final product = await useCase(productId: '8');

    expect(repository.requestedProductId, '8');
    expect(product.id, '8');
  });
}

class _FakeProductRepository implements ProductRepository {
  String? requestedProductId;

  @override
  Future<List<Product>> getProducts() async => const [];

  @override
  Future<List<ProductCategory>> getProductCategories() async => const [];

  @override
  Future<List<Product>> getProductsByCategory({
    required ProductCategory category,
  }) async =>
      const [];

  @override
  Future<Product> getProductDetails({required String productId}) async {
    requestedProductId = productId;
    return Product(
      id: productId,
      title: 'Test product',
      description: 'Description',
      imageUrl: 'https://example.com/product.png',
      category: ProductCategory.electronics,
      price: 15.5,
    );
  }
}
