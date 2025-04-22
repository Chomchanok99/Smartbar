// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String selectedTable = '1';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าสินค้า'),
      ),
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
                  items: List.generate(10, (i) => '${i + 1}').map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text('โต๊ะ $t'),
                    );
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
                  onPressed: () {
                    final now = DateTime.now();
                    cart.confirmOrder(
                      selectedTable,
                      now,
                      cart.items.map((e) => '${e.item.name} x ${e.quantity}').toList(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ บันทึกคำสั่งซื้อแล้ว'),
                      ),
                    );

                    cart.clear();
                    Navigator.pop(context);
                  },
                  child: Text('ยืนยันคำสั่งซื้อ'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}