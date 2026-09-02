import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';
import '../widgets/category_filter.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _searchController = TextEditingController();
  ProductCategory _selectedCategory = ProductCategory.all;
  final Set<String> _favoriteIds = <String>{};
  int _selectedNavigationIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _visibleProducts {
    final query = _searchController.text.trim();

    return _previewProducts.where((product) {
      final matchesCategory = _selectedCategory == ProductCategory.all ||
          product.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          product.title.contains(query) ||
          product.description.contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = _visibleProducts;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'سلام، محمد 👋',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 3),
            Text(
              'محصولات منتخب',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: IconButton.filledTonal(
              tooltip: 'اعلان‌ها',
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'جست‌وجو بین محصولات',
                  prefixIcon: Icon(Icons.search_rounded),
                  suffixIcon: Icon(Icons.tune_rounded),
                ),
              ),
            ),
            SizedBox(
              height: 42,
              child: CategoryFilter(
                selectedCategory: _selectedCategory,
                onSelected: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
              child: Row(
                children: [
                  Text(
                    '${products.length} محصول',
                    style: const TextStyle(
                      color: Color(0xFF777285),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.swap_vert_rounded, size: 19),
                    label: const Text('مرتب‌سازی'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: products.isEmpty
                  ? const _EmptyProductsView()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 900
                            ? 4
                            : constraints.maxWidth >= 600
                                ? 3
                                : 2;
                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          itemCount: products.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: columns > 2 ? .71 : .64,
                          ),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              isFavorite: _favoriteIds.contains(product.id),
                              onFavoriteTap: () {
                                setState(() {
                                  if (!_favoriteIds.add(product.id)) {
                                    _favoriteIds.remove(product.id);
                                  }
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavigationIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedNavigationIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'فروشگاه',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'علاقه‌مندی‌ها',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag_rounded),
            label: 'سبد خرید',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'حساب کاربری',
          ),
        ],
      ),
    );
  }
}

class _EmptyProductsView extends StatelessWidget {
  const _EmptyProductsView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 54, color: Color(0xFF938FA1)),
          SizedBox(height: 12),
          Text(
            'محصولی پیدا نشد',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'عبارت یا دسته‌بندی دیگری را امتحان کن',
            style: TextStyle(color: Color(0xFF777285)),
          ),
        ],
      ),
    );
  }
}

const _previewProducts = <Product>[
  Product(
    id: 'wireless-headphones',
    title: 'هدفون بی‌سیم',
    description: 'صدای شفاف و حذف نویز',
    category: ProductCategory.electronics,
    price: 2490000,
    oldPrice: 2890000,
    rating: 4.8,
    reviewCount: 124,
  ),
  Product(
    id: 'smart-watch',
    title: 'ساعت هوشمند',
    description: 'پایش سلامت و ورزش',
    category: ProductCategory.electronics,
    price: 3190000,
    rating: 4.6,
    reviewCount: 86,
  ),
  Product(
    id: 'linen-shirt',
    title: 'پیراهن لینن',
    description: 'خنک، سبک و تابستانی',
    category: ProductCategory.fashion,
    price: 1190000,
    oldPrice: 1450000,
    rating: 4.7,
    reviewCount: 53,
  ),
  Product(
    id: 'table-lamp',
    title: 'چراغ رومیزی',
    description: 'نور ملایم برای مطالعه',
    category: ProductCategory.home,
    price: 890000,
    rating: 4.5,
    reviewCount: 31,
  ),
  Product(
    id: 'skin-care',
    title: 'کرم آبرسان',
    description: 'مناسب استفاده روزانه',
    category: ProductCategory.beauty,
    price: 645000,
    rating: 4.9,
    reviewCount: 77,
  ),
  Product(
    id: 'backpack',
    title: 'کوله‌پشتی شهری',
    description: 'جای لپ‌تاپ و وسایل روزمره',
    category: ProductCategory.fashion,
    price: 1690000,
    rating: 4.6,
    reviewCount: 42,
  ),
];
