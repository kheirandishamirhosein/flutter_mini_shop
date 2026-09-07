import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/remote/models/product_model.dart';
import 'package:mini_shop/data/remote/product_remote_data_source.dart';
import 'package:mini_shop/data/repo/product_repository_impl.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  test('maps remote product models into domain products', () async {
    final repository = ProductRepositoryImpl(_FakeRemoteDataSource());

    final products = await repository.getProducts();

    expect(products.single.id, '1');
    expect(products.single.category, ProductCategory.womensClothing);
    expect(products.single.imageUrl, 'https://example.com/product.png');
  });

  test('maps a remote product-details model into a domain product', () async {
    final repository = ProductRepositoryImpl(_FakeRemoteDataSource());

    final product = await repository.getProductDetails(productId: '1');

    expect(product.id, '1');
    expect(product.category, ProductCategory.jewelry);
    expect(product.price, 15.5);
  });

  test('maps API category names into domain categories', () async {
    final repository = ProductRepositoryImpl(_FakeRemoteDataSource());

    final categories = await repository.getProductCategories();

    expect(categories, [
      ProductCategory.electronics,
      ProductCategory.jewelry,
    ]);
  });

  test('gets products for the selected domain category', () async {
    final dataSource = _FakeRemoteDataSource();
    final repository = ProductRepositoryImpl(dataSource);

    final products = await repository.getProductsByCategory(
      category: ProductCategory.electronics,
    );

    expect(dataSource.requestedCategoryName, 'electronics');
    expect(products.single.category, ProductCategory.electronics);
  });
}

class _FakeRemoteDataSource implements ProductRemoteDataSource {
  String? requestedCategoryName;

  @override
  Future<List<ProductModel>> getProducts() async {
    return const [
      ProductModel(
        id: 1,
        title: 'Test product',
        price: 15.5,
        description: 'Description',
        category: "women's clothing",
        imageUrl: 'https://example.com/product.png',
        rating: 4.2,
        ratingCount: 12,
      ),
    ];
  }

  @override
  Future<List<String>> getProductCategories() async {
    return const ['electronics', 'jewelery'];
  }

  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String categoryName,
  }) async {
    requestedCategoryName = categoryName;
    return [
      ProductModel(
        id: 1,
        title: 'Test product',
        price: 15.5,
        description: 'Description',
        category: categoryName,
        imageUrl: 'https://example.com/product.png',
        rating: 4.2,
        ratingCount: 12,
      ),
    ];
  }

  @override
  Future<ProductModel> getProductDetails({required String productId}) async {
    return const ProductModel(
      id: 1,
      title: 'Test product',
      price: 15.5,
      description: 'Description',
      category: 'jewelery',
      imageUrl: 'https://example.com/product.png',
      rating: 4.2,
      ratingCount: 12,
    );
  }
}
