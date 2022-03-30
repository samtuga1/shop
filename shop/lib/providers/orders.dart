import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  String? authToken;
  Orders(this.authToken, this._orders);
  Orders.diffConstructor();

  Future<void> addOrder(double total, List<CartItem> cartProducts) async {
    final url = 'https://shop-12901-default-rtdb.firebaseio.com/orders.json/?auth=$authToken';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList(),
            //'time': DateTime.now(),
          }));
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp,
          ));
      notifyListeners();
    } catch (error) {
      print(error);
    }
    // CartItem cartItem;
  }

  Future<void> fetchAndSet() async {
    final url = 'https://shop-12901-default-rtdb.firebaseio.com/orders.json/?auth=$authToken';

    var response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    Map? extractedData = json.decode(response.body) as Map<String, dynamic>?;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, order) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: order['amount'],
          dateTime: DateTime.parse(order['dateTime']),
          products: (order['products'] as List<dynamic>)
              .map((item) => CartItem(
                  title: item['title'],
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
