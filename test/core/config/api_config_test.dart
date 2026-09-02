import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/core/config/api_config.dart';

void main() {
  test('uses Fake Store API as the central base URL', () {
    expect(ApiConfig.baseUrl, 'https://fakestoreapi.com');
  });
}
