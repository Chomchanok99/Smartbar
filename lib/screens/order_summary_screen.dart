// lib/screens/order_summary_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class OrderSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('สรุปคำสั่งซื้อ')),
      body: cart.items.isEmpty
          ? Center(child: Text('ยังไม่มีรายการสั่งซื้อ'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('โต๊ะ: ${cart.selectedTable ?? '-'}', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 4),
                  Text('วันเวลา: ${cart.selectedDateTime?.toLocal().toString().substring(0, 16) ?? '-'}'),
                  Divider(),
                  ...cart.items.map((item) => ListTile(
                        title: Text(item.item.name),
                        trailing: Text('x${item.quantity}'),
                      )),
                  Divider(),
                  Text('รวมทั้งหมด: ฿${cart.total.toStringAsFixed(0)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
    );
  }
}