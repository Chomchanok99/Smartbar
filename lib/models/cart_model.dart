// lib/models/cart_model.dart
import 'package:flutter/material.dart';
import 'menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem(this.item, {this.quantity = 1});
}

class OrderRecord {
  final String tableNumber;
  final DateTime dateTime;
  final List<String> items;

  OrderRecord(this.tableNumber, this.dateTime, this.items);
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<OrderRecord> _orderHistory = [];

  List<CartItem> get items => _items;
  List<OrderRecord> get orderHistory => _orderHistory;

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

  void submitOrder(String tableNumber, DateTime dateTime) {
    final itemsSummary = _items
        .map((item) => '${item.item.name} x${item.quantity}')
        .toList();
    _orderHistory.add(OrderRecord(tableNumber, dateTime, itemsSummary));
    clear();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}