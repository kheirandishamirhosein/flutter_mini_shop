import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/remote/product_api_service.dart';
import '../../data/local/shared_preferences_cart_local_data_source.dart';
import '../../data/local/shared_preferences_checkout_local_data_source.dart';
import '../../data/local/shared_preferences_favorite_local_data_source.dart';
import '../../data/local/shared_preferences_key_value_storage.dart';
import '../../data/local/shared_preferences_profile_local_data_source.dart';
import '../../data/repo/cart/cart_repository_impl.dart';
import '../../data/repo/checkout/checkout_repository_impl.dart';
import '../../data/repo/favorite/favorite_repository_impl.dart';
import '../../data/repo/product_repository_impl.dart';
import '../../data/repo/profile/profile_repository_impl.dart';
import '../../domain/product_categories/usecases/get_product_categories_use_case.dart';
import '../../domain/product_categories/usecases/get_products_by_category_use_case.dart';
import '../../domain/products/usecases/get_products_use_case.dart';
import '../../domain/product_details/usecases/get_product_details_use_case.dart';
import '../../domain/checkout/usecases/place_order_use_case.dart';
import '../../domain/checkout/usecases/get_order_history_use_case.dart';
import '../../domain/cart/usecases/clear_cart_use_case.dart';
import '../../domain/profile/usecases/get_user_profile_use_case.dart';
import '../../domain/profile/usecases/update_user_profile_use_case.dart';
import 'mini_shop_app.dart';
import '../products/view_model/product_list_view_model.dart';
import '../cart/view_model/cart_view_model.dart';
import '../checkout/view_model/checkout_view_model.dart';
import '../favorites/view_model/favorite_view_model.dart';
import '../profile/view_model/profile_view_model.dart';
import '../order_history/view_model/order_history_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = http.Client();
  final localStorage = SharedPreferencesKeyValueStorage();
  final repository = ProductRepositoryImpl(ProductApiService(httpClient));
  final cartRepository = CartRepositoryImpl(
    SharedPreferencesCartLocalDataSource(localStorage),
  );
  final checkoutRepository = CheckoutRepositoryImpl(
    SharedPreferencesCheckoutLocalDataSource(localStorage),
  );
  final favoriteRepository = FavoriteRepositoryImpl(
    SharedPreferencesFavoriteLocalDataSource(localStorage),
  );
  final profileRepository = ProfileRepositoryImpl(
    SharedPreferencesProfileLocalDataSource(localStorage),
  );

  runApp(
    MiniShopApp(
      viewModel: ProductListViewModel(
        getProductsUseCase: GetProductsUseCase(repository),
        getProductCategoriesUseCase: GetProductCategoriesUseCase(repository),
        getProductsByCategoryUseCase: GetProductsByCategoryUseCase(repository),
      ),
      cartViewModel: CartViewModel(cartRepository),
      checkoutViewModel: CheckoutViewModel(
        PlaceOrderUseCase(checkoutRepository),
        ClearCartUseCase(cartRepository),
      ),
      orderHistoryViewModel: OrderHistoryViewModel(
        GetOrderHistoryUseCase(checkoutRepository),
      ),
      favoriteViewModel: FavoriteViewModel(favoriteRepository),
      profileViewModel: ProfileViewModel(
        GetUserProfileUseCase(profileRepository),
        UpdateUserProfileUseCase(profileRepository),
      ),
      getProductDetailsUseCase: GetProductDetailsUseCase(repository),
      onDispose: httpClient.close,
    ),
  );
}
