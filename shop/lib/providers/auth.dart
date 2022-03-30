import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _userId;
  late DateTime? _expiryDate;
  late String? _token;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authentification(
      String? email, String? password, String signType) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$signType?key=AIzaSyBNuSkRyNNyCzsdLBmJQ62CfqxhpYsoEUM';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message']);
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String? email, String? password) async {
    return _authentification(email, password, 'signUp');
  }

  Future<void> login(String? email, String? password) async {
    return _authentification(email, password, 'signInWithPassword');
  }
}
