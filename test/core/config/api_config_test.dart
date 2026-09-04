import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/core/config/api_config.dart';

void main() {
  test('uses Fake Store API as the central base URL', () {
    expect(ApiConfig.baseUrl, 'https://fakestoreapi.com');
  });

  test('creates a product-details endpoint for a product ID', () {
    expect(
      ApiConfig.productDetailsUri('7').toString(),
      'https://fakestoreapi.com/products/7',
    );
  });
}
