import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/product_model.dart';

class ProductsRemoteDataSource {
  final FirebaseFirestore _firestore;

  ProductsRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<ProductModel>> watchProducts() {
    return _firestore
        .collection(FirestorePaths.products)
        .where('is_active', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(ProductModel.fromFirestore)
            .toList(growable: false));
  }

  Future<void> addProduct(ProductModel product) async {
    await _firestore
        .collection(FirestorePaths.products)
        .doc(product.id)
        .set(product.toFirestore());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore
        .collection(FirestorePaths.products)
        .doc(product.id)
        .update(product.toFirestore());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection(FirestorePaths.products).doc(productId).delete();
  }
}
