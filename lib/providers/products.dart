import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../configs/environment.dart';
import 'product.dart';

class Products with ChangeNotifier {
  // final List<Product> _products = [
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

  final String? authToken;
  final String? userId;

  List<Product> _products = [];

  Products(this.authToken, this.userId, this._products);

  List<Product> get favoriteproducts {
    return products.where((product) => product.isFavorite == true).toList();
  }

  List<Product> get products {
    return [..._products];
  }

  Future<void> addProduct(Product product) async {
    var productIndex =
        _products.indexWhere((element) => element.id == product.id);
    if (productIndex <= -1) {
      try {
        final url = Uri.parse(
            '${Environment().config.baseUrl}products.json?auth=$authToken');
        final response = await http.post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'userId': userId,
              'price': product.price,
            }));

        _products.add(Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          userId: userId!,
        ));
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final String filter =
        filterByUser ? '&orderBy="userId"&equalTo="$userId"' : '';

    var url = Uri.parse(
        '${Environment().config.baseUrl}products.json?auth=$authToken$filter');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      url = Uri.parse(
        '${Environment().config.baseUrl}userFavorites/$userId.json?auth=$authToken',
      );
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);

      data.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            userId: prodData['userId'],
            isFavorite: favData == null ? false : favData[prodId] ?? false,
          ),
        );
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Product findById(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  Future<void> removeProduct(String productId) async {
    final url =
        Uri.parse('${Environment().config.baseUrl}products/$productId.json');
    final existingProductIndex =
        _products.indexWhere((product) => product.id == productId);
    Product existingProduct = _products[existingProductIndex];

    final response = await http.delete(url);
    _products.removeAt(existingProductIndex);
    notifyListeners();

    if (response.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    var productIndex =
        _products.indexWhere((element) => element.id == product.id);
    if (productIndex >= -1) {
      final url = Uri.parse(
          '${Environment().config.baseUrl}products/$productId.json?auth=$authToken');
      try {
        await http.patch(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price
            }));
        _products[productIndex] = product;
        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }
}
