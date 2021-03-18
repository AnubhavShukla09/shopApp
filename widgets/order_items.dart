import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItems extends StatefulWidget {
  final ord.OrderItems order;
  OrderItems(this.order);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expandable = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Rs.${widget.order.total}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            subtitle: Text(
              DateFormat('dd-MM-yyyy hh:mm').format(widget.order.date),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            trailing: IconButton(
                color: Colors.white,
                icon: _expandable
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expandable = !_expandable;
                  });
                }),
          ),
          if (_expandable)
            Container(
              color: Colors.black,
              height: min(widget.order.products.length * 20.0 + 10.0, 180.0),
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.order.products[i].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${widget.order.products[i].quantity}x ${widget.order.products[i].price}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
