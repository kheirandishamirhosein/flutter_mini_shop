import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/product_details/usecases/get_product_details_use_case.dart';
import '../products/pages/product_list_page.dart';
import '../products/view_model/product_list_view_model.dart';
import '../cart/view_model/cart_view_model.dart';
import '../checkout/view_model/checkout_view_model.dart';
import '../favorites/view_model/favorite_view_model.dart';
import '../profile/view_model/profile_view_model.dart';
import '../order_history/view_model/order_history_view_model.dart';

class MiniShopApp extends StatefulWidget {
  const MiniShopApp({
    required this.viewModel,
    required this.cartViewModel,
    required this.checkoutViewModel,
    required this.favoriteViewModel,
    required this.profileViewModel,
    required this.orderHistoryViewModel,
    required this.getProductDetailsUseCase,
    this.onDispose,
    super.key,
  });

  final ProductListViewModel viewModel;
  final CartViewModel cartViewModel;
  final CheckoutViewModel checkoutViewModel;
  final FavoriteViewModel favoriteViewModel;
  final ProfileViewModel profileViewModel;
  final OrderHistoryViewModel orderHistoryViewModel;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final VoidCallback? onDispose;

  @override
  State<MiniShopApp> createState() => _MiniShopAppState();
}

class _MiniShopAppState extends State<MiniShopApp> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    widget.cartViewModel.dispose();
    widget.checkoutViewModel.dispose();
    widget.favoriteViewModel.dispose();
    widget.profileViewModel.dispose();
    widget.orderHistoryViewModel.dispose();
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Shop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: ProductListPage(
          viewModel: widget.viewModel,
          cartViewModel: widget.cartViewModel,
          checkoutViewModel: widget.checkoutViewModel,
          favoriteViewModel: widget.favoriteViewModel,
          profileViewModel: widget.profileViewModel,
          orderHistoryViewModel: widget.orderHistoryViewModel,
          getProductDetailsUseCase: widget.getProductDetailsUseCase,
        ),
      ),
    );
  }
}
