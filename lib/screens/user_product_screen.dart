import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/products_details.dart';
import 'package:max_ecommerce/screens/edit_add_uuser_product_screen.dart';
import 'package:max_ecommerce/widgets/app_drawer.dart';
import 'package:max_ecommerce/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'UserProductScreen';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductInfo>(context).productItems;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          return UserProductItem(
            title: products[index].title,
            imgUrl: products[index].imageUrl,
            id: products[index].id,
          );
        },
        itemCount: products.length,
      ),
    );
  }
}
