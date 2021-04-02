import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItemList extends StatelessWidget {
  final String id;
  final int quantity;
  final double price;
  final String title;
  final String productId;

  CartItemList(
      {required this.id,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart)
          return showDialog<bool>(
            context: context,
            barrierDismissible: true,
            // false = user must tap button, true = tap outside dialog
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                backgroundColor: Colors.redAccent,
                title: Text('Remove Item'),
                content: Text('Are You Sure You want to remove an item !!'),
                actions: <Widget>[
                  TextButton(
                    child: Text('yes'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true);
                      // Dismiss alert dialog
                    },
                  ),
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(false);
                    },
                  ),
                ],
              );
            },
          );
        return Future.value(false);
      },
      background: Container(
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {},
        ),
      ),
      onDismissed: (dir) {
        Provider.of<Cart>(context, listen: false).removeCartItem(productId);
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 40,
              child: Text('\$ $price'),
            ),
            title: Text(title),
            subtitle:
                Text('Total : \$ ${(price * quantity).toStringAsFixed(3)}'),
            trailing: Text(quantity.toString() + 'x'),
          ),
        ),
      ),
    );
  }
}
