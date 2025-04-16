// lib/screens/admin_menu_screen.dart
import 'package:flutter/material.dart';
import '../data/sample_menu.dart';
import '../models/menu_item.dart';
import '../models/cart_model.dart';
import 'package:provider/provider.dart';

class AdminMenuScreen extends StatefulWidget {
  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedImage;
  String selectedCategory = 'ของทานเล่น';
  String selectedTable = '1';
  String searchQuery = '';

  final availableImages = [
    'assets/images/fried_rice.jpg',
    'assets/images/tomyum.jpg',
    'assets/images/padthai.jpg',
    'assets/images/tomyum.jpg',
    'assets/images/tomyum.jpg',
  ];

  final categories = ['ของทานเล่น', 'เครื่องดื่ม'];

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);

    final filteredMenu = sampleMenu
        .where((item) => item.name.contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('จัดการเมนู')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ค้นหาเมนู',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView(
              children: categories.map((category) {
                final categoryItems = filteredMenu
                    .where((item) => item.category == category)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        category,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    ...categoryItems.map((item) {
                      return ListTile(
                        leading: Image.asset(item.imagePath, width: 50, height: 50),
                        title: Text(item.name),
                        subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => sampleMenu.remove(item));
                          },
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
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
                DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
                  items: categories.map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      )).toList(),
                  onChanged: (value) => setState(() => selectedCategory = value!),
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
                          category: selectedCategory,
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
            child: OrderHistoryList(
              filterTable: selectedTable,
              orders: cartModel.orderHistory,
            ),
          ),
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
    final filteredOrders =
        orders.where((o) => o.tableNumber == filterTable).toList();

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return ListTile(
          title: Text('โต๊ะ ${order.tableNumber}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('เวลา: ${order.dateTime.toString().substring(0, 16)}'),
              ...order.items.map((e) => Text(e)).toList(),
            ],
          ),
        );
      },
    );
  }
}