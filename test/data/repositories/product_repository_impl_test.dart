import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/models/product_model.dart';
import 'package:mini_shop/data/remote/product_remote_data_source.dart';
import 'package:mini_shop/data/repositories/product_repository_impl.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  test('maps remote product models into domain products', () async {
    final repository = ProductRepositoryImpl(_FakeRemoteDataSource());

    final products = await repository.getProducts();

    expect(products.single.id, '1');
    expect(products.single.category, ProductCategory.womensClothing);
    expect(products.single.imageUrl, 'https://example.com/product.png');
  });
}

class _FakeRemoteDataSource implements ProductRemoteDataSource {
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
}
