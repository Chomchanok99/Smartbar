// lib/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'menu_screen.dart';
import 'admin_menu_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('เลือกประเภทผู้ใช้งาน')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('เข้าสู่ระบบลูกค้า'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MenuScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('เข้าสู่ระบบผู้ดูแล'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdminMenuScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
