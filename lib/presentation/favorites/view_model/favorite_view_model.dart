import 'package:flutter/foundation.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/repo/favorite_repository.dart';

enum FavoriteStatus { loading, success, failure }

class FavoriteState {
  const FavoriteState({
    required this.status,
    this.products = const [],
    this.errorMessage,
  });

  const FavoriteState.loading() : this(status: FavoriteStatus.loading);

  final FavoriteStatus status;
  final List<Product> products;
  final String? errorMessage;

  bool get isEmpty => products.isEmpty;

  bool isFavorite(String productId) {
    return products.any((product) => product.id == productId);
  }
}

/// Shared presentation state for favorite actions and the Favorites page.
class FavoriteViewModel extends ChangeNotifier {
  FavoriteViewModel(this._repository);

  final FavoriteRepository _repository;
  FavoriteState _state = const FavoriteState.loading();

  FavoriteState get state => _state;

  bool isFavorite(String productId) => _state.isFavorite(productId);

  Future<void> loadFavorites() async {
    _state = const FavoriteState.loading();
    notifyListeners();

    try {
      final products = await _repository.getFavoriteProducts();
      _state =
          FavoriteState(status: FavoriteStatus.success, products: products);
    } catch (_) {
      _setFailure();
    }

    notifyListeners();
  }

  Future<bool> toggleFavorite(Product product) async {
    try {
      if (isFavorite(product.id)) {
        await _repository.removeFavorite(product.id);
      } else {
        await _repository.addFavorite(product);
      }

      final products = await _repository.getFavoriteProducts();
      _state =
          FavoriteState(status: FavoriteStatus.success, products: products);
      notifyListeners();
      return true;
    } catch (_) {
      _setFailure();
      notifyListeners();
      return false;
    }
  }

  void _setFailure() {
    _state = const FavoriteState(
      status: FavoriteStatus.failure,
      errorMessage: 'Unable to update favorites. Please try again.',
    );
  }
}
