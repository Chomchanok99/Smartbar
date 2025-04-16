// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../data/sample_menu.dart';
import 'cart_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String searchQuery = '';
  final categories = ['ของทานเล่น', 'เครื่องดื่ม'];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    final filteredMenu = sampleMenu
        .where((item) => item.name.contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูอาหาร'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            ),
          )
        ],
      ),
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

                return ExpansionTile(
                  title: Text(category, style: TextStyle(fontWeight: FontWeight.bold)),
                  children: categoryItems.map((item) {
                    return ListTile(
                      leading: Image.asset(item.imagePath, width: 50, height: 50),
                      title: Text(item.name),
                      subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.add_shopping_cart),
                        onPressed: () => cart.addItem(item),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
