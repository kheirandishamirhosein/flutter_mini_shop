import 'package:flutter/material.dart';

import '../../../domain/entities/checkout_request.dart';
import '../../cart/view_model/cart_view_model.dart';
import '../view_model/checkout_view_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({
    required this.cartViewModel,
    required this.viewModel,
    super.key,
  });

  final CartViewModel cartViewModel;
  final CheckoutViewModel viewModel;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  CheckoutPaymentMethod _paymentMethod = CheckoutPaymentMethod.cashOnDelivery;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onStateChanged);
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submitOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final cartState = widget.cartViewModel.state;
    if (cartState.isEmpty) {
      return;
    }

    final completed = await widget.viewModel.submitOrder(
      CheckoutRequest(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        address: _addressController.text.trim(),
        paymentMethod: _paymentMethod,
        items: cartState.items,
      ),
    );

    if (!mounted) {
      return;
    }

    if (completed) {
      await widget.cartViewModel.loadCart();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.viewModel.state.errorMessage ?? 'Unable to place your order.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkoutState = widget.viewModel.state;
    if (checkoutState.status == CheckoutStatus.success) {
      return _OrderSuccessPage(orderId: checkoutState.order!.id);
    }

    final cartState = widget.cartViewModel.state;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              const Text(
                'Delivery details',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _fullNameController,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.telephoneNumber],
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: _phoneNumberValidator,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                minLines: 3,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.fullStreetAddress],
                decoration: const InputDecoration(
                  labelText: 'Delivery address',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 28),
              const Text(
                'Payment method',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    RadioListTile<CheckoutPaymentMethod>(
                      value: CheckoutPaymentMethod.cashOnDelivery,
                      groupValue: _paymentMethod,
                      title: const Text('Cash on delivery'),
                      subtitle: const Text('Pay when your order arrives.'),
                      onChanged: _selectPaymentMethod,
                    ),
                    const Divider(height: 1),
                    RadioListTile<CheckoutPaymentMethod>(
                      value: CheckoutPaymentMethod.cardOnDelivery,
                      groupValue: _paymentMethod,
                      title: const Text('Card on delivery'),
                      subtitle: const Text('Pay by card when it arrives.'),
                      onChanged: _selectPaymentMethod,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Order summary',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _OrderSummaryCard(
                itemCount: cartState.totalQuantity,
                total: cartState.subtotal,
              ),
              const SizedBox(height: 104),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This is a mock checkout. No payment will be collected.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF777285), fontSize: 12),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: checkoutState.isSubmitting || cartState.isEmpty
                    ? null
                    : _submitOrder,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: checkoutState.isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Place order • \$${cartState.subtotal.toStringAsFixed(2)}',
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectPaymentMethod(CheckoutPaymentMethod? paymentMethod) {
    if (paymentMethod == null) {
      return;
    }

    setState(() => _paymentMethod = paymentMethod);
  }

  String? _requiredValidator(String? value) {
    return value == null || value.trim().isEmpty
        ? 'This field is required.'
        : null;
  }

  String? _phoneNumberValidator(String? value) {
    final normalizedValue = value?.trim() ?? '';
    if (normalizedValue.isEmpty) {
      return 'This field is required.';
    }

    return normalizedValue.length < 8 ? 'Enter a valid phone number.' : null;
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.itemCount, required this.total});

  final int itemCount;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Items'),
                const Spacer(),
                Text('$itemCount'),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const Spacer(),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFF4336D0),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSuccessPage extends StatelessWidget {
  const _OrderSuccessPage({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order confirmed')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 72,
                color: Color(0xFF2E9B65),
              ),
              const SizedBox(height: 18),
              const Text(
                'Your mock order was placed!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Order ID: $orderId',
                style: const TextStyle(color: Color(0xFF777285)),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
