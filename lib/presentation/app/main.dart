import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/remote/product_api_service.dart';
import '../../data/local/in_memory_cart_local_data_source.dart';
import '../../data/local/in_memory_favorite_local_data_source.dart';
import '../../data/repo/cart/cart_repository_impl.dart';
import '../../data/repo/favorite/favorite_repository_impl.dart';
import '../../data/repo/product_repository_impl.dart';
import '../../domain/product_categories/usecases/get_product_categories_use_case.dart';
import '../../domain/product_categories/usecases/get_products_by_category_use_case.dart';
import '../../domain/products/usecases/get_products_use_case.dart';
import '../../domain/product_details/usecases/get_product_details_use_case.dart';
import 'mini_shop_app.dart';
import '../products/view_model/product_list_view_model.dart';
import '../cart/view_model/cart_view_model.dart';
import '../favorites/view_model/favorite_view_model.dart';

void main() {
  final httpClient = http.Client();
  final repository = ProductRepositoryImpl(ProductApiService(httpClient));
  final cartRepository = CartRepositoryImpl(InMemoryCartLocalDataSource());
  final favoriteRepository = FavoriteRepositoryImpl(
    InMemoryFavoriteLocalDataSource(),
  );

  runApp(
    MiniShopApp(
      viewModel: ProductListViewModel(
        getProductsUseCase: GetProductsUseCase(repository),
        getProductCategoriesUseCase: GetProductCategoriesUseCase(repository),
        getProductsByCategoryUseCase: GetProductsByCategoryUseCase(repository),
      ),
      cartViewModel: CartViewModel(cartRepository),
      favoriteViewModel: FavoriteViewModel(favoriteRepository),
      getProductDetailsUseCase: GetProductDetailsUseCase(repository),
      onDispose: httpClient.close,
    ),
  );
}
