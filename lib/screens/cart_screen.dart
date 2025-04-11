import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('ตะกร้าของฉัน')),
      body: cart.items.isEmpty
          ? Center(child: Text('ไม่มีสินค้าในตะกร้า'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cart.items[index];
                      return ListTile(
                        leading: Image.asset(
                          cartItem.item.imagePath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(cartItem.item.name),
                        subtitle: Text('฿${cartItem.item.price} x ${cartItem.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => cart.decreaseQty(cartItem),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => cart.increaseQty(cartItem),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // เลือกโต๊ะ
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: cart.selectedTable,
                    hint: Text('เลือกโต๊ะ'),
                    items: List.generate(10, (index) => index + 1).map((table) {
                      return DropdownMenuItem(
                        child: Text('โต๊ะ $table'),
                        value: table,
                      );
                    }).toList(),
                    onChanged: (value) => cart.setTable(value!),
                  ),
                ),

                // เลือกวันเวลา
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text(cart.selectedDateTime == null
                        ? 'เลือกวันเวลา'
                        : '${cart.selectedDateTime!.toLocal()}'.split('.')[0]),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 30)),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          final selectedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          cart.setDateTime(selectedDateTime);
                        }
                      }
                    },
                  ),
                ),

                // ยอดรวม + ปุ่มยืนยัน
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'รวมทั้งหมด: ฿${cart.total.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Text('ยืนยันการสั่งซื้อ'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('สรุปคำสั่งซื้อ'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('โต๊ะ: ${cart.selectedTable ?? '-'}'),
                                  Text('วันเวลา: ${cart.selectedDateTime?.toLocal().toString().substring(0, 16) ?? '-'}'),
                                  SizedBox(height: 10),
                                  ...cart.items.map((item) =>
                                      Text('${item.item.name} x ${item.quantity}')),
                                  Divider(),
                                  Text('รวม: ฿${cart.total.toStringAsFixed(0)}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text('ตกลง'),
                                  onPressed: () {
                                    cart.clear();
                                    Navigator.pop(context); // close dialog
                                    Navigator.pop(context); // back to menu
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
