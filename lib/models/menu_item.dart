class MenuItem {
  final String name;
  final double price;
  final String imagePath;
  final String category; // <== เพิ่มหมวดหมู่

  MenuItem({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
  });
}