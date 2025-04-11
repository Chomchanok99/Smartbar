import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_item.dart';
import '../models/cart_model.dart';
import '../data/sample_menu.dart';

import 'cart_screen.dart';
import 'admin_menu_screen.dart';
import 'order_summary_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);

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
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(item.imagePath, width: 60, height: 60),
              title: Text(item.name),
              subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  cart.addItem(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.name} ถูกเพิ่มในตะกร้า')),
                  );
                },
              ),
            ),
          );
        },
      ),

      // ปุ่มลอย: ผู้ดูแล / สรุปคำสั่งซื้อ
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'admin',
            child: Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AdminMenuScreen()),
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'summary',
            backgroundColor: Colors.blue,
            child: Icon(Icons.list_alt),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OrderSummaryScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
