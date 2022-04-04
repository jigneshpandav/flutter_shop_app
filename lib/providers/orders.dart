import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../configs/environment.dart';
import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String? authToken;
  final String? userId;

  List<OrderItem> _orders = [];

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final url = Uri.parse(
          '${Environment().config.baseUrl}orders/$userId.json?auth=$authToken');
      final timestamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'quantity': e.quantity,
                      'price': e.price,
                    })
                .toList()
          }));

      if (response.statusCode >= 400) {
        throw Exception("Server error");
      }

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
      "${Environment().config.baseUrl}orders/$userId.json?auth=$authToken",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw Exception("Server error");
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> orders = [];
      data.forEach((orderId, orderData) {
        orders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>).map((e) {
              return CartItem(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e['quantity']);
            }).toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
        _orders = orders.reversed.toList();
        notifyListeners();
      });
    } catch (error) {
      rethrow;
    }
  }
}
