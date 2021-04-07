import 'package:flutter/material.dart';
import 'package:max_ecommerce/models/providers/order.dart';
import 'package:max_ecommerce/widgets/app_drawer.dart';
import 'package:max_ecommerce/widgets/order_item_list.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const roteName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _order;
  Future getFutureOnce() async {
    return await Provider.of<Orders>(context, listen: false).getOrderFromWeb();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _order = getFutureOnce();
    //OLD METHOD
    // Future.delayed(Duration.zero).then((value) async {
    //   setState(() {
    //     isLoading = true;
    //   });
    //   await Provider.of<Orders>(context, listen: false)
    //       .getOrderFromWeb(); //You can use it without Future.delayed() because listen=false
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context).orders;
    return Scaffold(
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _order,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data);
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemBuilder: (_, index) {
                  return OrderItemList(order: orderData[index]);
                },
                itemCount: orderData.length,
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Center(
              child: Text('Error Occurred'),
            );
          }),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
    );
  }
}
