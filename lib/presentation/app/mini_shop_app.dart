import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../domain/product_details/usecases/get_product_details_use_case.dart';
import '../products/pages/product_list_page.dart';
import '../products/view_model/product_list_view_model.dart';
import '../cart/view_model/cart_view_model.dart';

class MiniShopApp extends StatefulWidget {
  const MiniShopApp({
    required this.viewModel,
    required this.cartViewModel,
    required this.getProductDetailsUseCase,
    this.onDispose,
    super.key,
  });

  final ProductListViewModel viewModel;
  final CartViewModel cartViewModel;
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
          getProductDetailsUseCase: widget.getProductDetailsUseCase,
        ),
      ),
    );
  }
}
