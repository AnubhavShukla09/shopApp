import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product({
    @required this.description,
    @required this.title,
    @required this.id,
    @required this.imageUrl,
    this.isFavourite = false,
    @required this.price,
  });

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final oldStatus = isFavourite;
    final url =
        'https://flutter-shop-8938d-default-rtdb.firebaseio.com/user_favourites/$userId/$id.json?auth=$token';
    isFavourite = (!isFavourite);
    notifyListeners();
    try {
      final response =
          await http.put(Uri.parse(url), body: json.encode(isFavourite));
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (_) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
