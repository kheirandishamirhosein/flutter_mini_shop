import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';
import '../models/product_model.dart';
import 'product_api_exception.dart';

/// Owns the HTTP details for the products endpoint.
///
/// It is intentionally not used by widgets. A repository will call it in the
/// next layer and map [ProductModel] to the app's domain entity.
class ProductApiService {
  const ProductApiService(this._client);

  final http.Client _client;

  Future<List<ProductModel>> getProducts() async {
    late final http.Response response;
    try {
      response = await _client.get(
        ApiConfig.productsUri,
        headers: const {'Accept': 'application/json'},
      );
    } on http.ClientException catch (error) {
      throw ProductApiException('Network request failed: ${error.message}');
    }

    if (response.statusCode != 200) {
      throw ProductApiException(
        'Could not load products (HTTP ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const ProductApiException(
        'Unexpected products response: expected a JSON list.',
      );
    }

    try {
      return decoded
          .map(
            (item) => ProductModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();
    } on FormatException catch (_) {
      throw const ProductApiException(
          'The products response is not valid JSON.');
    } on TypeError catch (_) {
      throw const ProductApiException('A product has an unexpected shape.');
    }
  }
}
