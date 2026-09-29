import 'package:flutter/material.dart';

import '../../../domain/entities/checkout_order.dart';
import '../../../domain/entities/checkout_request.dart';
import '../view_model/order_history_view_model.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({required this.viewModel, super.key});

  final OrderHistoryViewModel viewModel;

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.viewModel.loadOrders();
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
      appBar: AppBar(title: const Text('Order History')),
      body: SafeArea(
        top: false,
        child: switch (state.status) {
          OrderHistoryStatus.loading =>
            const Center(child: CircularProgressIndicator()),
          OrderHistoryStatus.failure => _OrderHistoryErrorView(
              message: state.errorMessage ?? 'Unable to load your orders.',
              onRetry: widget.viewModel.loadOrders,
            ),
          OrderHistoryStatus.success when state.isEmpty =>
            const _EmptyOrderHistoryView(),
          OrderHistoryStatus.success => RefreshIndicator(
              onRefresh: widget.viewModel.loadOrders,
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: state.orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) =>
                    _OrderTile(order: state.orders[index]),
              ),
            ),
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final CheckoutOrder order;

  @override
  Widget build(BuildContext context) {
    final request = order.request;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order ${order.id}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '\$${request.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF4336D0),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${request.totalQuantity} item${request.totalQuantity == 1 ? '' : 's'} • ${_formatDate(order.createdAt)}',
              style: const TextStyle(color: Color(0xFF777285)),
            ),
            const SizedBox(height: 4),
            Text(
              _paymentMethodLabel(request.paymentMethod),
              style: const TextStyle(color: Color(0xFF777285)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    return '${localDateTime.year}-${_twoDigits(localDateTime.month)}-${_twoDigits(localDateTime.day)}';
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String _paymentMethodLabel(CheckoutPaymentMethod paymentMethod) {
    return switch (paymentMethod) {
      CheckoutPaymentMethod.cashOnDelivery => 'Cash on delivery',
      CheckoutPaymentMethod.cardOnDelivery => 'Card on delivery',
    };
  }
}

class _EmptyOrderHistoryView extends StatelessWidget {
  const _EmptyOrderHistoryView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Color(0xFF777285),
            ),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              'Completed mock checkouts will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF777285)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderHistoryErrorView extends StatelessWidget {
  const _OrderHistoryErrorView({required this.message, required this.onRetry});

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
            const Icon(Icons.error_outline_rounded, size: 56),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}
