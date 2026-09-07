import 'package:flutter/foundation.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/product_categories/usecases/get_product_categories_use_case.dart';
import '../../../domain/product_categories/usecases/get_products_by_category_use_case.dart';
import '../../../domain/products/usecases/get_products_use_case.dart';

enum ProductListStatus { loading, success, failure }

class ProductListState {
  const ProductListState({
    required this.status,
    this.products = const [],
    this.categories = const [ProductCategory.all],
    this.selectedCategory = ProductCategory.all,
    this.errorMessage,
  });

  const ProductListState.loading() : this(status: ProductListStatus.loading);

  final ProductListStatus status;
  final List<Product> products;
  final List<ProductCategory> categories;
  final ProductCategory selectedCategory;
  final String? errorMessage;
}

/// Presentation state for the product list.
///
/// It knows the domain repository, but not HTTP, JSON, or endpoint URLs.
class ProductListViewModel extends ChangeNotifier {
  ProductListViewModel({
    required GetProductsUseCase getProductsUseCase,
    required GetProductCategoriesUseCase getProductCategoriesUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getProductCategoriesUseCase = getProductCategoriesUseCase,
        _getProductsByCategoryUseCase = getProductsByCategoryUseCase;

  final GetProductsUseCase _getProductsUseCase;
  final GetProductCategoriesUseCase _getProductCategoriesUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  ProductListState _state = const ProductListState.loading();

  ProductListState get state => _state;

  Future<void> loadProducts() async {
    _state = const ProductListState.loading();
    notifyListeners();

    try {
      final results = await Future.wait([
        _getProductsUseCase(),
        _getProductCategoriesUseCase(),
      ]);
      final products = results[0] as List<Product>;
      final categories = results[1] as List<ProductCategory>;
      _state = ProductListState(
        status: ProductListStatus.success,
        products: products,
        categories: _withAllCategory(categories),
      );
    } catch (_) {
      _state = const ProductListState(
        status: ProductListStatus.failure,
        errorMessage:
            'Unable to load products. Check your internet connection.',
      );
    }

    notifyListeners();
  }

  Future<void> selectCategory(ProductCategory category) async {
    if (category == _state.selectedCategory) {
      return;
    }

    _state = ProductListState(
      status: ProductListStatus.loading,
      categories: _state.categories,
      selectedCategory: category,
    );
    notifyListeners();

    try {
      final products = await _getProductsByCategoryUseCase(category: category);
      _state = ProductListState(
        status: ProductListStatus.success,
        products: products,
        categories: _state.categories,
        selectedCategory: category,
      );
    } catch (_) {
      _state = ProductListState(
        status: ProductListStatus.failure,
        categories: _state.categories,
        selectedCategory: category,
        errorMessage:
            'Unable to load products for this category. Please try again.',
      );
    }

    notifyListeners();
  }

  List<ProductCategory> _withAllCategory(List<ProductCategory> categories) {
    return [
      ProductCategory.all,
      ...categories.where((category) => category != ProductCategory.all),
    ];
  }
}
