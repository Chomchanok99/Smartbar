// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Menu',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MenuScreen(),
    );
  }
}
