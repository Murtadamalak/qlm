import '../entities/print_order.dart';
import '../entities/order_status.dart';

abstract class OrdersRepository {
  Stream<List<PrintOrder>> watchOrdersForUser(String userId);
  Stream<List<PrintOrder>> watchAllOrders();
  Future<PrintOrder> submitPrintOrder(PrintOrder order);
  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });
}
