import 'package:flutter/material.dart';
import '../../data/repositories/orders_repository_impl.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../data/repositories/pricing_repository_impl.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/pricing_rule.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/print_order.dart';
import '../../data/datasources/notifications_remote_data_source.dart';

class AdminController extends ChangeNotifier {
  final OrdersRepositoryImpl _ordersRepository;
  final ProductsRepositoryImpl _productsRepository;
  final PricingRepositoryImpl _pricingRepository;
  final NotificationsRemoteDataSource _notificationsRemoteDataSource;

  AdminController({
    OrdersRepositoryImpl? ordersRepository,
    ProductsRepositoryImpl? productsRepository,
    PricingRepositoryImpl? pricingRepository,
    NotificationsRemoteDataSource? notificationsRemoteDataSource,
  })  : _ordersRepository = ordersRepository ?? OrdersRepositoryImpl(),
        _productsRepository = productsRepository ?? ProductsRepositoryImpl(),
        _pricingRepository = pricingRepository ?? PricingRepositoryImpl(),
        _notificationsRemoteDataSource =
            notificationsRemoteDataSource ?? NotificationsRemoteDataSource();

  Stream<List<PrintOrder>> watchAllOrders() {
    return _ordersRepository.watchAllOrders();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) {
    return _ordersRepository.updateOrderStatus(orderId: orderId, status: status);
  }

  Future<void> savePricingRule(PricingRule rule) {
    return _pricingRepository.savePricingRule(rule);
  }

  Future<void> addProduct(Product product) {
    return _productsRepository.addProduct(product);
  }

  Future<void> updateProduct(Product product) {
    return _productsRepository.updateProduct(product);
  }

  Future<void> deleteProduct(String productId) {
    return _productsRepository.deleteProduct(productId);
  }

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    return _notificationsRemoteDataSource.queueNotification(
      userId: userId,
      title: title,
      body: body,
      data: data,
    );
  }
}
