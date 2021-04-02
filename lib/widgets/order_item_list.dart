import 'dart:math';

import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/order.dart';
import 'package:intl/intl.dart';

class OrderItemList extends StatefulWidget {
  final OrderItem order;

  OrderItemList({required this.order});

  @override
  _OrderItemListState createState() => _OrderItemListState();
}

class _OrderItemListState extends State<OrderItemList> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text('Time : ' +
                DateFormat('dd mm yyyy').format(widget.order.dataTime)),
            trailing: IconButton(
                icon: _expanded
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              height: min((widget.order.products.length * 20) + 10, 120),
              child: ListView(
                children: [
                  ...widget.order.products
                      .map((product) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '\$ ${product.price}',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ))
                      .toList()
                ],
              ),
            ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
