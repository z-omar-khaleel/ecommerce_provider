import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/products_details.dart';
import 'package:max_ecommerce/screens/edit_add_uuser_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String title, imgUrl, id;

  UserProductItem(
      {required this.title, required this.imgUrl, required this.id});

  @override
  Widget build(BuildContext context) {
    final scaffolfmessage = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<ProductInfo>(context, listen: false)
                      .deleteProduct(id);
                } on Exception catch (error) {
                  scaffolfmessage.showSnackBar(SnackBar(
                      content: Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                  )));
                }
              },
              color: Theme.of(context).errorColor,
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                },
                color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
