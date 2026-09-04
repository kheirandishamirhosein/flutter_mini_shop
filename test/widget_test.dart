import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/domain/entities/product.dart';
import 'package:mini_shop/domain/repositories/product_repository.dart';
import 'package:mini_shop/presentation/app/mini_shop_app.dart';
import 'package:mini_shop/presentation/products/view_model/product_list_view_model.dart';

void main() {
  testWidgets('shows products supplied by the view model', (tester) async {
    await tester.pumpWidget(
      MiniShopApp(
        viewModel: ProductListViewModel(_FakeProductRepository()),
      ),
    );
    await tester.pump();

    expect(find.text('محصولات منتخب'), findsOneWidget);
    expect(find.text('Wireless headphones'), findsOneWidget);
    expect(find.text('جست‌وجو بین محصولات'), findsOneWidget);
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
}
