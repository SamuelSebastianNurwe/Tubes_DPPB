import 'dart:async';
import '../models/order.dart';

class OrderService {
  // Singleton pattern to ensure data persistence during session
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final List<Order> _orders = [];

  Future<List<Order>> getOrders() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_orders);
  }

  Future<void> addOrder(Order order) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _orders.add(order);
  }
}
