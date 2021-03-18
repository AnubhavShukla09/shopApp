import 'package:flutter/material.dart';
import 'package:shop/providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../widgets/order_items.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const routeName = '/order-details';

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('YOUR ORDERS'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(
            context,
            listen: false,
          ).fetchAndSetOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.error != null) {
              return Center(
                child: Text(
                  'Something went wrong!',
                ),
              );
            }
            return Consumer<Orders>(
              builder: (c, order, child) {
                return ListView.builder(
                  itemCount: order.items.length,
                  itemBuilder: (ctx, i) => OrderItems(order.items[i]),
                );
              },
            );
          },
        ));
  }
}
