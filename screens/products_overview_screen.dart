import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product_provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/products_grid.dart';
import './cart_screen.dart';

enum Display {
  All,
  Favourites,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavourites = false;
  var _firstInit = true;
  var _isLoaded = false;

  @override
  void didChangeDependencies() {
    if (_firstInit) {
      setState(() {
        _isLoaded = true;
      });
      Provider.of<ProductProvider>(context).fetchData().then((value) {
        setState(() {
          _isLoaded = false;
        });
      });
    }
    _firstInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text(
            'MY SHOP',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton(
              onSelected: (Display selected) {
                setState(() {
                  if (selected == Display.All) {
                    _showOnlyFavourites = false;
                  } else {
                    _showOnlyFavourites = true;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text(
                    'SHOW FAVOURITES ONLY',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: Display.Favourites,
                ),
                PopupMenuItem(
                  child: Text(
                    'SHOW ALL',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: Display.All,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoaded
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showOnlyFavourites));
  }
}
