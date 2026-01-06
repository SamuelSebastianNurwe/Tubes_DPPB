class Order {
  final String id;
  final String architectName;
  final String serviceType;
  final String status;
  final DateTime orderDate;
  final double price;
  final String note;

  Order({
    required this.id,
    required this.architectName,
    required this.serviceType,
    required this.status,
    required this.orderDate,
    required this.price,
    required this.note,
  });
}
