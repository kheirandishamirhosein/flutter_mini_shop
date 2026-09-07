import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/in_memory_favorite_local_data_source.dart';
import 'package:mini_shop/data/repo/favorite/favorite_repository_impl.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/presentation/favorites/view_model/favorite_view_model.dart';

void main() {
  const product = Product(
    id: '1',
    title: 'Wireless headphones',
    description: 'A product used by the favorite view model test.',
    imageUrl: '',
    category: ProductCategory.electronics,
    price: 15.5,
  );

  test('adds then removes a product from shared favorite state', () async {
    final viewModel = FavoriteViewModel(
      FavoriteRepositoryImpl(InMemoryFavoriteLocalDataSource()),
    );

    await viewModel.loadFavorites();
    await viewModel.toggleFavorite(product);

    expect(viewModel.state.status, FavoriteStatus.success);
    expect(viewModel.isFavorite(product.id), isTrue);

    await viewModel.toggleFavorite(product);
    expect(viewModel.isFavorite(product.id), isFalse);
  });
}
