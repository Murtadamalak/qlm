import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/product_order_model.dart';

class ProductOrdersRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductOrdersRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<ProductOrderModel>> watchOrdersForUser(String userId) {
    return _firestore
        .collection(FirestorePaths.productOrders)
        .where('customer_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(ProductOrderModel.fromFirestore)
            .toList(growable: false));
  }

  Future<ProductOrderModel> submitOrder(ProductOrderModel order) async {
    final docRef = _firestore.collection(FirestorePaths.productOrders).doc();
    final model = ProductOrderModel(
      id: docRef.id,
      customerId: order.customerId,
      items: order.items,
      totalAmount: order.totalAmount,
      status: order.status,
      createdAt: order.createdAt,
    );
    await docRef.set(model.toFirestore());
    return model;
  }
}
