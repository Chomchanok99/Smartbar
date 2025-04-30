import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../services/service.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String selectedTable = 'โต๊ะ 1';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('ตะกร้าสินค้า')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text(item.item.name),
                  subtitle: Text('฿${item.item.price} x ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => cart.decreaseQty(item.item),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => cart.increaseQty(item.item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text('โต๊ะ '),
                SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedTable,
                  items:
                      List.generate(10, (i) => 'โต๊ะ ${i + 1}').map((t) {
                        return DropdownMenuItem(value: t, child: Text(t));
                      }).toList(),
                  onChanged: (value) => setState(() => selectedTable = value!),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('รวมทั้งหมด: ฿${cart.total.toStringAsFixed(0)}'),
                ElevatedButton(
                  onPressed: () async {
                    final now = DateTime.now();

                    try {
                      await ApiService().submitOrder(
                        selectedTable,
                        now,
                        cart.total,
                        cart.items
                            .map(
                              (e) => {
                                'name': e.item.name,
                                'quantity': e.quantity,
                              },
                            )
                            .toList(),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('✅ บันทึกคำสั่งซื้อแล้ว')),
                      );

                      cart.clear();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ เกิดข้อผิดพลาดในการส่งคำสั่งซื้อ'),
                        ),
                      );
                    }
                  },
                  child: Text('ยืนยันคำสั่งซื้อ'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
