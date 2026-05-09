import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';

class SupportRemoteDataSource {
  final FirebaseFirestore _firestore;

  SupportRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<String?> watchSupportPhoneNumber() {
    return _firestore
        .collection(FirestorePaths.supportConfig)
        .doc('whatsapp')
        .snapshots()
        .map((doc) => doc.data()?['phone_number'] as String?);
  }
}
