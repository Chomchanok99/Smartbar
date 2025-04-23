// lib/screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String selectedTable = 'โต๊ะ 1';

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final orders = cartModel.orderHistory;
    final filteredOrders = orders.where((o) => o.tableNumber == selectedTable).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('ตรวจสอบคำสั่งซื้อ'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: selectedTable,
              isExpanded: true,
              items: List.generate(10, (i) => 'โต๊ะ ${i + 1}').map((table) {
                return DropdownMenuItem(
                  value: table,
                  child: Text(table),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedTable = value!),
            ),
          ),
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(child: Text('ไม่มีรายการสั่งซื้อ'))
                : ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(order.dateTime),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: order.items.map((e) => Text(e)).toList(),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
