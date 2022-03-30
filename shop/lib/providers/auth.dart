import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  late String _userId;
  late DateTime _expiryDate;
  late String _token;

  Future<void> _authentification(
      String? email, String? password, String signType) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$signType?key=AIzaSyBNuSkRyNNyCzsdLBmJQ62CfqxhpYsoEUM';
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

    print(json.decode(response.body));
  }

  Future<void> signUp(String? email, String? password) async {
   return _authentification(email, password, 'signUp');
  }

  Future<void> login(String? email, String? password) async {
   return _authentification(email, password, 'signInWithPassword');
  }
}
