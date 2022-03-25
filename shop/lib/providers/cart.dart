import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  CartItem({
    required this.title,
    required this.id,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  final Map<String?, CartItem> _items = {};

  Map<String?, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String? productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          title: existingCartItem.title,
          id: existingCartItem.id,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            title: title,
            id: DateTime.now().toString(),
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String? productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  void removeSingleItem(String? productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            title: existingCartItem.title,
            id: existingCartItem.id,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
