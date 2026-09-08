import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/product_categories/usecases/get_product_categories_use_case.dart';
import 'package:mini_shop/domain/product_categories/usecases/get_products_by_category_use_case.dart';
import 'package:mini_shop/domain/products/usecases/get_products_use_case.dart';
import 'package:mini_shop/domain/repo/product_repository.dart';
import 'package:mini_shop/presentation/products/view_model/product_list_view_model.dart';

void main() {
  test('loads API categories alongside the initial product list', () async {
    final repository = _FakeProductRepository();
    final viewModel = _createViewModel(repository);

    await viewModel.loadProducts();

    expect(viewModel.state.status, ProductListStatus.success);
    expect(viewModel.state.categories, [
      ProductCategory.all,
      ProductCategory.electronics,
      ProductCategory.jewelry,
    ]);
  });

  test('loads products from the selected category', () async {
    final repository = _FakeProductRepository();
    final viewModel = _createViewModel(repository);
    await viewModel.loadProducts();

    await viewModel.selectCategory(ProductCategory.jewelry);

    expect(repository.requestedCategory, ProductCategory.jewelry);
    expect(viewModel.state.selectedCategory, ProductCategory.jewelry);
    expect(viewModel.state.products.single.category, ProductCategory.jewelry);
  });

  test('filters loaded products by title and clears the query', () async {
    final repository = _FakeProductRepository();
    final viewModel = _createViewModel(repository);
    await viewModel.loadProducts();

    viewModel.updateSearchQuery('test');

    expect(viewModel.state.visibleProducts, hasLength(1));

    viewModel.updateSearchQuery('missing');

    expect(viewModel.state.visibleProducts, isEmpty);

    viewModel.clearSearch();

    expect(viewModel.state.visibleProducts, hasLength(1));
    expect(viewModel.state.hasSearchQuery, isFalse);
  });
}

ProductListViewModel _createViewModel(_FakeProductRepository repository) {
  return ProductListViewModel(
    getProductsUseCase: GetProductsUseCase(repository),
    getProductCategoriesUseCase: GetProductCategoriesUseCase(repository),
    getProductsByCategoryUseCase: GetProductsByCategoryUseCase(repository),
    searchDebounceDuration: Duration.zero,
  );
}

class _FakeProductRepository implements ProductRepository {
  ProductCategory? requestedCategory;

  @override
  Future<List<Product>> getProducts() async {
    return [_productFor(ProductCategory.electronics)];
  }

  @override
  Future<List<ProductCategory>> getProductCategories() async {
    return const [ProductCategory.electronics, ProductCategory.jewelry];
  }

  @override
  Future<List<Product>> getProductsByCategory({
    required ProductCategory category,
  }) async {
    requestedCategory = category;
    return [_productFor(category)];
  }

  @override
  Future<Product> getProductDetails({required String productId}) async {
    return _productFor(ProductCategory.electronics);
  }

  Product _productFor(ProductCategory category) {
    return Product(
      id: '1',
      title: 'Test product',
      description: 'Description',
      imageUrl: '',
      category: category,
      price: 12,
    );
  }
}
