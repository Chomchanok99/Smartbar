class MenuItem {
  final int? id;
  final String name;
  final double price;
  final String imagepath;
  final String category;

  MenuItem({
    this.id,
    required this.name,
    required this.price,
    required this.imagepath,
    required this.category,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'] ?? 'ไม่ระบุชื่อ',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imagepath: json['imagepath'] ?? 'assets/images/fallback.jpg',
      category: json['category'] ?? 'ไม่ระบุประเภท',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'imagepath': imagepath,
      'category': category,
    };
  }
}
