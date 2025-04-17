// lib/models/cart_model.dart
import 'package:flutter/material.dart';
import 'menu_item.dart';

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

class OrderRecord {
  final String tableNumber;
  final DateTime dateTime;
  final List<String> items;

  OrderRecord({required this.tableNumber, required this.dateTime, required this.items});
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  final List<OrderRecord> _orderHistory = [];

  List<CartItem> get items => _items;
  List<OrderRecord> get orderHistory => _orderHistory;

  double get total => _items.fold(0, (sum, item) => sum + item.item.price * item.quantity);

  void addItem(MenuItem item) {
    final index = _items.indexWhere((e) => e.item == item);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    final index = _items.indexWhere((e) => e.item == item);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void increaseQty(MenuItem item) {
    final index = _items.indexWhere((e) => e.item == item);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQty(MenuItem item) {
    final index = _items.indexWhere((e) => e.item == item);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void submitOrder(String tableNumber, DateTime dateTime) {
    if (_items.isEmpty) return;
    final orderItems = _items.map((e) => '${e.item.name} x${e.quantity}').toList();
    _orderHistory.add(OrderRecord(
      tableNumber: tableNumber,
      dateTime: dateTime,
      items: orderItems,
    ));
    _items.clear();
    notifyListeners();
  }

  void clear() {}
}
