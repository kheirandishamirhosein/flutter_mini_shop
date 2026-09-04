import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/pages/product_list_page.dart';
import '../products/view_model/product_list_view_model.dart';

class MiniShopApp extends StatefulWidget {
  const MiniShopApp({
    required this.viewModel,
    this.onDispose,
    super.key,
  });

  final ProductListViewModel viewModel;
  final VoidCallback? onDispose;

  @override
  State<MiniShopApp> createState() => _MiniShopAppState();
}

class _MiniShopAppState extends State<MiniShopApp> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مینی شاپ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: ProductListPage(viewModel: widget.viewModel),
      ),
    );
  }
}
