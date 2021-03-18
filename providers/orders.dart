import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItems with ChangeNotifier {
  final String id;
  final double total;
  final List<CartItems> products;
  final DateTime date;
  OrderItems({
    @required this.date,
    @required this.id,
    @required this.products,
    @required this.total,
  });
}

class Orders with ChangeNotifier {
  List<OrderItems> _items = []; //inside this class,use _items

  String token;
  String userId;

  List<OrderItems> get items //outside this class use items
  {
    return [..._items];
  }

  void update(String t, String uId) {
    token = t;
    userId = uId;
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-shop-8938d-default-rtdb.firebaseio.com/orders/$userId?auth=$token';
    final response = await http.get(Uri.parse(url));
    final List<OrderItems> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((key, value) {
      loadedOrders.add(OrderItems(
          date: DateTime.parse(value['dateTime']),
          id: key,
          products: (value['products'] as List<dynamic>)
              .map((item) => CartItems(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']))
              .toList(),
          total: value['amount']));
    });
    _items = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItems> products, double total) async {
    final url =
        'https://flutter-shop-8938d-default-rtdb.firebaseio.com/orders/$userId?auth=$token';
    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': products
              .map((cartItems) => {
                    'id': cartItems.id,
                    'price': cartItems.price,
                    'quantity': cartItems.quantity,
                    'title': cartItems.title
                  })
              .toList(),
        }));
    _items.add(OrderItems(
      date: timeStamp,
      id: json.decode(response.body)['name'],
      products: products,
      total: total,
    ));
    notifyListeners();
  }
}
