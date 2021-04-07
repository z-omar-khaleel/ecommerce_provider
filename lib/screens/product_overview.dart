import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/cart.dart';
import 'package:max_ecommerce/models/providers/products_details.dart';
import 'package:max_ecommerce/screens/cart_screen.dart';
import 'package:max_ecommerce/widgets/app_drawer.dart';
import 'package:max_ecommerce/widgets/gridview_product.dart';
import 'package:provider/provider.dart';

enum chooseFilters { Faviourte, all }

class ProductOverViewScreen extends StatefulWidget {
  bool isInit = true;

  static const routeName = 'Product_overview';
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool isFav = false;
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (widget.isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductInfo>(context).getProductWeb().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }

    widget.isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      centerTitle: true,
      actions: [
        Consumer<Cart>(
          builder: (BuildContext context, value, Widget? child) => Badge(
            position: BadgePosition.topStart(start: 5),
            badgeContent: Text(value.itemCount.toString()),
            child: child,
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_cart_rounded),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        ),
        PopupMenuButton(
            onSelected: (chooseFilters fav) {
              setState(() {
                if (fav == chooseFilters.Faviourte) {
                  isFav = true;
                } else {
                  isFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text('show All'),
                    value: chooseFilters.all,
                  ),
                  PopupMenuItem(
                    child: Text('show Favourite'),
                    value: chooseFilters.Faviourte,
                  ),
                ]),
      ],
      title: Text('MyShop'),
    );
    return Scaffold(
      drawer: AppDrawer(),
      appBar: appBar,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SafeArea(
                child: BuildGridViewProductItems(isFav),
              ),
            ),
    );
  }
}
