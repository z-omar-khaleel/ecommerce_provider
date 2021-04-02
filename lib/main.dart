import 'package:flutter/material.dart';
import 'package:max_ecommerce/screens/edit_add_uuser_product_screen.dart';
import 'package:max_ecommerce/screens/order_screen.dart';
import 'package:max_ecommerce/screens/user_product_screen.dart';
import './models/providers/cart.dart';
import './models/providers/order.dart';
import './screens/cart_screen.dart';
import './screens/details_screen.dart';
import './screens/product_overview.dart';
import 'package:provider/provider.dart';

import 'models/providers/products_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductInfo()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: MaterialApp(
        routes: {
          DetailsScreen.detailsRout: (_) => DetailsScreen(),
          CartScreen.routeName: (_) => CartScreen(),
          OrderScreen.roteName: (_) => OrderScreen(),
          ProductOverViewScreen.routeName: (_) => ProductOverViewScreen(),
          UserProductScreen.routeName: (_) => UserProductScreen(),
          EditProductScreen.routeName: (_) => EditProductScreen()
        },
        theme: ThemeData(
            fontFamily: 'Lato',
            primaryColor: Colors.purple,
            accentColor: Colors.deepOrange),
        home: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductOverViewScreen(),
    );
  }
}
