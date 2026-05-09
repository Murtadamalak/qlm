import '../../domain/entities/print_order.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/print_order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl({OrdersRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? OrdersRemoteDataSource();

  @override
  Stream<List<PrintOrder>> watchOrdersForUser(String userId) =>
      _remoteDataSource.watchOrdersForUser(userId);

  @override
  Stream<List<PrintOrder>> watchAllOrders() =>
      _remoteDataSource.watchAllOrders();

  @override
  Future<PrintOrder> submitPrintOrder(PrintOrder order) {
    return _remoteDataSource.submitPrintOrder(PrintOrderModel(
      id: order.id,
      customerId: order.customerId,
      fileName: order.fileName,
      fileUrl: order.fileUrl,
      paperSize: order.paperSize,
      isColor: order.isColor,
      copies: order.copies,
      binding: order.binding,
      price: order.price,
      status: order.status,
      createdAt: order.createdAt,
    ));
  }

  @override
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) => _remoteDataSource.updateOrderStatus(orderId: orderId, status: status);
}
