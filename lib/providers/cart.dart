import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _products = {};

  Map<String, CartItem> get products {
    return {..._products};
  }

  int get itemCount {
    return _products.length;
  }

  double get totalAmount {
    double total = 0.0;
    _products.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_products.containsKey(productId)) {
      // change quantity...
      _products.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _products.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _products.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_products.containsKey(productId)) {
      return;
    } else {
      if (_products[productId]!.quantity > 1) {
        _products.update(
          productId,
          (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1,
            price: existingCartItem.price,
          ),
        );
      } else {
        _products.remove(productId);
      }
    }
    notifyListeners();
  }

  void clear() {
    _products = {};
    notifyListeners();
  }
}
