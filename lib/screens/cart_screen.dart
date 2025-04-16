// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('ตะกร้าสินค้า')),
      body: cart.items.isEmpty
          ? Center(child: Text('ไม่มีสินค้าในตะกร้า'))
          : Column(
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
                              onPressed: () => cart.decreaseQty(item),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => cart.increaseQty(item),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'รวมทั้งหมด: ฿${cart.total.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          cart.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('ยืนยันคำสั่งซื้อเรียบร้อย')),
                          );
                          Navigator.pop(context);
                        },
                        child: Text('ยืนยันคำสั่งซื้อ'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
