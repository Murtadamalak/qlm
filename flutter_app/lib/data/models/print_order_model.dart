import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/print_order.dart';
import '../../domain/entities/order_status.dart';

class PrintOrderModel extends PrintOrder {
  const PrintOrderModel({
    required super.id,
    required super.customerId,
    required super.fileName,
    required super.fileUrl,
    required super.paperSize,
    required super.isColor,
    required super.copies,
    required super.binding,
    required super.price,
    required super.status,
    required super.createdAt,
  });

  factory PrintOrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return PrintOrderModel(
      id: doc.id,
      customerId: data['customer_id'] as String? ?? '',
      fileName: data['file_name'] as String? ?? '',
      fileUrl: data['file_url'] as String? ?? '',
      paperSize: data['paper_size'] as String? ?? '',
      isColor: data['is_color'] as bool? ?? false,
      copies: (data['copies'] as num?)?.toInt() ?? 1,
      binding: data['binding'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      status: OrderStatusX.fromValue(data['status'] as String? ?? 'pending'),
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customer_id': customerId,
      'file_name': fileName,
      'file_url': fileUrl,
      'paper_size': paperSize,
      'is_color': isColor,
      'copies': copies,
      'binding': binding,
      'price': price,
      'status': status.name,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
