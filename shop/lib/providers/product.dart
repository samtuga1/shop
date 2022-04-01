import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shop/models/http_exception.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    bool existingProductLikeStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shop-12901-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json/?auth=$token';
    final response = await http.put(
      Uri.parse(url),
      body: json.encode(
          isFavorite,
      ),
    );
    if (response.statusCode >= 400) {
      isFavorite = existingProductLikeStatus;
      notifyListeners();
      throw HttpException('An error occured');
    }
  }
}
