import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

import 'dart:convert';

class Products with ChangeNotifier {
  // final List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return items.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://shop-app-50e0f-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    var productIndex = _items.indexWhere((element) => element.id == product.id);
    if (productIndex <= -1) {
      try {
        final url = Uri.parse(
            'https://shop-app-50e0f-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
        final response = await http.post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
              'isFavorite': product.isFavorite,
            }));

        _items.add(Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          isFavorite: product.isFavorite,
        ));
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    var productIndex = _items.indexWhere((element) => element.id == product.id);
    if (productIndex >= -1) {
      final url = Uri.parse(
          'https://shop-app-50e0f-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json');
      try {
        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price
            }));
        _items[productIndex] = product;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> removeProduct(String productId) async {
    final url = Uri.parse(
        'https://shop-app-50e0f-default-rtdb.asia-southeast1.firebasedatabase.app/products/$productId.json');
    final existingProductIndex =
        _items.indexWhere((product) => product.id == productId);
    Product existingProduct = _items[existingProductIndex];

    final response = await http.delete(url);
    _items.removeAt(existingProductIndex);
    notifyListeners();

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    }
  }
}
