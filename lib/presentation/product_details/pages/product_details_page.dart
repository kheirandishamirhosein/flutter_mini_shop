import 'package:flutter/material.dart';

import '../../../domain/entities/product.dart';
import '../../cart/view_model/cart_view_model.dart';
import '../view_model/product_details_view_model.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    required this.productId,
    required this.viewModel,
    required this.cartViewModel,
    super.key,
  });

  final String productId;
  final ProductDetailsViewModel viewModel;
  final CartViewModel cartViewModel;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onStateChanged);
    widget.viewModel.loadProduct(widget.productId);
  }

  @override
  void dispose() {
    widget.viewModel
      ..removeListener(_onStateChanged)
      ..dispose();
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
    final product = state.product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          if (product != null)
            IconButton(
              tooltip:
                  _isFavorite ? 'Remove from favorites' : 'Add to favorites',
              onPressed: () => setState(() => _isFavorite = !_isFavorite),
              icon: Icon(
                _isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: switch (state.status) {
          ProductDetailsStatus.initial ||
          ProductDetailsStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          ProductDetailsStatus.failure => _ProductDetailsErrorView(
              message: state.errorMessage ?? 'Unable to load product details.',
              onRetry: () => widget.viewModel.loadProduct(widget.productId),
            ),
          ProductDetailsStatus.success => _ProductDetailsContent(
              product: product!,
            ),
        },
      ),
      bottomNavigationBar: product == null
          ? null
          : SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: FilledButton.icon(
                onPressed: () async {
                  final didAddProduct = await widget.cartViewModel.addProduct(
                    product,
                  );
                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        didAddProduct
                            ? 'Added to cart.'
                            : 'Unable to add this product to your cart.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label:
                    Text('Add to Cart · \$${product.price.toStringAsFixed(2)}'),
              ),
            ),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  const _ProductDetailsContent({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFF1EFFF),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 72,
                    color: Color(0xFF817C8C),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Chip(
            label: Text(_categoryLabel(product.category)),
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            side: BorderSide.none,
            backgroundColor: const Color(0xFFF1EFFF),
          ),
          const SizedBox(height: 12),
          Text(
            product.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFB22C)),
              const SizedBox(width: 5),
              Text(
                product.rating.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 6),
              Text(
                '(${product.reviewCount} reviews)',
                style: const TextStyle(color: Color(0xFF777285)),
              ),
              const Spacer(),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF4336D0),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 22),
            child: Divider(),
          ),
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: const TextStyle(
              color: Color(0xFF625D6B),
              fontSize: 15,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDetailsErrorView extends StatelessWidget {
  const _ProductDetailsErrorView({
    required this.message,
    required this.onRetry,
  });

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
              Icons.cloud_off_rounded,
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

String _categoryLabel(ProductCategory category) {
  return switch (category) {
    ProductCategory.all => 'All products',
    ProductCategory.electronics => 'Electronics',
    ProductCategory.jewelry => 'Jewelry',
    ProductCategory.mensClothing => "Men's clothing",
    ProductCategory.womensClothing => "Women's clothing",
  };
}
