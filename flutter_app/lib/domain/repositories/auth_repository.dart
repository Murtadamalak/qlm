import '../entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  });
  Future<AppUser> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  });
  Future<void> signOut();
  Future<AppUser?> currentUser();
}
