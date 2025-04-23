import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/menu_item.dart';
import '../data/sample_menu.dart';
import 'order_history_screen.dart';

class AdminMenuScreen extends StatefulWidget {
  @override
  _AdminMenuScreenState createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  String _category = 'ของทานเล่น';
  String? _selectedImage;
  int? _editIndex;

  final List<String> _imageOptions = [
    'assets/images/fried_rice.jpg',
    'assets/images/tomyum.jpg',
    'assets/images/padthai.jpg',
    'assets/images/padthai.jpg',
    'assets/images/CheckenPop.jpg',
    'assets/images/checkwingfrie.jpg',
    'assets/images/Frenchfries.jpg',
    'assets/images/Peanut.jpg',
    'assets/images/poglemon.jpg',
    'assets/images/pogsalad.jpg',
    'assets/images/my.jpg',
    'assets/images/chang.jpg',
    'assets/images/leo.jpg',
    'assets/images/singha.jpg',
    'assets/images/heineken.jpg',
    'assets/images/sangsom.jpg',
    'assets/images/regency.jpeg',
    'assets/images/red.jpg',
  ];

  void _addMenuItem() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    if (name.isNotEmpty && price != null && _selectedImage != null) {
      setState(() {
        sampleMenu.add(
          MenuItem(
            name: name,
            price: price,
            imagePath: _selectedImage!,
            category: _category,
          ),
        );
        _nameController.clear();
        _priceController.clear();
        _selectedImage = null;
      });
    }
  }

  void _editMenuItem(int index) {
    final item = sampleMenu[index];
    _nameController.text = item.name;
    _priceController.text = item.price.toString();
    _selectedImage = item.imagePath;
    _category = item.category;
    setState(() {
      _editIndex = index;
    });
  }

  void _saveEditedMenuItem() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    if (name.isNotEmpty &&
        price != null &&
        _selectedImage != null &&
        _editIndex != null) {
      setState(() {
        sampleMenu[_editIndex!] = MenuItem(
          name: name,
          price: price,
          imagePath: _selectedImage!,
          category: _category,
        );
        _nameController.clear();
        _priceController.clear();
        _selectedImage = null;
        _editIndex = null;
      });
    }
  }

  void _removeMenuItem(int index) {
    setState(() {
      sampleMenu.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('จัดการเมนู'),
        actions: [
          IconButton(
            icon: Icon(Icons.receipt_long),
            tooltip: 'ตรวจสอบการสั่งซื้อ',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OrderHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'ชื่อเมนู'),
                ),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                DropdownButton<String>(
                  value: _selectedImage,
                  isExpanded: true,
                  hint: Text('เลือกรูปภาพ'),
                  items:
                      _imageOptions
                          .map(
                            (path) => DropdownMenuItem(
                              value: path,
                              child: Row(
                                children: [
                                  Image.asset(path, width: 30, height: 30),
                                  SizedBox(width: 10),
                                  Text(path.split('/').last),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _selectedImage = value),
                ),
                DropdownButton<String>(
                  value: _category,
                  isExpanded: true,
                  items:
                      ['ของทานเล่น', 'เครื่องดื่ม']
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
                ElevatedButton(
                  onPressed:
                      _editIndex == null ? _addMenuItem : _saveEditedMenuItem,
                  child: Text(
                    _editIndex == null ? 'เพิ่มเมนู' : 'บันทึกการแก้ไข',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sampleMenu.length,
              itemBuilder: (context, index) {
                final item = sampleMenu[index];
                return ListTile(
                  leading: Image.asset(item.imagePath, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editMenuItem(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeMenuItem(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
