import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/auth.dart';
import 'package:max_ecommerce/models/providers/cart.dart';
import 'package:max_ecommerce/models/providers/product.dart';
import 'package:max_ecommerce/screens/details_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  ProductItem();

  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(DetailsScreen.detailsRout, arguments: product.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/6.2_product-placeholder.png'),
                image: NetworkImage(
                  product.imageUrl,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          footer: GridTileBar(
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.shopping_cart_rounded),
              onPressed: () {
                Provider.of<Cart>(context, listen: false)
                    .addItems(product.title, product.price, product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added item to cart !'),
                    duration: Duration(seconds: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
              },
            ),
            leading: Consumer<Product>(
              builder: (_, product1, child) => IconButton(
                color: Theme.of(context).accentColor,
                icon: Icon(product.isFaviourte
                    ? Icons.favorite
                    : Icons.favorite_outline_rounded),
                onPressed: () {
                  product1.toggleIsFaviorteState(auth.getToken, auth.getUserId);
                },
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            backgroundColor: Colors.black87,
          ),
        ),
      ),
    );
  }
}
