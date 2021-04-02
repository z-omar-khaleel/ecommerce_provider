import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/product.dart';
import 'package:max_ecommerce/models/providers/products_details.dart';
import 'package:max_ecommerce/widgets/product_item.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BuildGridViewProductItems extends StatelessWidget {
  List<Product> products = [];
  final bool isFav;

  BuildGridViewProductItems(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductInfo>(context);
    products = isFav ? productData.faviorteProduct : productData.productItems;

    return GridView.builder(
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 10),
        itemBuilder: (_, i) {
          return ChangeNotifierProvider.value(
              //add all product to provider
              value: products[i],
              child: ProductItem());
        });
  }
}
