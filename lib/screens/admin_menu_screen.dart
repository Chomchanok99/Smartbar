import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/menu_item.dart';
import '../services/service.dart';
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
  int? _editId;

  final ApiService _apiService = ApiService();
  List<MenuItem> _menuItems = [];

  final List<String> _imageOptions = [
    'assets/images/fried_rice.jpg',
    'assets/images/tomyum.jpg',
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

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    final items = await _apiService.fetchMenuItems();
    setState(() => _menuItems = items);
  }

  Future<void> _submitMenuItem() async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    if (name.isEmpty || price == null || _selectedImage == null) return;

    final item = MenuItem(
      id: _editId,
      name: name,
      price: price,
      imagepath: _selectedImage!,
      category: _category,
    );

    try {
      if (_editId == null) {
        await _apiService.addMenuItem(item);
      } else {
        await _apiService.updateMenuItem(item);
      }
      _resetForm();
      _loadMenuItems();
    } catch (e) {
      print('Error saving item: $e');
    }
  }

  void _resetForm() {
    _nameController.clear();
    _priceController.clear();
    _selectedImage = null;
    _editId = null;
    _category = 'ของทานเล่น';
  }

  void _editMenuItem(MenuItem item) {
    _nameController.text = item.name;
    _priceController.text = item.price.toString();
    _selectedImage = item.imagepath;
    _category = item.category;
    _editId = item.id;
  }

  Future<void> _deleteMenuItem(int id) async {
    await _apiService.deleteMenuItem(id);
    _loadMenuItems();
  }

  @override
  Widget build(BuildContext context) {
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
                  hint: Text('เลือกรูปภาพ'),
                  isExpanded: true,
                  items:
                      _imageOptions
                          .map(
                            (path) => DropdownMenuItem(
                              value: path,
                              child: Row(
                                children: [
                                  Image.asset(
                                    path,
                                    width: 30,
                                    height: 30,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.broken_image),
                                  ),
                                  SizedBox(width: 10),
                                  Text(path.split('/').last),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedImage = value!;
                    });
                  },
                ),
                DropdownButton<String>(
                  value: _category,
                  isExpanded: true,
                  items:
                      ['ของทานเล่น', 'เครื่องดื่ม', 'อาหารจานเดียว']
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
                ElevatedButton(
                  onPressed: _submitMenuItem,
                  child: Text(_editId == null ? 'เพิ่มเมนู' : 'บันทึกการแก้ไข'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return ListTile(
                  leading: Image.asset(
                    item.imagepath,
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/chang.jpg',
                        width: 50,
                        height: 50,
                      );
                    },
                  ),
                  title: Text(item.name),
                  subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editMenuItem(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMenuItem(item.id!),
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
