import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/in_memory_cart_local_data_source.dart';
import 'package:mini_shop/data/repo/cart/cart_repository_impl.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/presentation/cart/view_model/cart_view_model.dart';

void main() {
  const product = Product(
    id: '1',
    title: 'Wireless headphones',
    description: 'A product used by the cart view model test.',
    imageUrl: '',
    category: ProductCategory.electronics,
    price: 15.5,
  );

  test('updates item count and subtotal after cart actions', () async {
    final viewModel = CartViewModel(
      CartRepositoryImpl(InMemoryCartLocalDataSource()),
    );

    await viewModel.addProduct(product);
    await viewModel.addProduct(product);

    expect(viewModel.state.status, CartStatus.success);
    expect(viewModel.state.totalQuantity, 2);
    expect(viewModel.state.subtotal, 31);

    await viewModel.updateQuantity(productId: product.id, quantity: 1);
    expect(viewModel.state.totalQuantity, 1);

    await viewModel.removeProduct(product.id);
    expect(viewModel.state.isEmpty, isTrue);
  });
}
