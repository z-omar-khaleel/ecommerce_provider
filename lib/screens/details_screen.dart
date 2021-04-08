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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 20,
            ),
            Text(
              '\$ ' + product.price.toString(),
              style: TextStyle(fontSize: 25, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
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
            ),
            SizedBox(
              height: 800,
            )
          ]))
        ],
      ),
    );
  }
}
