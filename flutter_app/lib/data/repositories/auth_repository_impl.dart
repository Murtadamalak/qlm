import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Stream<AppUser?> authStateChanges() {
    return _remoteDataSource.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _remoteDataSource.currentUser();
    });
  }

  @override
  Future<AppUser?> currentUser() => _remoteDataSource.currentUser();

  @override
  Future<void> signOut() => _remoteDataSource.signOut();

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
  }) => _remoteDataSource.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: onCodeSent,
        onError: onError,
      );

  @override
  Future<AppUser> signInWithSmsCode({
    required String verificationId,
    required String smsCode,
  }) => _remoteDataSource.signInWithSmsCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );
}
