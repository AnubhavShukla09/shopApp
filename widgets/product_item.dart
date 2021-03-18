import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(
      context,
      listen: false,
    );
    final product = Provider.of<Product>(
      context,
      listen: false, //use false if you dont want the particular instance to
      //listen to the listener(commit changes when data changes in the class passed)
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            splashColor: Colors.lightGreen,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: Container(
            width: 150,
            child: GridTileBar(
              leading: Consumer<Product>(builder: (ctx, product, child) {
                return IconButton(
                  icon: product.isFavourite
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () =>
                      product.toggleFavouriteStatus(auth.token, auth.userId),
                  color: Theme.of(context).accentColor,
                );
              }),
              backgroundColor: Colors.black87,
              title: Text(
                product.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: Icon(Icons.shop),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Item Added'),
                    duration: Duration(
                      seconds: 3,
                    ),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeBySnackBar(product.id);
                        }),
                  ));
                },
                color: Theme.of(context).accentColor,
              ),
            ),
          )),
    );
  }
}
