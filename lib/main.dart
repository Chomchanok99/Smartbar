import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Ordering App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MenuScreen(),
    );
  }
}

// MODEL
class MenuItem {
  String name;
  double price;
  String imagePath;

  MenuItem({required this.name, required this.price, required this.imagePath});
}

class CartItem {
  MenuItem item;
  int quantity;
  CartItem(this.item, {this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];
  List<CartItem> get items => _items;

  void addItem(MenuItem item) {
    final index = _items.indexWhere((e) => e.item.name == item.name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(item));
    }
    notifyListeners();
  }

  void increaseQty(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decreaseQty(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _items.remove(cartItem);
    }
    notifyListeners();
  }

  double get total => _items.fold(0, (sum, e) => sum + e.quantity * e.item.price);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// SAMPLE MENU
List<MenuItem> menuList = [
  MenuItem(name: 'ข้าวผัดหมู', price: 50, imagePath: 'assets/images/fried_rice.jpg'),
  MenuItem(name: 'ต้มยำกุ้ง', price: 70, imagePath: 'assets/images/tomyum.jpg'),
  MenuItem(name: 'ผัดไทย', price: 60, imagePath: 'assets/images/padthai.jpg'),
];

// MENU SCREEN
class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูอาหาร'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: menuList.length,
        itemBuilder: (context, index) {
          final item = menuList[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(item.imagePath, width: 60, height: 60),
              title: Text(item.name),
              subtitle: Text('฿${item.price.toStringAsFixed(0)}'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => cart.addItem(item),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdminScreen()),
        ),
      ),
    );
  }
}

// CART SCREEN
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
                        leading: Image.asset(cartItem.item.imagePath, width: 50, height: 50),
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
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('รวมทั้งหมด: ฿${cart.total.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        child: Text('ยืนยันการสั่งซื้อ'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('สั่งซื้อสำเร็จ!'),
                              content: Text('ขอบคุณที่ใช้บริการ'),
                              actions: [
                                TextButton(
                                  child: Text('ตกลง'),
                                  onPressed: () {
                                    cart.clear();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
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

// ADMIN MENU SCREEN
class AdminScreen extends StatefulWidget {
  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
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
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                final item = menuList[index];
                return ListTile(
                  leading: Image.asset(item.imagePath, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text('฿${item.price}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => menuList.removeAt(index));
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
                  items: availableImages.map((img) {
                    return DropdownMenuItem(
                      child: Text(img.split('/').last),
                      value: img,
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => selectedImage = value),
                ),
                ElevatedButton(
                  child: Text('เพิ่มเมนู'),
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        priceController.text.isNotEmpty &&
                        selectedImage != null) {
                      setState(() {
                        menuList.add(MenuItem(
                          name: nameController.text,
                          price: double.parse(priceController.text),
                          imagePath: selectedImage!,
                        ));
                        nameController.clear();
                        priceController.clear();
                        selectedImage = null;
                      });
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
