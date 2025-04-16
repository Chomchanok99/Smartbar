// lib/screens/admin_menu_screen.dart
import 'package:flutter/material.dart';
import '../data/sample_menu.dart';

class AdminMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เมนูทั้งหมด')), 
      body: ListView.builder(
        itemCount: sampleMenu.length,
        itemBuilder: (context, index) {
          final item = sampleMenu[index];
          return ListTile(
            leading: Image.asset(item.imagePath, width: 50, height: 50),
            title: Text(item.name),
            subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
          );
        },
      ),
    );
  }
}