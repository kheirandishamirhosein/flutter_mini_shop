import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/in_memory_favorite_local_data_source.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  const product = Product(
    id: '1',
    title: 'Wireless headphones',
    description: 'A product used by the favorites test.',
    imageUrl: '',
    category: ProductCategory.electronics,
    price: 15.5,
  );

  test('stores a product once even when it is added repeatedly', () async {
    final dataSource = InMemoryFavoriteLocalDataSource();

    await dataSource.addFavorite(product);
    await dataSource.addFavorite(product);

    final favorites = await dataSource.getFavoriteProducts();

    expect(favorites, hasLength(1));
    expect(await dataSource.isFavorite(product.id), isTrue);
  });

  test('removes a product from favorites', () async {
    final dataSource = InMemoryFavoriteLocalDataSource();
    await dataSource.addFavorite(product);

    await dataSource.removeFavorite(product.id);

    expect(await dataSource.getFavoriteProducts(), isEmpty);
    expect(await dataSource.isFavorite(product.id), isFalse);
  });
}
