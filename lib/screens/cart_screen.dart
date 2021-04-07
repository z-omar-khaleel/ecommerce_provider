import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/order.dart';
import '../models/providers/cart.dart'
    show Cart; // just access the cart class from file
import '../widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static final routeName = 'CartScreen';
  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ' + providerData.totalAmount.toStringAsFixed(3),
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              ?.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // ignore: deprecated_member_use
                  FlatButtomOrder(providerData: providerData)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (_, index) {
              return CartItemList(
                  productId: providerData.cartItems.keys.toList()[index],
                  id: providerData.cartItems.values.toList()[index].id,
                  title: providerData.cartItems.values.toList()[index].title,
                  quantity:
                      providerData.cartItems.values.toList()[index].quantity,
                  price: providerData.cartItems.values.toList()[index].price);
            },
            itemCount: providerData.itemCount,
          ))
        ],
      ),
    );
  }
}

class FlatButtomOrder extends StatefulWidget {
  const FlatButtomOrder({
    Key? key,
    required this.providerData,
  }) : super(key: key);

  final Cart providerData;

  @override
  _FlatButtomOrderState createState() => _FlatButtomOrderState();
}

class _FlatButtomOrderState extends State<FlatButtomOrder> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return isLoading
        ? CircularProgressIndicator()
        // ignore: deprecated_member_use
        : FlatButton(
            onPressed: (widget.providerData.totalAmount <= 0 || isLoading)
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });
                    await Provider.of<Orders>(context, listen: false).addOrder(
                        widget.providerData.cartItems.values.toList(),
                        widget.providerData.totalAmount);
                    setState(() {
                      isLoading = false;
                    });
                    widget.providerData.clearCart();
                  },
            child: Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ));
  }
}
