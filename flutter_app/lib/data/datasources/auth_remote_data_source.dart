import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firestore_paths.dart';
import '../models/app_user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (exception) => onError(exception.message ?? 'Auth error'),
      codeSent: (verificationId, _) => onCodeSent(verificationId),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<AppUserModel> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await _auth.signInWithCredential(credential);
    final user = result.user;
    if (user == null) {
      throw StateError('Authentication failed');
    }
    final docRef = _firestore.collection(FirestorePaths.users).doc(user.uid);
    final snapshot = await docRef.get();
    if (!snapshot.exists) {
      final model = AppUserModel(
        id: user.uid,
        phoneNumber: user.phoneNumber ?? '',
        role: 'customer',
      );
      await docRef.set(model.toFirestore());
      return model;
    }
    return AppUserModel.fromFirestore(snapshot);
  }

  Future<void> signOut() => _auth.signOut();

  Future<AppUserModel?> currentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snapshot = await _firestore
        .collection(FirestorePaths.users)
        .doc(user.uid)
        .get();
    if (!snapshot.exists) return null;
    return AppUserModel.fromFirestore(snapshot);
  }
}
