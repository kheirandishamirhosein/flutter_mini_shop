import 'package:flutter/material.dart';

import '../view_model/cart_view_model.dart';
import '../widgets/cart_item_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({required this.viewModel, super.key});

  final CartViewModel viewModel;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel
      ..addListener(_onStateChanged)
      ..loadCart();
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
        title: const Text('My Cart'),
        actions: [
          if (state.totalQuantity > 0)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 20),
              child: Center(
                child: Text(
                  '${state.totalQuantity} items',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: switch (state.status) {
          CartStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          CartStatus.failure => _CartErrorView(
              message: state.errorMessage ?? 'Unable to load your cart.',
              onRetry: widget.viewModel.loadCart,
            ),
          CartStatus.success when state.isEmpty => const _EmptyCartView(),
          CartStatus.success => ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return CartItemTile(
                  item: item,
                  onIncrease: () => widget.viewModel.updateQuantity(
                    productId: item.product.id,
                    quantity: item.quantity + 1,
                  ),
                  onDecrease: () => widget.viewModel.updateQuantity(
                    productId: item.product.id,
                    quantity: item.quantity - 1,
                  ),
                  onRemove: () => widget.viewModel.removeProduct(
                    item.product.id,
                  ),
                );
              },
            ),
        },
      ),
      bottomNavigationBar: state.status != CartStatus.success || state.isEmpty
          ? null
          : SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '\$${state.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFF4336D0),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout will be available soon.'),
                          ),
                        );
                      },
                      child: const Text('Checkout'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 58,
              color: Color(0xFF938FA1),
            ),
            SizedBox(height: 14),
            Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 6),
            Text(
              'Add a product to see it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF777285)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartErrorView extends StatelessWidget {
  const _CartErrorView({required this.message, required this.onRetry});

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
