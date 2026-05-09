import 'package:flutter/material.dart';
import '../../data/repositories/orders_repository_impl.dart';
import '../../domain/entities/print_order.dart';
import '../../domain/entities/order_status.dart';

class OrdersController extends ChangeNotifier {
  final OrdersRepositoryImpl _repository;

  OrdersController({OrdersRepositoryImpl? repository})
      : _repository = repository ?? OrdersRepositoryImpl();

  List<PrintOrder> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PrintOrder> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<List<PrintOrder>> watchOrdersForUser(String userId) {
    return _repository.watchOrdersForUser(userId);
  }

  Stream<List<PrintOrder>> watchAllOrders() {
    return _repository.watchAllOrders();
  }

  Future<void> submitOrder(PrintOrder order) async {
    _setLoading(true);
    try {
      final created = await _repository.submitPrintOrder(order);
      _orders = [created, ..._orders];
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateStatus(String orderId, OrderStatus status) async {
    _setLoading(true);
    try {
      await _repository.updateOrderStatus(orderId: orderId, status: status);
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
