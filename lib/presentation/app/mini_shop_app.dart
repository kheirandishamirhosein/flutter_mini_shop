import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../products/pages/product_list_page.dart';

class MiniShopApp extends StatelessWidget {
  const MiniShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مینی شاپ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: ProductListPage(),
      ),
    );
  }
}
