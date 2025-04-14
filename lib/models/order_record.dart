// lib/models/order_record.dart
class OrderRecord {
  final String tableNumber;
  final DateTime dateTime;
  final List<String> items;

  OrderRecord(this.tableNumber, this.dateTime, this.items);

  Map<String, dynamic> toMap() {
    return {
      'tableNumber': tableNumber,
      'dateTime': dateTime.toIso8601String(),
      'items': items,
    };
  }

  static OrderRecord fromMap(Map<String, dynamic> map) {
    return OrderRecord(
      map['tableNumber'],
      DateTime.parse(map['dateTime']),
      List<String>.from(map['items']),
    );
  }
}
