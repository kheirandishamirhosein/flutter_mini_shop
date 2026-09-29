import 'dart:convert';

import '../../domain/entities/cart_item.dart';
import '../../domain/entities/checkout_order.dart';
import '../../domain/entities/checkout_request.dart';
import 'checkout_local_data_source.dart';
import 'key_value_storage.dart';
import 'product_local_mapper.dart';

/// Stores mock checkout orders locally so the order history survives restarts.
class SharedPreferencesCheckoutLocalDataSource
    implements CheckoutLocalDataSource {
  const SharedPreferencesCheckoutLocalDataSource(this._storage);

  static const _ordersKey = 'checkout_orders';

  final KeyValueStorage _storage;

  @override
  Future<CheckoutOrder> placeOrder(CheckoutRequest request) async {
    final orders = await getOrders();
    final order = CheckoutOrder(
      id: 'MS-${(orders.length + 1).toString().padLeft(4, '0')}',
      request: request,
      createdAt: DateTime.now(),
    );

    await _saveOrders([...orders, order]);
    return order;
  }

  @override
  Future<List<CheckoutOrder>> getOrders() async {
    final encodedOrders = await _storage.getString(_ordersKey);
    if (encodedOrders == null) {
      return const [];
    }

    try {
      final decodedOrders = jsonDecode(encodedOrders);
      if (decodedOrders is! List) {
        return const [];
      }

      return decodedOrders.map(_orderFromJson).toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  Future<void> _saveOrders(List<CheckoutOrder> orders) {
    return _storage.setString(
      _ordersKey,
      jsonEncode(orders.map(_orderToJson).toList(growable: false)),
    );
  }

  CheckoutOrder _orderFromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Order is not an object.');
    }

    final id = json['id'];
    final createdAt = json['createdAt'];
    final request = json['request'];
    if (id is! String ||
        createdAt is! String ||
        request is! Map<String, dynamic>) {
      throw const FormatException('Order has invalid values.');
    }

    return CheckoutOrder(
      id: id,
      createdAt: DateTime.parse(createdAt),
      request: _requestFromJson(request),
    );
  }

  CheckoutRequest _requestFromJson(Map<String, dynamic> json) {
    final fullName = json['fullName'];
    final phoneNumber = json['phoneNumber'];
    final address = json['address'];
    final paymentMethodName = json['paymentMethod'];
    final items = json['items'];
    if (fullName is! String ||
        phoneNumber is! String ||
        address is! String ||
        paymentMethodName is! String ||
        items is! List) {
      throw const FormatException('Checkout request has invalid values.');
    }

    final paymentMethod = CheckoutPaymentMethod.values
        .where((value) => value.name == paymentMethodName)
        .firstOrNull;
    if (paymentMethod == null) {
      throw const FormatException(
          'Checkout request has an invalid payment method.');
    }

    return CheckoutRequest(
      fullName: fullName,
      phoneNumber: phoneNumber,
      address: address,
      paymentMethod: paymentMethod,
      items: items.map(_cartItemFromJson).toList(growable: false),
    );
  }

  CartItem _cartItemFromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Order item is not an object.');
    }

    final quantity = json['quantity'];
    if (quantity is! int || quantity <= 0) {
      throw const FormatException('Order item has an invalid quantity.');
    }

    return CartItem(
      product: ProductLocalMapper.fromJson(json),
      quantity: quantity,
    );
  }

  Map<String, Object> _orderToJson(CheckoutOrder order) {
    return <String, Object>{
      'id': order.id,
      'createdAt': order.createdAt.toIso8601String(),
      'request': <String, Object>{
        'fullName': order.request.fullName,
        'phoneNumber': order.request.phoneNumber,
        'address': order.request.address,
        'paymentMethod': order.request.paymentMethod.name,
        'items': order.request.items
            .map(
              (item) => <String, Object>{
                ...ProductLocalMapper.toJson(item.product),
                'quantity': item.quantity,
              },
            )
            .toList(growable: false),
      },
    };
  }
}
