import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/key_value_storage.dart';
import 'package:mini_shop/data/local/shared_preferences_favorite_local_data_source.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  const product = Product(
    id: '1',
    title: 'Wireless headphones',
    description: 'A product used by the persistent favorites test.',
    imageUrl: 'https://example.com/product.png',
    category: ProductCategory.electronics,
    price: 15.5,
    rating: 4.5,
    reviewCount: 12,
  );

  test('restores favorite products after the data source is recreated',
      () async {
    final storage = _FakeKeyValueStorage();
    final dataSource = SharedPreferencesFavoriteLocalDataSource(storage);

    await dataSource.addFavorite(product);

    final recreatedDataSource = SharedPreferencesFavoriteLocalDataSource(
      storage,
    );
    final favorites = await recreatedDataSource.getFavoriteProducts();

    expect(favorites, hasLength(1));
    expect(favorites.single.id, product.id);
    expect(favorites.single.title, product.title);
    expect(favorites.single.category, ProductCategory.electronics);
    expect(await recreatedDataSource.isFavorite(product.id), isTrue);
  });

  test('removes a persisted favorite product', () async {
    final dataSource = SharedPreferencesFavoriteLocalDataSource(
      _FakeKeyValueStorage(),
    );
    await dataSource.addFavorite(product);

    await dataSource.removeFavorite(product.id);

    expect(await dataSource.getFavoriteProducts(), isEmpty);
    expect(await dataSource.isFavorite(product.id), isFalse);
  });

  test('returns empty favorites for malformed stored data', () async {
    final dataSource = SharedPreferencesFavoriteLocalDataSource(
      _FakeKeyValueStorage()..values['favorite_products'] = 'not valid json',
    );

    expect(await dataSource.getFavoriteProducts(), isEmpty);
  });
}

class _FakeKeyValueStorage implements KeyValueStorage {
  final values = <String, String>{};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }
}
