import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/data/local/in_memory_cart_local_data_source.dart';
import 'package:mini_shop/domain/entities/product.dart';

void main() {
  const product = Product(
    id: '1',
    title: 'Wireless headphones',
    description: 'A product used by the cart test.',
    imageUrl: '',
    category: ProductCategory.electronics,
    price: 15.5,
  );

  test('adds the same product by increasing its quantity', () async {
    final dataSource = InMemoryCartLocalDataSource();

    await dataSource.addProduct(product);
    await dataSource.addProduct(product);

    final items = await dataSource.getCartItems();

    expect(items, hasLength(1));
    expect(items.single.quantity, 2);
    expect(items.single.totalPrice, 31);
  });

  test('removes an item when its quantity becomes zero', () async {
    final dataSource = InMemoryCartLocalDataSource();
    await dataSource.addProduct(product);

    await dataSource.updateQuantity(productId: product.id, quantity: 0);

    expect(await dataSource.getCartItems(), isEmpty);
  });
}
