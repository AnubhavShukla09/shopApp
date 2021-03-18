import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/screens/edit_products_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshHandler(BuildContext ctx) async {
    await Provider.of<ProductProvider>(
      ctx,
      listen: false,
    ).fetchData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'User Products',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductsScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: _refreshHandler(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => _refreshHandler(context),
            child: Consumer(builder: (ctx, productData, child) {
              return ListView.builder(
                itemCount: productData.items.length,
                itemBuilder: (c, i) => Column(
                  children: [
                    UserProductItem(
                        productData.items[i].id,
                        productData.items[i].title,
                        productData.items[i].imageUrl),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
