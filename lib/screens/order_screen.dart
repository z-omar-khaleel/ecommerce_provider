import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/order.dart';
import 'package:max_ecommerce/widgets/app_drawer.dart';
import 'package:max_ecommerce/widgets/order_item_list.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const roteName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context).orders;
    return Scaffold(
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (_, index) {
          return OrderItemList(order: orderData[index]);
        },
        itemCount: orderData.length,
      ),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
    );
  }
}
