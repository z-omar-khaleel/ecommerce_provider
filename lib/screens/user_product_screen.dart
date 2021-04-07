import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/products_details.dart';
import 'package:max_ecommerce/screens/edit_add_uuser_product_screen.dart';
import 'package:max_ecommerce/widgets/app_drawer.dart';
import 'package:max_ecommerce/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'UserProductScreen';
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductInfo>(context, listen: false).getProductWeb(true);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding');
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
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.connectionState == ConnectionState.done)
            return RefreshIndicator(
              onRefresh: () => _refreshProduct(context),
              child: Consumer<ProductInfo>(
                builder: (c, products, _) => ListView.builder(
                  itemBuilder: (_, index) {
                    return UserProductItem(
                      title: products.productItems![index].title,
                      imgUrl: products.productItems![index].imageUrl,
                      id: products.productItems![index].id,
                    );
                  },
                  itemCount: products.productItems!.length,
                ),
              ),
            );
          return Center(child: Text('An Error Occurred'));
        },
      ),
    );
  }
}
