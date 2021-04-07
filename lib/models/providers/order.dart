import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/cart.dart';
import 'package:http/http.dart' as http;

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
  String? userId;
  String? token;
  getToken(String? tokenId, List<OrderItem> orders, String? idUser) {
    token = tokenId;
    _orders = orders;
    userId = idUser;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final DateTime timeStamp = DateTime.now();
    final url = Uri.parse(
        'https://maxecommerce-fb341-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    final response = await http.post(url,
        body: jsonEncode({
          'amount': total,
          'dataTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cI) => {
                    'id': cI.id,
                    'title': cI.title,
                    'price': cI.price,
                    'quantity': cI.quantity
                  })
              .toList()
        }));
    if (response.statusCode > 400) {}
    _orders.add(OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dataTime: DateTime.now()));
    notifyListeners();
  }

  Future<void> getOrderFromWeb() async {
    final url = Uri.parse(
        'https://maxecommerce-fb341-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');
    List<OrderItem> loadedOrder = [];

    final response = await http.get(url);
    if ((!(response.statusCode >= 400))) {
      if (json.decode(response.body) != null) {
        final allData = json.decode(response.body) as Map<String, dynamic>;

        allData.forEach((key, orderItem) {
          final productsz = orderItem['products'] as List<dynamic>;

          loadedOrder.add(OrderItem(
              id: key,
              amount: orderItem['amount'],
              products: productsz
                  .map((item) => CartItem(
                      id: item['id'].toString(),
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price']))
                  .toList(),
              dataTime: DateTime.parse(orderItem['dataTime'])));
        });
        _orders = loadedOrder.reversed.toList();
        notifyListeners();
      }
    }
  }
}
