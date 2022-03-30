import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  late String _userId;
  late DateTime _expiryDate;
  late String _token;

  Future<void> signUp(String? email, String? password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBNuSkRyNNyCzsdLBmJQ62CfqxhpYsoEUM';
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
    if (response.statusCode != 200) {
      return;
    } else {
      print(json.decode(response.body));
    }
  }
}
