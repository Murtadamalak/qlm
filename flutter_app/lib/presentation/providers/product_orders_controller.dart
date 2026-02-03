import 'package:flutter/material.dart';
import '../../data/repositories/product_orders_repository_impl.dart';
import '../../domain/entities/product_order.dart';

class ProductOrdersController extends ChangeNotifier {
  final ProductOrdersRepositoryImpl _repository;

  ProductOrdersController({ProductOrdersRepositoryImpl? repository})
      : _repository = repository ?? ProductOrdersRepositoryImpl();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Stream<List<ProductOrder>> watchOrdersForUser(String userId) =>
      _repository.watchOrdersForUser(userId);

  Future<void> submitOrder(ProductOrder order) async {
    _setLoading(true);
    try {
      await _repository.submitOrder(order);
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
