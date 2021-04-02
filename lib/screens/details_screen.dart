import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/products_details.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  static final String detailsRout = 'detailsScreen';
  DetailsScreen();

  @override
  Widget build(BuildContext context) {
    final val = ModalRoute.of(context)?.settings.arguments as String;
    final product = Provider.of<ProductInfo>(context).findById(val);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                height: 300,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              height: 20,
            ),
            Text(
              '\$ ' + product.price.toString(),
              style: TextStyle(fontSize: 25, color: Colors.grey.shade500),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
