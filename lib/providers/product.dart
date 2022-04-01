import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../configs/environment.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String? userId;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.userId,
    this.isFavorite = false,
  });

  void _setFavoriteValue(value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;

    _setFavoriteValue(!isFavorite);

    final url = Uri.parse(
      '${Environment().config.baseUrl}userFavorites/$userId/$id.json?auth=$authToken',
    );
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
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
