import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu_item.dart';
import '../models/order_model.dart';

class ApiService {
  // เปลี่ยนเป็น IP ที่ Android Emulator เข้าถึงได้
  final String baseUrl = 'http://10.0.2.2:3000/api';

  // ดึงเมนูทั้งหมด
  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await http.get(Uri.parse('$baseUrl/menu'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => MenuItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load menu');
    }
  }

  // เพิ่มเมนูใหม่
  Future<MenuItem> addMenuItem(MenuItem item) async {
    final response = await http.post(
      Uri.parse('$baseUrl/menu'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return MenuItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add item');
    }
  }

  // อัปเดตเมนู
  Future<MenuItem> updateMenuItem(MenuItem item) async {
    final response = await http.put(
      Uri.parse('$baseUrl/menu/${item.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(item.toJson()),
    );
    if (response.statusCode == 200) {
      return MenuItem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update item');
    }
  }

  // ลบเมนู
  Future<void> deleteMenuItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/menu/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete item');
    }
  }

  // POST: บันทึกคำสั่งซื้อใหม่
  Future<void> submitOrder(
    String table_number,
    DateTime date_time,
    double total,
    List<Map<String, dynamic>> items,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'table_number': table_number,
        'date_time': date_time.toIso8601String(),
        'total': total,
        'items': items,
      }),
    );

    if (response.statusCode != 200) {
      // ลองพิมพ์ response.body เพื่อ debug ข้อความจาก backend ได้ด้วย
      throw Exception('Failed to submit order');
    }
  }

  // GET: ดึงคำสั่งซื้อของโต๊ะ
  Future<List<Order>> fetchOrdersByTable(String tableNumber) async {
    final response = await http.get(
      Uri.parse('$baseUrl/orders?table=$tableNumber'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((order) => Order.fromJson(order)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
  }
}
