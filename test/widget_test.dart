import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/entities/cart_item.dart';
import 'package:mini_shop/domain/product_details/usecases/get_product_details_use_case.dart';
import 'package:mini_shop/domain/repo/product_repository.dart';
import 'package:mini_shop/domain/repo/cart_repository.dart';
import 'package:mini_shop/presentation/app/mini_shop_app.dart';
import 'package:mini_shop/presentation/products/view_model/product_list_view_model.dart';
import 'package:mini_shop/presentation/products/widgets/product_card.dart';
import 'package:mini_shop/presentation/cart/view_model/cart_view_model.dart';

void main() {
  testWidgets('shows products supplied by the view model', (tester) async {
    final repository = _FakeProductRepository();
    final cartRepository = _FakeCartRepository();

    await tester.pumpWidget(
      MiniShopApp(
        viewModel: ProductListViewModel(repository),
        cartViewModel: CartViewModel(cartRepository),
        getProductDetailsUseCase: GetProductDetailsUseCase(repository),
      ),
    );
    await tester.pump();

    expect(find.text('Featured Products'), findsOneWidget);
    expect(find.text('Wireless headphones'), findsOneWidget);
    expect(find.text('Search products'), findsOneWidget);

    await tester.tap(find.byType(ProductCard));
    await tester.pump();
    await tester.pump();

    expect(find.text('Product Details'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);

    await tester.tap(find.textContaining('Add to Cart'));
    await tester.pump();
    expect(find.text('Added to cart.'), findsAtLeastNWidgets(1));

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cart'));
    await tester.pump();
    await tester.pump();

    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('Subtotal'), findsOneWidget);
  });
}

class _FakeCartRepository implements CartRepository {
  final List<CartItem> _items = [];

  @override
  Future<void> addProduct(Product product) async {
    _items.add(CartItem(product: product, quantity: 1));
  }

  @override
  Future<List<CartItem>> getCartItems() async => List.unmodifiable(_items);

  @override
  Future<void> removeProduct(String productId) async {
    _items.removeWhere((item) => item.product.id == productId);
  }

  @override
  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {}
}

class _FakeProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    return const [
      Product(
        id: '1',
        title: 'Wireless headphones',
        description: 'A product used by the widget test',
        imageUrl: '',
        category: ProductCategory.electronics,
        price: 15.5,
        rating: 4.2,
        reviewCount: 12,
      ),
    ];
  }

  @override
  Future<Product> getProductDetails({required String productId}) async {
    return (await getProducts()).first;
  }
}
