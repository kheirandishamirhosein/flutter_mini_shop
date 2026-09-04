import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';
import '../view_model/product_list_view_model.dart';
import '../widgets/category_filter.dart';
import '../widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({required this.viewModel, super.key});

  final ProductListViewModel viewModel;

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _searchController = TextEditingController();
  ProductCategory _selectedCategory = ProductCategory.all;
  final Set<String> _favoriteIds = <String>{};
  int _selectedNavigationIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onStateChanged);
    widget.viewModel.loadProducts();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onStateChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Product> get _visibleProducts {
    final query = _searchController.text.trim().toLowerCase();
    final products = widget.viewModel.state.products;

    return products.where((product) {
      final matchesCategory = _selectedCategory == ProductCategory.all ||
          product.category == _selectedCategory;
      final matchesQuery = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final products = _visibleProducts;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Amirhosein 👋',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 3),
            Text(
              'Featured Products',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: IconButton.filledTonal(
              tooltip: 'Notifications',
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
                  hintText: 'Search products',
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
                    state.status == ProductListStatus.success
                        ? '${products.length} products'
                        : 'Products',
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
                    label: const Text('Sort'),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildContent(state, products)),
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
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag_rounded),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProductListState state, List<Product> products) {
    return switch (state.status) {
      ProductListStatus.loading =>
        const Center(child: CircularProgressIndicator()),
      ProductListStatus.failure => _ProductsErrorView(
          onRetry: widget.viewModel.loadProducts,
          message: state.errorMessage ?? 'Unable to load products.',
        ),
      ProductListStatus.success when products.isEmpty =>
        const _EmptyProductsView(),
      ProductListStatus.success => LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900
                ? 4
                : constraints.maxWidth >= 600
                    ? 3
                    : 2;
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
    };
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
            'No products found',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Try a different search term or category.',
            style: TextStyle(color: Color(0xFF777285)),
          ),
        ],
      ),
    );
  }
}

class _ProductsErrorView extends StatelessWidget {
  const _ProductsErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 54, color: Color(0xFF938FA1)),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
