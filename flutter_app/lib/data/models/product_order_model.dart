import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/product_order.dart';

class ProductOrderModel extends ProductOrder {
  const ProductOrderModel({
    required super.id,
    required super.customerId,
    required super.items,
    required super.totalAmount,
    required super.status,
    required super.createdAt,
  });

  factory ProductOrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return ProductOrderModel(
      id: doc.id,
      customerId: data['customer_id'] as String? ?? '',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((item) => CartItem(
                productId: item['product_id'] as String? ?? '',
                name: item['name'] as String? ?? '',
                unitPrice: (item['unit_price'] as num?)?.toDouble() ?? 0,
                quantity: (item['quantity'] as num?)?.toInt() ?? 1,
              ))
          .toList(growable: false),
      totalAmount: (data['total_amount'] as num?)?.toDouble() ?? 0,
      status: OrderStatusX.fromValue(data['status'] as String? ?? 'pending'),
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customer_id': customerId,
      'items': items
          .map((item) => {
                'product_id': item.productId,
                'name': item.name,
                'unit_price': item.unitPrice,
                'quantity': item.quantity,
              })
          .toList(),
      'total_amount': totalAmount,
      'status': status.name,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
