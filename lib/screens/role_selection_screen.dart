// lib/screens/role_selection_screen.dart
import 'package:flutter/material.dart';
import 'menu_screen.dart';
import 'admin_menu_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  final adminPassword = '1234';

  void _showPasswordDialog(BuildContext context) {
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('ใส่รหัสผ่านผู้ดูแล'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: 'รหัสผ่าน'),
        ),
        actions: [
          TextButton(
            child: Text('ยกเลิก'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('ยืนยัน'),
            onPressed: () {
              if (passwordController.text == adminPassword) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminMenuScreen()),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('รหัสผ่านไม่ถูกต้อง')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

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
              onPressed: () => _showPasswordDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}