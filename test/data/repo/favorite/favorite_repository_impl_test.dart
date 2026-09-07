import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/in_memory_favorite_local_data_source.dart';
import 'package:mini_shop/data/repo/favorite/favorite_repository_impl.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  const product = Product(
    id: '1',
    title: 'Wireless headphones',
    description: 'A product used by the favorite repository test.',
    imageUrl: '',
    category: ProductCategory.electronics,
    price: 15.5,
  );

  test('exposes favorite actions through the domain repository', () async {
    final repository = FavoriteRepositoryImpl(
      InMemoryFavoriteLocalDataSource(),
    );

    await repository.addFavorite(product);

    expect(await repository.isFavorite(product.id), isTrue);
    expect((await repository.getFavoriteProducts()).single.id, product.id);

    await repository.removeFavorite(product.id);
    expect(await repository.isFavorite(product.id), isFalse);
  });
}
