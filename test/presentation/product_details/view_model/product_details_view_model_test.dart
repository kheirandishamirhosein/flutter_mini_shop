import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/product_details/usecases/get_product_details_use_case.dart';
import 'package:mini_shop/domain/repo/product_repository.dart';
import 'package:mini_shop/presentation/product_details/view_model/product_details_view_model.dart';

void main() {
  test('emits loading then success when product details are available',
      () async {
    final viewModel = ProductDetailsViewModel(
      GetProductDetailsUseCase(_FakeProductRepository()),
    );
    final statuses = <ProductDetailsStatus>[];
    viewModel.addListener(() => statuses.add(viewModel.state.status));

    await viewModel.loadProduct('1');

    expect(
        statuses, [ProductDetailsStatus.loading, ProductDetailsStatus.success]);
    expect(viewModel.state.product?.id, '1');
  });

  test('emits failure when product details cannot be loaded', () async {
    final viewModel = ProductDetailsViewModel(
      GetProductDetailsUseCase(_FakeProductRepository(shouldFail: true)),
    );

    await viewModel.loadProduct('1');

    expect(viewModel.state.status, ProductDetailsStatus.failure);
    expect(viewModel.state.errorMessage, isNotEmpty);
  });
}

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository({this.shouldFail = false});

  final bool shouldFail;

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
    if (shouldFail) {
      throw Exception('Network error');
    }

    return Product(
      id: productId,
      title: 'Wireless headphones',
      description: 'A product used by the view model test.',
      imageUrl: '',
      category: ProductCategory.electronics,
      price: 15.5,
      rating: 4.2,
      reviewCount: 12,
    );
  }
}
