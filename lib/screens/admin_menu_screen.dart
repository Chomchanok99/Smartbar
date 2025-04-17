// lib/screens/admin_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class AdminMenuScreen extends StatefulWidget {
  @override
  _AdminMenuScreenState createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  String selectedTable = '1';

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('จัดการเมนู')), 
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text('เลือกโต๊ะ: '),
                DropdownButton<String>(
                  value: selectedTable,
                  items: List.generate(10, (i) => '${i + 1}').map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text('โต๊ะ $t'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedTable = value!),
                ),
              ],
            ),
          ),
          Expanded(
            child: OrderHistoryList(
              filterTable: selectedTable,
              orders: cartModel.orderHistory,
            ),
          )
        ],
      ),
    );
  }
}

class OrderHistoryList extends StatelessWidget {
  final String filterTable;
  final List<OrderRecord> orders;

  const OrderHistoryList({required this.filterTable, required this.orders});

  @override
  Widget build(BuildContext context) {
    final filteredOrders = orders
        .where((o) => o.tableNumber == filterTable)
        .toList();

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return ListTile(
          title: Text('โต๊ะ ${order.tableNumber}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('เวลา: ${order.dateTime}'),
              ...order.items.map((item) => Text(item)).toList()
            ],
          ),
        );
      },
    );
  }
}
