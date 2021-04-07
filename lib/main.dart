import 'package:flutter/material.dart';
import 'package:max_ecommerce/screens/auth_screen.dart';
import 'package:max_ecommerce/screens/edit_add_uuser_product_screen.dart';
import 'package:max_ecommerce/screens/order_screen.dart';
import 'package:max_ecommerce/screens/user_product_screen.dart';
import './models/providers/cart.dart';
import './models/providers/order.dart';
import './screens/cart_screen.dart';
import './screens/details_screen.dart';
import './screens/product_overview.dart';
import 'package:provider/provider.dart';

import 'models/providers/auth.dart';
import 'models/providers/products_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProxyProvider<Auth, ProductInfo>(
            create: (BuildContext context) {
              return ProductInfo();
            },
            update: (BuildContext context, value, previous) {
              return ProductInfo()
                ..updateState(
                    previous!.productItems!, value.getToken, value.getUserId);
            },
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (BuildContext context) {
              return Orders();
            },
            update: (BuildContext context, value, previous) {
              return Orders()
                ..getToken(value.getToken, previous!.orders, value.getUserId);
            },
          ),
        ],
        child: Consumer<Auth>(
          builder: (_, auth, child) => MaterialApp(
            routes: {
              DetailsScreen.detailsRout: (_) => DetailsScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrderScreen.roteName: (_) => OrderScreen(),
              ProductOverViewScreen.routeName: (_) => ProductOverViewScreen(),
              UserProductScreen.routeName: (_) => UserProductScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen(),
              AuthScreen.routeName: (_) => AuthScreen()
            },
            theme: ThemeData(
                fontFamily: 'Lato',
                primaryColor: Colors.purple,
                accentColor: Colors.deepOrange),
            home: auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    builder: (c, snapsot) =>
                        (snapsot.connectionState == ConnectionState.waiting)
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : AuthScreen(),
                    future: auth.autoLoginIn(),
                  ),
          ),
        ));
  }
}
