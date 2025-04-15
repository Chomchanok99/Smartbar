// lib/screens/admin_menu_screen.dart
import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../data/sample_menu.dart';

class AdminMenuScreen extends StatefulWidget {
  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedImage;
  String selectedTable = '1';

  final availableImages = [
    'assets/images/fried_rice.png',
    'assets/images/padthai.png',
    'assets/images/tomyum.png',
  ];

  final List<OrderRecord> orders = [
    OrderRecord('1', DateTime.now(), ['ข้าวผัดหมู x1', 'ต้มยำกุ้ง x2']),
    OrderRecord('2', DateTime.now().subtract(Duration(hours: 1)), ['ผัดไทย x1']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('จัดการเมนู')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sampleMenu.length,
              itemBuilder: (context, index) {
                final item = sampleMenu[index];
                return ListTile(
                  leading: Image.asset(item.imagePath, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => sampleMenu.removeAt(index));
                    },
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อเมนู'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'ราคา'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<String>(
                  value: selectedImage,
                  hint: Text('เลือกรูปภาพ'),
                  isExpanded: true,
                  items: availableImages.map((img) {
                    return DropdownMenuItem(
                      child: Text(img.split('/').last),
                      value: img,
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedImage = value),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  child: Text('เพิ่มเมนู'),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        selectedImage != null) {
                      setState(() {
                        sampleMenu.add(MenuItem(
                          name: nameController.text,
                          price: double.tryParse(priceController.text) ?? 0,
                          imagePath: selectedImage!,
                          category: 'ของกินเล่น',
                        ));
                        nameController.clear();
                        priceController.clear();
                        selectedImage = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text('เลือกโต๊ะ: '),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedTable,
                  items: List.generate(10, (index) => '${index + 1}').map((table) {
                    return DropdownMenuItem(
                      child: Text('โต๊ะ $table'),
                      value: table,
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedTable = value!),
                )
              ],
            ),
          ),
          Expanded(
            child: OrderHistoryList(filterTable: selectedTable, orders: orders),
          ),
        ],
      ),
    );
  }
}

class OrderRecord {
  final String tableNumber;
  final DateTime dateTime;
  final List<String> items;

  OrderRecord(this.tableNumber, this.dateTime, this.items);
}

class OrderHistoryList extends StatelessWidget {
  final String filterTable;
  final List<OrderRecord> orders;

  const OrderHistoryList({required this.filterTable, required this.orders});

  @override
  Widget build(BuildContext context) {
    final filteredOrders = orders.where((o) => o.tableNumber == filterTable).toList();

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text('โต๊ะ ${order.tableNumber}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('เวลา: ${order.dateTime.toLocal().toString().substring(0, 16)}'),
                ...order.items.map((e) => Text(e)).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
