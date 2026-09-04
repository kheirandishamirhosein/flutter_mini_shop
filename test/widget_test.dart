import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/product_details/usecases/get_product_details_use_case.dart';
import 'package:mini_shop/domain/repo/product_repository.dart';
import 'package:mini_shop/presentation/app/mini_shop_app.dart';
import 'package:mini_shop/presentation/products/view_model/product_list_view_model.dart';
import 'package:mini_shop/presentation/products/widgets/product_card.dart';

void main() {
  testWidgets('shows products supplied by the view model', (tester) async {
    final repository = _FakeProductRepository();

    await tester.pumpWidget(
      MiniShopApp(
        viewModel: ProductListViewModel(repository),
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
  });
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
