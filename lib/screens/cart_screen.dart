// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? selectedTable;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<OrderRecord> orderHistory = [];

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedTable,
                        hint: Text('เลือกโต๊ะ'),
                        items: List.generate(10, (index) => '${index + 1}').map((table) {
                          return DropdownMenuItem(
                            child: Text('โต๊ะ $table'),
                            value: table,
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => selectedTable = value),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 30)),
                          );
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                selectedDate = date;
                                selectedTime = time;
                              });
                            }
                          }
                        },
                        child: Text(
                          selectedDate == null || selectedTime == null
                              ? 'เลือกวันที่และเวลา'
                              : '${selectedDate!.toLocal().toString().split(" ")[0]} ${selectedTime!.format(context)}',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'รวมทั้งหมด: ฿${cart.total.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (selectedTable == null || selectedDate == null || selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                            );
                            return;
                          }

                          final orderTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );

                          final order = OrderRecord(
                            selectedTable!,
                            orderTime,
                            cart.items.map((item) => '${item.item.name} x${item.quantity}').toList(),
                          );

                          // เพิ่มคำสั่งซื้อจริงไปยัง orderHistory ทั่วไป (สมมุติ)
                          orderHistory.add(order);

                          cart.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('สั่งอาหารสำเร็จสำหรับโต๊ะ $selectedTable')),
                          );
                          Navigator.pop(context);
                        },
                        child: Text('ยืนยันการสั่งซื้อ'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class OrderRecord {
  final String tableNumber;
  final DateTime dateTime;
  final List<String> items;

  OrderRecord(this.tableNumber, this.dateTime, this.items);
}
