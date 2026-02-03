import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../constants/firestore_paths.dart';

class NotificationService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;

  NotificationService({
    FirebaseMessaging? messaging,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> initialize(String userId) async {
    await _messaging.requestPermission();
    final token = await _messaging.getToken();
    if (token != null) {
      await _firestore.collection(FirestorePaths.users).doc(userId).set(
        {'fcm_token': token},
        SetOptions(merge: true),
      );
    }
  }
}
