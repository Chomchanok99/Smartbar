class Order {
  final String datTime;
  final double total;
  final List<String> items;

  Order({required this.datTime, required this.total, required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      datTime: json['dateTime'],
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      items: List<String>.from(json['items']),
    );
  }
}
