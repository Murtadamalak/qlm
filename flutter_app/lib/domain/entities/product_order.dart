import 'package:equatable/equatable.dart';
import 'cart_item.dart';
import 'order_status.dart';

class ProductOrder extends Equatable {
  final String id;
  final String customerId;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;

  const ProductOrder({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, customerId, items, totalAmount, status, createdAt];
}
