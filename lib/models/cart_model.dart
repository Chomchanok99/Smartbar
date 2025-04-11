// lib/models/cart_model.dart
import 'package:flutter/material.dart';
import 'menu_item.dart';

class CartItem {
  MenuItem item;
  int quantity;
  CartItem(this.item, {this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  int? selectedTable;
  DateTime? selectedDateTime;

  void setTable(int table) {
    selectedTable = table;
    notifyListeners();
  }

  void setDateTime(DateTime dateTime) {
    selectedDateTime = dateTime;
    notifyListeners();
  }

  void addItem(MenuItem item) {
    final index = _items.indexWhere((e) => e.item.name == item.name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item));
    }
    notifyListeners();
  }

  void increaseQty(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decreaseQty(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _items.remove(cartItem);
    }
    notifyListeners();
  }

  double get total => _items.fold(0, (sum, e) => sum + e.quantity * e.item.price);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}