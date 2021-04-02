import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dataTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dataTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.add(OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dataTime: DateTime.now()));
    notifyListeners();
  }
}
