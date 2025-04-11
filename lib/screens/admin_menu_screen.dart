import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../data/sample_menu.dart';
import 'order_history_screen.dart';

class AdminMenuScreen extends StatefulWidget {
  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  String? selectedImage;

  final availableImages = [
    'assets/images/fried_rice.png',
    'assets/images/tomyum.png',
    'assets/images/padthai.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('จัดการเมนู')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sampleMenu.length,
              itemBuilder: (context, index) {
                final item = sampleMenu[index];
                return ListTile(
                  leading: Image.asset(item.imagePath, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => sampleMenu.removeAt(index));
                    },
                  ),
                );
              },
            ),
          ),

          Divider(),

          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อเมนู'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'ราคา'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<String>(
                  value: selectedImage,
                  hint: Text('เลือกรูปภาพ'),
                  isExpanded: true,
                  items: availableImages.map((img) {
                    return DropdownMenuItem(
                      child: Text(img.split('/').last),
                      value: img,
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedImage = value),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  child: Text('เพิ่มเมนู'),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        selectedImage != null) {
                      setState(() {
                        sampleMenu.add(MenuItem(
                          name: nameController.text,
                          price: double.tryParse(priceController.text) ?? 0,
                          imagePath: selectedImage!,
                        ));
                        nameController.clear();
                        priceController.clear();
                        selectedImage = null;
                      });
                    }
                  },
                ),

                // ปุ่มดูคำสั่งซื้อย้อนหลัง
                SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.history),
                  label: Text('ดูคำสั่งซื้อย้อนหลัง'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OrderHistoryScreen()),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
