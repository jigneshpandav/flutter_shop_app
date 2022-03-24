import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;

    _setFavoriteValue(!isFavorite);

    final url = Uri.parse(
        'https://shop-app-50e0f-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
        throw Exception("Server error");
      }
    } catch (error) {
      _setFavoriteValue(oldStatus);
      rethrow;
    }
  }
}
