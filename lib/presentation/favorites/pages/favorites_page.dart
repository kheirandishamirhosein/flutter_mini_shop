import 'package:flutter/material.dart';

import '../../../domain/product_details/usecases/get_product_details_use_case.dart';
import '../../cart/view_model/cart_view_model.dart';
import '../../product_details/pages/product_details_page.dart';
import '../../product_details/view_model/product_details_view_model.dart';
import '../../products/widgets/product_card.dart';
import '../view_model/favorite_view_model.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({
    required this.viewModel,
    required this.cartViewModel,
    required this.getProductDetailsUseCase,
    super.key,
  });

  final FavoriteViewModel viewModel;
  final CartViewModel cartViewModel;
  final GetProductDetailsUseCase getProductDetailsUseCase;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.viewModel.loadFavorites();
      }
    });
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          if (state.products.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 20),
              child: Center(
                child: Text(
                  '${state.products.length} items',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: switch (state.status) {
          FavoriteStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
          FavoriteStatus.failure => _FavoritesErrorView(
              message: state.errorMessage ?? 'Unable to load favorites.',
              onRetry: widget.viewModel.loadFavorites,
            ),
          FavoriteStatus.success when state.isEmpty =>
            const _EmptyFavoritesView(),
          FavoriteStatus.success => LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900
                    ? 4
                    : constraints.maxWidth >= 600
                        ? 3
                        : 2;
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  itemCount: state.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: columns > 2 ? .71 : .64,
                  ),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductCard(
                      product: product,
                      isFavorite: true,
                      onFavoriteTap: () {
                        widget.viewModel.toggleFavorite(product);
                      },
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => ProductDetailsPage(
                              productId: product.id,
                              viewModel: ProductDetailsViewModel(
                                widget.getProductDetailsUseCase,
                              ),
                              cartViewModel: widget.cartViewModel,
                              favoriteViewModel: widget.viewModel,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
        },
      ),
    );
  }
}

class _EmptyFavoritesView extends StatelessWidget {
  const _EmptyFavoritesView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 58,
              color: Color(0xFF938FA1),
            ),
            SizedBox(height: 14),
            Text(
              'No favorites yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 6),
            Text(
              'Tap the heart on a product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF777285)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesErrorView extends StatelessWidget {
  const _FavoritesErrorView({required this.message, required this.onRetry});

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
            const Icon(
              Icons.error_outline_rounded,
              size: 54,
              color: Color(0xFF938FA1),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
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
