import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mini_shop/core/config/api_config.dart';
import 'package:mini_shop/data/remote/product_api_exception.dart';
import 'package:mini_shop/data/remote/product_api_service.dart';

void main() {
  test('gets and parses products from the configured endpoint', () async {
    final service = ProductApiService(
      MockClient((request) async {
        expect(request.url, ApiConfig.productsUri);
        expect(request.headers['accept'], 'application/json');
        return http.Response(
          '''[
            {
              "id": 1,
              "title": "Sample product",
              "price": 15.5,
              "description": "A product for a test",
              "category": "electronics",
              "image": "https://example.com/product.png",
              "rating": {"rate": 4.2, "count": 12}
            }
          ]''',
          200,
        );
      }),
    );

    final products = await service.getProducts();

    expect(products, hasLength(1));
    expect(products.single.id, 1);
    expect(products.single.price, 15.5);
    expect(products.single.rating, 4.2);
  });

  test('throws a clear exception for a non-success response', () {
    final service = ProductApiService(
      MockClient((_) async => http.Response('Service unavailable', 503)),
    );

    expect(
      service.getProducts(),
      throwsA(isA<ProductApiException>()),
    );
  });

  test('gets product categories from the configured endpoint', () async {
    final service = ProductApiService(
      MockClient((request) async {
        expect(request.url, ApiConfig.productCategoriesUri);
        return http.Response('["electronics", "jewelery"]', 200);
      }),
    );

    final categories = await service.getProductCategories();

    expect(categories, ['electronics', 'jewelery']);
  });

  test('gets products for a category from the configured endpoint', () async {
    final service = ProductApiService(
      MockClient((request) async {
        expect(
          request.url,
          ApiConfig.productsByCategoryUri('electronics'),
        );
        return http.Response(
          '''[
            {
              "id": 1,
              "title": "Sample product",
              "price": 15.5,
              "description": "A product for a test",
              "category": "electronics",
              "image": "https://example.com/product.png",
              "rating": {"rate": 4.2, "count": 12}
            }
          ]''',
          200,
        );
      }),
    );

    final products = await service.getProductsByCategory(
      categoryName: 'electronics',
    );

    expect(products.single.category, 'electronics');
  });

  test('gets and parses product details from the configured endpoint',
      () async {
    final service = ProductApiService(
      MockClient((request) async {
        expect(request.url, ApiConfig.productDetailsUri('1'));
        expect(request.headers['accept'], 'application/json');
        return http.Response(
          '''{
            "id": 1,
            "title": "Sample product",
            "price": 15.5,
            "description": "A product for a test",
            "category": "electronics",
            "image": "https://example.com/product.png",
            "rating": {"rate": 4.2, "count": 12}
          }''',
          200,
        );
      }),
    );

    final product = await service.getProductDetails(productId: '1');

    expect(product.id, 1);
    expect(product.title, 'Sample product');
    expect(product.ratingCount, 12);
  });
}
