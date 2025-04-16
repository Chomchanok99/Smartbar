// lib/models/cart_model.dart
import 'package:flutter/material.dart';
import 'menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem(this.item, {this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  double get total => _items.fold(0, (sum, e) => sum + e.item.price * e.quantity);

  void addItem(MenuItem item) {
    final index = _items.indexWhere((e) => e.item.name == item.name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item));
    }
    notifyListeners();
  }

  void increaseQty(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQty(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}