import 'package:flutter/foundation.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/product_details/usecases/get_product_details_use_case.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

class ProductDetailsState {
  const ProductDetailsState({
    required this.status,
    this.product,
    this.errorMessage,
  });

  const ProductDetailsState.initial()
      : this(status: ProductDetailsStatus.initial);

  const ProductDetailsState.loading()
      : this(status: ProductDetailsStatus.loading);

  final ProductDetailsStatus status;
  final Product? product;
  final String? errorMessage;
}

/// Presentation state for one Product Details screen.
///
/// It depends on the use case only, never on HTTP or data-layer classes.
class ProductDetailsViewModel extends ChangeNotifier {
  ProductDetailsViewModel(this._getProductDetails);

  final GetProductDetailsUseCase _getProductDetails;
  ProductDetailsState _state = const ProductDetailsState.initial();

  ProductDetailsState get state => _state;

  Future<void> loadProduct(String productId) async {
    _state = const ProductDetailsState.loading();
    notifyListeners();

    try {
      final product = await _getProductDetails(productId: productId);
      _state = ProductDetailsState(
        status: ProductDetailsStatus.success,
        product: product,
      );
    } catch (_) {
      _state = const ProductDetailsState(
        status: ProductDetailsStatus.failure,
        errorMessage:
            'Unable to load product details. Check your internet connection.',
      );
    }

    notifyListeners();
  }
}
