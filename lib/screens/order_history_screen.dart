// lib/screens/order_history_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var orders = context.watch<CartModel>().orderHistory;

    return Scaffold(
      appBar: AppBar(title: Text('คำสั่งซื้อย้อนหลัง')),
      body: orders.isEmpty
          ? Center(child: Text('ยังไม่มีประวัติการสั่งซื้อ'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('โต๊ะ: ${order.table}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('วันเวลา: ${order.dateTime.toLocal().toString().substring(0, 16)}'),
                        SizedBox(height: 5),
                        ...order.items.map((i) => Text('${i.item.name} x${i.quantity}')),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}