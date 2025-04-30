import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final tables = List.generate(10, (index) => 'โต๊ะ ${index + 1}');
    String? selectedTable;

    return StatefulBuilder(
      builder: (context, setState) => Scaffold(
        appBar: AppBar(title: Text('ตรวจสอบคำสั่งซื้อ')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownButton<String>(
                value: selectedTable,
                hint: Text('เลือกโต๊ะ'),
                isExpanded: true,
                items: tables
                    .map((table) => DropdownMenuItem(
                          value: table,
                          child: Text(table),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedTable = value),
              ),
            ),
            Expanded(
              child: selectedTable == null
                  ? Center(child: Text('กรุณาเลือกโต๊ะ'))
                  : ListView(
                      children: cartModel.orderHistory
                          .where((order) => order.tableNumber == 'โต๊ะ $selectedTable')
                          .map((order) => Card(
                                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: ListTile(
                                  title: Text(order.dateTime),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: order.items
                                        .map((item) => Text('- $item'))
                                        .toList(),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
