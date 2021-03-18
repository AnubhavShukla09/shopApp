import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(
                  'This item will be removed!',
                ),
                content: Text(
                  'Are you sure?',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text(
                      'Yes',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text(
                      'No',
                    ),
                  ),
                ],
              )),
      key: ValueKey(productId),
      onDismissed: (_) => Provider.of<Cart>(
        context,
        listen: false,
      ).removeItem(productId),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(8.0),
      ),
      direction: DismissDirection.endToStart,
      child: Card(
        color: Colors.amber,
        elevation: 5,
        margin: EdgeInsets.all(7),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.black87,
              child: FittedBox(
                child: Text(
                  'Rs.${price * quantity}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text(price.toString()),
            trailing: Text('${quantity.toString()}x'),
          ),
        ),
      ),
    );
  }
}
