import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' show Cart;
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('YOUR CART'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Card(
            color: Colors.amber,
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Consumer<Cart>(
              builder: (_, cart, __) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL AMOUNT:'),
                  Spacer(),
                  Chip(
                    backgroundColor: Colors.black87,
                    label: Text(
                      'Rs.${cart.totalAmount.toString()}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OrderButton(
                    cart: cart,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                productId: cart.items.keys.toList()[i],
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({Key key, this.cart}) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ?  CircularProgressIndicator()
          
        : TextButton(
            child: Text(
              'ORDER NOW',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: (widget.cart.totalAmount <= 0)
                ? null
                : () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Provider.of<Orders>(
                      context,
                      listen: false,
                    ).addOrder(widget.cart.items.values.toList(),
                        widget.cart.totalAmount);
                    setState(() {
                      _isLoading = false;
                    });
                    widget.cart.clearCart();
                    
                  },
          );
  }
}
