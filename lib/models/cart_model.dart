import 'package:flutter/material.dart';
import 'menu_item.dart';
import 'order_model.dart';

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem(this.item, {this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];
  int? selectedTable;
  DateTime? selectedDateTime;

  List<CartItem> get items => _items;
  double get total => _items.fold(0, (sum, e) => sum + e.quantity * e.item.price);

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

  void clear() {
    _items.clear();
    selectedTable = null;
    selectedDateTime = null;
    notifyListeners();
  }

  void setTable(int table) {
    selectedTable = table;
    notifyListeners();
  }

  void setDateTime(DateTime dateTime) {
    selectedDateTime = dateTime;
    notifyListeners();
  }

  // 🔄 Order History
  final List<Order> _orderHistory = [];
  List<Order> get orderHistory => _orderHistory;

  void confirmOrder() {
    if (selectedTable != null &&
        selectedDateTime != null &&
        _items.isNotEmpty) {
      _orderHistory.add(Order(
        table: selectedTable!,
        dateTime: selectedDateTime!,
        items: _items.map((e) => OrderItem(e.item, e.quantity)).toList(),
      ));
      clear();
    }
    notifyListeners();
  }
}
