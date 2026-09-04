import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../data/remote/product_api_service.dart';
import '../../data/repo/product_repository_impl.dart';
import 'mini_shop_app.dart';
import '../products/view_model/product_list_view_model.dart';

void main() {
  final httpClient = http.Client();
  final repository = ProductRepositoryImpl(ProductApiService(httpClient));

  runApp(
    MiniShopApp(
      viewModel: ProductListViewModel(repository),
      onDispose: httpClient.close,
    ),
  );
}
