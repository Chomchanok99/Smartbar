// lib/screens/menu_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<dynamic> menuItems = [];

  Future<void> fetchMenu() async {
    final response = await http.get(Uri.parse('http://localhost/api/menu.php'));
    if (response.statusCode == 200) {
      setState(() {
        menuItems = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load menu');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("รายการอาหาร")),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          var item = menuItems[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(item['image']),
              title: Text(item['name']),
              subtitle: Text("ราคา ${item['price']} บาท"),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // เพิ่มใส่ตะกร้า
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
