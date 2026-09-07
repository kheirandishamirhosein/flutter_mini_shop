import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';
import 'models/product_model.dart';
import 'product_api_exception.dart';
import 'product_remote_data_source.dart';

/// Owns the HTTP details for Product endpoints.
///
/// It is intentionally not used by widgets. A repository will call it in the
/// next layer and map [ProductModel] to the app's domain entity.
class ProductApiService implements ProductRemoteDataSource {
  const ProductApiService(this._client);

  final http.Client _client;

  @override
  Future<List<ProductModel>> getProducts() async {
    final decoded = await _getJson(
      uri: ApiConfig.productsUri,
      requestFailureMessage: 'Could not load products',
    );

    return _parseProductList(decoded, responseName: 'products');
  }

  @override
  Future<List<String>> getProductCategories() async {
    final decoded = await _getJson(
      uri: ApiConfig.productCategoriesUri,
      requestFailureMessage: 'Could not load product categories',
    );

    if (decoded is! List || decoded.any((item) => item is! String)) {
      throw const ProductApiException(
        'Unexpected product categories response: expected a JSON list of strings.',
      );
    }

    return decoded.cast<String>();
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String categoryName,
  }) async {
    final decoded = await _getJson(
      uri: ApiConfig.productsByCategoryUri(categoryName),
      requestFailureMessage: 'Could not load products for this category',
    );

    return _parseProductList(decoded, responseName: 'category products');
  }

  Future<dynamic> _getJson({
    required Uri uri,
    required String requestFailureMessage,
  }) async {
    late final http.Response response;
    try {
      response = await _client.get(
        uri,
        headers: const {'Accept': 'application/json'},
      );
    } on http.ClientException catch (error) {
      throw ProductApiException('Network request failed: ${error.message}');
    }

    if (response.statusCode != 200) {
      throw ProductApiException(
        '$requestFailureMessage (HTTP ${response.statusCode}).',
      );
    }

    try {
      return jsonDecode(response.body);
    } on ProductApiException {
      rethrow;
    } on FormatException catch (_) {
      throw const ProductApiException('The server response is not valid JSON.');
    }
  }

  List<ProductModel> _parseProductList(
    dynamic decoded, {
    required String responseName,
  }) {
    if (decoded is! List) {
      throw ProductApiException(
        'Unexpected $responseName response: expected a JSON list.',
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
    } on TypeError catch (_) {
      throw const ProductApiException('A product has an unexpected shape.');
    }
  }

  @override
  Future<ProductModel> getProductDetails({required String productId}) async {
    late final http.Response response;
    try {
      response = await _client.get(
        ApiConfig.productDetailsUri(productId),
        headers: const {'Accept': 'application/json'},
      );
    } on http.ClientException catch (error) {
      throw ProductApiException('Network request failed: ${error.message}');
    }

    if (response.statusCode != 200) {
      throw ProductApiException(
        'Could not load product details (HTTP ${response.statusCode}).',
      );
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map) {
        throw const ProductApiException(
          'Unexpected product details response: expected a JSON object.',
        );
      }

      return ProductModel.fromJson(Map<String, dynamic>.from(decoded));
    } on ProductApiException {
      rethrow;
    } on FormatException catch (_) {
      throw const ProductApiException(
        'The product details response is not valid JSON.',
      );
    } on TypeError catch (_) {
      throw const ProductApiException(
        'Product details have an unexpected shape.',
      );
    }
  }
}
