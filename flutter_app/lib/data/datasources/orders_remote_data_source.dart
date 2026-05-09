import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../../domain/entities/order_status.dart';
import '../models/print_order_model.dart';

class OrdersRemoteDataSource {
  final FirebaseFirestore _firestore;

  OrdersRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<PrintOrderModel>> watchOrdersForUser(String userId) {
    return _firestore
        .collection(FirestorePaths.orders)
        .where('customer_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(PrintOrderModel.fromFirestore)
            .toList(growable: false));
  }

  Stream<List<PrintOrderModel>> watchAllOrders() {
    return _firestore
        .collection(FirestorePaths.orders)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(PrintOrderModel.fromFirestore)
            .toList(growable: false));
  }

  Future<PrintOrderModel> submitPrintOrder(PrintOrderModel order) async {
    final docRef = _firestore.collection(FirestorePaths.orders).doc();
    final model = PrintOrderModel(
      id: docRef.id,
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
    );
    await docRef.set(model.toFirestore());
    return model;
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    await _firestore
        .collection(FirestorePaths.orders)
        .doc(orderId)
        .update({'status': status.name});
  }
}
