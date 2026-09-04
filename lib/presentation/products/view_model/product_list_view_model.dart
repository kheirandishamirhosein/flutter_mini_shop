import 'package:flutter/foundation.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';

enum ProductListStatus { loading, success, failure }

class ProductListState {
  const ProductListState({
    required this.status,
    this.products = const [],
    this.errorMessage,
  });

  const ProductListState.loading() : this(status: ProductListStatus.loading);

  final ProductListStatus status;
  final List<Product> products;
  final String? errorMessage;
}

/// Presentation state for the product list.
///
/// It knows the domain repository, but not HTTP, JSON, or endpoint URLs.
class ProductListViewModel extends ChangeNotifier {
  ProductListViewModel(this._repository);

  final ProductRepository _repository;
  ProductListState _state = const ProductListState.loading();

  ProductListState get state => _state;

  Future<void> loadProducts() async {
    _state = const ProductListState.loading();
    notifyListeners();

    try {
      final products = await _repository.getProducts();
      _state = ProductListState(
        status: ProductListStatus.success,
        products: products,
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
}
