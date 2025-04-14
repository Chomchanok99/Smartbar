import 'package:flutter/material.dart';

import 'screens/menu_screen.dart';
import 'screens/admin_menu_screen.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: RoleSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final String _adminPassword = '1234';

  void _showAdminLogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เข้าสู่ระบบผู้ดูแล'),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: 'กรอกรหัสผ่าน'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_passwordController.text == _adminPassword) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminMenuScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('รหัสผ่านไม่ถูกต้อง')),
                );
              }
              _passwordController.clear();
            },
            child: Text('ตกลง'),
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => _showAdminLogin(context),
            ),
          ],
        ),
      ),
    );
  }
}
