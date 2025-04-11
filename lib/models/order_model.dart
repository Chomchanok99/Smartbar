// lib/models/order_model.dart
import 'menu_item.dart';

class OrderItem {
  final MenuItem item;
  final int quantity;
  OrderItem(this.item, this.quantity);
}

class Order {
  final int table;
  final DateTime dateTime;
  final List<OrderItem> items;

  Order({required this.table, required this.dateTime, required this.items});
}