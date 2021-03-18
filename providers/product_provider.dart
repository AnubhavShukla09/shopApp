import 'package:flutter/material.dart';
import 'package:shop/model/http_exception.dart';
import 'package:shop/providers/product.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  String token;
  String userId;

  void update(String t) {
    token = t;
  }

  List<Product> get favouritesOnly {
    return _items.where((element) => element.isFavourite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id,
        orElse: () => _items[0]);
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://flutter-shop-8938d-default-rtdb.firebaseio.com/products.json';
    //JSON=> JavaScript Object Notation
    try {
      final value = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );

      final _newProduct = Product(
          description: product.description,
          title: product.title,
          id: json.decode(value.body)['name'],
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchData([bool filter = false]) async {
    String filterString = filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://flutter-shop-8938d-default-rtdb.firebaseio.com/products.json?auth=$token&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractData == null) {
        return;
      }
      final urlFav =
          'https://flutter-shop-8938d-default-rtdb.firebaseio.com/user_favourites/$userId.json?auth=$token';
      final favResponse = await http.get(Uri.parse(urlFav));
      final extractFavData = json.decode(favResponse.body);
      extractData.forEach((id, data) {
        loadedProducts.add(Product(
          description: data['description'],
          title: data['title'],
          id: id,
          imageUrl: data['imageUrl'],
          price: data['price'],
          isFavourite:
              extractFavData == null ? false : extractFavData[id] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    final url =
        'https://flutter-shop-8938d-default-rtdb.firebaseio.com/products/$productId.json';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl
        }));
    final index = _items.indexWhere((element) => element.id == productId);
    _items[index] = product;
    notifyListeners();
  }

  Future<void> removeProduct(String productId) async {
    final url =
        'https://flutter-shop-8938d-default-rtdb.firebaseio.com/products/$productId.json';
    final index = _items.indexWhere((element) => element.id == productId);
    var existingProduct = _items.elementAt(index);
    _items.removeAt(index);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(index, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete');
    }

    existingProduct = null;
  }
}
