// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../data/sample_menu.dart';
import 'cart_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

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
      body: ListView.builder(
        itemCount: sampleMenu.length,
        itemBuilder: (context, index) {
          final item = sampleMenu[index];
          return Card(
            child: ListTile(
              leading: Image.asset(item.imagePath, width: 50, height: 50),
              title: Text(item.name),
              subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => cart.addItem(item),
              ),
            ),
          );
        },
      ),
    );
  }
}