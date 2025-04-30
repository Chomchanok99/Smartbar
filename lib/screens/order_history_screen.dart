import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/service.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String? selectedTable;
  late Future<List<Order>> futureOrders;

  final tables = List.generate(10, (index) => 'โต๊ะ ${index + 1}');

  void _loadOrders() {
    if (selectedTable != null) {
      setState(() {
        futureOrders = ApiService().fetchOrdersByTable(selectedTable!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ตรวจสอบคำสั่งซื้อ')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: selectedTable,
              hint: Text('เลือกโต๊ะ'),
              isExpanded: true,
              items:
                  tables
                      .map(
                        (table) =>
                            DropdownMenuItem(value: table, child: Text(table)),
                      )
                      .toList(),
              onChanged: (value) {
                selectedTable = value;
                _loadOrders();
              },
            ),
          ),
          Expanded(
            child:
                selectedTable == null
                    ? Center(child: Text('กรุณาเลือกโต๊ะ'))
                    : FutureBuilder<List<Order>>(
                      future: futureOrders,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('ไม่มีคำสั่งซื้อ'));
                        }

                        final orders = snapshot.data!;
                        return ListView(
                          children:
                              orders
                                  .map(
                                    (order) => Card(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      child: ListTile(
                                        title: Text(order.datTime),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children:
                                              order.items
                                                  .map((e) => Text('- $e'))
                                                  .toList(),
                                        ),
                                        trailing: Text(
                                          '฿${order.total.toStringAsFixed(0)}',
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
