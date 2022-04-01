import 'package:flutter/material.dart';
import 'package:shop/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product>? _items = [];

  String? authToken;
  String? userId;

  Products(this.authToken, this.userId, this._items);
  Products.diffConstructor();

  List<Product> get favoriteItems {
    return _items!.where((prodItem) => prodItem.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items!];
  }

  Product findById(id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> getAndSetProducts(bool filterByUser) async {
    final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shop-12901-default-rtdb.firebaseio.com/products.json/?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      var extractedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      if (extractedResponse.isEmpty) {
        return;
      }
      url = 'https://shop-12901-default-rtdb.firebaseio.com/userFavorites/$userId.json/?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favData = json.decode(favoriteResponse.body);
      List<Product> loadedProducts = [];
      extractedResponse.forEach((prodId, product) {
        loadedProducts.add(
          Product(
              id: prodId,
              title: product['title'],
              price: product['price'].toDouble(),
              imageUrl: product['imageUrl'],
              description: product['description'],
              isFavorite: favData == null ? false : favData[prodId] ?? false),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-12901-default-rtdb.firebaseio.com/products.json/?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      print(json.decode(response.body)['name']);
      _items!.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> editSingleProduct(String? id, Product product) async {
    int prodIndex = _items!.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-12901-default-rtdb.firebaseio.com/products/$id.json/?auth=$authToken';
      await http.patch(
        Uri.parse(url),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );
      _items![prodIndex] = product;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteSingleProduct(String? id) async {
    final url =
        'https://shop-12901-default-rtdb.firebaseio.com/products/$id.json/?auth=$authToken';
    final existingProductIndex =
        _items!.indexWhere((product) => product.id == id);
    Product? existingProduct = _items![existingProductIndex];
    _items!.removeWhere((product) => product.id == id);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items!.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Was not able to delete');
    }
    existingProduct = null;
  }
}
