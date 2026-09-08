import 'dart:async';

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
    this.searchQuery = '',
    this.errorMessage,
  });

  const ProductListState.loading() : this(status: ProductListStatus.loading);

  final ProductListStatus status;
  final List<Product> products;
  final List<ProductCategory> categories;
  final ProductCategory selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  bool get hasSearchQuery => searchQuery.isNotEmpty;

  List<Product> get visibleProducts {
    final normalizedQuery = searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.title.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    List<ProductCategory>? categories,
    ProductCategory? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Presentation state for the product list.
///
/// It knows the domain repository, but not HTTP, JSON, or endpoint URLs.
class ProductListViewModel extends ChangeNotifier {
  ProductListViewModel({
    required GetProductsUseCase getProductsUseCase,
    required GetProductCategoriesUseCase getProductCategoriesUseCase,
    required GetProductsByCategoryUseCase getProductsByCategoryUseCase,
    Duration searchDebounceDuration = const Duration(milliseconds: 300),
  })  : _getProductsUseCase = getProductsUseCase,
        _getProductCategoriesUseCase = getProductCategoriesUseCase,
        _getProductsByCategoryUseCase = getProductsByCategoryUseCase,
        _searchDebounceDuration = searchDebounceDuration;

  final GetProductsUseCase _getProductsUseCase;
  final GetProductCategoriesUseCase _getProductCategoriesUseCase;
  final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  final Duration _searchDebounceDuration;
  ProductListState _state = const ProductListState.loading();
  Timer? _searchDebounce;

  ProductListState get state => _state;

  Future<void> loadProducts() async {
    _state = ProductListState(
      status: ProductListStatus.loading,
      searchQuery: _state.searchQuery,
    );
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
        searchQuery: _state.searchQuery,
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
      searchQuery: _state.searchQuery,
    );
    notifyListeners();

    try {
      final products = await _getProductsByCategoryUseCase(category: category);
      _state = ProductListState(
        status: ProductListStatus.success,
        products: products,
        categories: _state.categories,
        selectedCategory: category,
        searchQuery: _state.searchQuery,
      );
    } catch (_) {
      _state = ProductListState(
        status: ProductListStatus.failure,
        categories: _state.categories,
        selectedCategory: category,
        searchQuery: _state.searchQuery,
        errorMessage:
            'Unable to load products for this category. Please try again.',
      );
    }

    notifyListeners();
  }

  void updateSearchQuery(String searchQuery) {
    _searchDebounce?.cancel();

    if (_searchDebounceDuration == Duration.zero) {
      _applySearchQuery(searchQuery);
      return;
    }

    _searchDebounce = Timer(
      _searchDebounceDuration,
      () => _applySearchQuery(searchQuery),
    );
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    _applySearchQuery('');
  }

  void _applySearchQuery(String searchQuery) {
    _state = _state.copyWith(searchQuery: searchQuery);
    notifyListeners();
  }

  List<ProductCategory> _withAllCategory(List<ProductCategory> categories) {
    return [
      ProductCategory.all,
      ...categories.where((category) => category != ProductCategory.all),
    ];
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
