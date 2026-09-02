import 'package:flutter_test/flutter_test.dart';
import 'package:mini_shop/presentation/app/mini_shop_app.dart';

void main() {
  testWidgets('shows the product catalogue UI', (tester) async {
    await tester.pumpWidget(const MiniShopApp());

    expect(find.text('محصولات منتخب'), findsOneWidget);
    expect(find.text('هدفون بی‌سیم'), findsOneWidget);
    expect(find.text('جست‌وجو بین محصولات'), findsOneWidget);
  });
}
