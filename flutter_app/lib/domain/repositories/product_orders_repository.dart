import '../entities/product_order.dart';

abstract class ProductOrdersRepository {
  Stream<List<ProductOrder>> watchOrdersForUser(String userId);
  Future<ProductOrder> submitOrder(ProductOrder order);
}
