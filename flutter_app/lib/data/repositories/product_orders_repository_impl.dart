import '../../domain/entities/product_order.dart';
import '../../domain/repositories/product_orders_repository.dart';
import '../datasources/product_orders_remote_data_source.dart';
import '../models/product_order_model.dart';

class ProductOrdersRepositoryImpl implements ProductOrdersRepository {
  final ProductOrdersRemoteDataSource _remoteDataSource;

  ProductOrdersRepositoryImpl({ProductOrdersRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? ProductOrdersRemoteDataSource();

  @override
  Stream<List<ProductOrder>> watchOrdersForUser(String userId) =>
      _remoteDataSource.watchOrdersForUser(userId);

  @override
  Future<ProductOrder> submitOrder(ProductOrder order) {
    final model = ProductOrderModel(
      id: order.id,
      customerId: order.customerId,
      items: order.items,
      totalAmount: order.totalAmount,
      status: order.status,
      createdAt: order.createdAt,
    );
    return _remoteDataSource.submitOrder(model);
  }
}
