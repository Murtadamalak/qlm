import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../core/services/notification_service.dart';

class AuthController extends ChangeNotifier {
  final AuthRepositoryImpl _repository;

  AppUser? _currentUser;
  String? _verificationId;
  bool _isLoading = false;
  String? _errorMessage;

  AuthController({AuthRepositoryImpl? repository})
      : _repository = repository ?? AuthRepositoryImpl();

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get verificationId => _verificationId;

  Future<void> loadCurrentUser() async {
    _currentUser = await _repository.currentUser();
    notifyListeners();
  }

  Future<void> sendOtp(String phoneNumber) async {
    _setLoading(true);
    _errorMessage = null;
    await _repository.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: (verificationId) {
        _verificationId = verificationId;
        _setLoading(false);
      },
      onError: (error) {
        _errorMessage = error;
        _setLoading(false);
      },
    );
  }

  Future<void> verifyOtp(String smsCode) async {
    if (_verificationId == null) return;
    _setLoading(true);
    try {
      _currentUser = await _repository.signInWithSmsCode(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      if (_currentUser != null) {
        await NotificationService().initialize(_currentUser!.id);
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
