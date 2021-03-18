import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/screens/user_products_screen.dart';
import '../screens/order_details_screen.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'HELLO FRIEND!',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Text(
              'SHOP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.shop_outlined),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Text(
              'ORDERS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.payment_outlined),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrderDetailsScreen.routeName);
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Text(
              'MANAGE PRODUCTS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.edit),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: Text(
              'LOG OUT',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.logout),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/');
              return Provider.of<Auth>(
                context,
                listen: false,
              ).logout;
            },
          ),
        ],
      ),
    );
  }
}
