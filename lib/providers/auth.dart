import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/configs/environment.dart';
import 'package:flutter_shop_app/models/http_exceptions.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  DateTime? _expiryDate;
  late String _userId;

  bool get isAuthenticated {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Uri _url(String identifier) {
    return Uri.parse(
      '${Environment().config.firebaseAuthBaseUrl}$identifier?key=${Environment().config.firebaseAuthKey}',
    );
  }

  Future<void> authenticate(
      String email, String password, String identifier) async {
    try {
      final url = _url(identifier);
      print('url: $url');
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        const Duration(
          seconds: 3600,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
