import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart_model.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Kanit', // ใส่ถ้ามีฟอนต์ไทย
      ),
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}
