import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseOptionsLoader {
  const FirebaseOptionsLoader._();

  static FirebaseOptions load() {
    final apiKey = _requiredDefine('FIREBASE_API_KEY');
    final appId = _requiredDefine('FIREBASE_APP_ID');
    final messagingSenderId = _requiredDefine('FIREBASE_MESSAGING_SENDER_ID');
    final projectId = _requiredDefine('FIREBASE_PROJECT_ID');
    final authDomain = _optionalDefine('FIREBASE_AUTH_DOMAIN');
    final storageBucket = _optionalDefine('FIREBASE_STORAGE_BUCKET');
    final measurementId = _optionalDefine('FIREBASE_MEASUREMENT_ID');
    final iosBundleId = _optionalDefine('FIREBASE_IOS_BUNDLE_ID');
    final androidClientId = _optionalDefine('FIREBASE_ANDROID_CLIENT_ID');
    final iosClientId = _optionalDefine('FIREBASE_IOS_CLIENT_ID');

    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain,
      storageBucket: storageBucket,
      measurementId: measurementId,
      iosBundleId: iosBundleId,
      androidClientId: androidClientId,
      iosClientId: iosClientId,
    );
  }

  static String _requiredDefine(String key) {
    final value = _optionalDefine(key);
    if (value == null || value.isEmpty) {
      throw StateError(
        'Missing required Firebase configuration: $key. '
        'Pass it with --dart-define=$key=... when running or building.',
      );
    }
    return value;
  }

  static String? _optionalDefine(String key) {
    final value = switch (key) {
      'FIREBASE_API_KEY' => const String.fromEnvironment('FIREBASE_API_KEY'),
      'FIREBASE_APP_ID' => const String.fromEnvironment('FIREBASE_APP_ID'),
      'FIREBASE_MESSAGING_SENDER_ID' =>
        const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      'FIREBASE_PROJECT_ID' => const String.fromEnvironment('FIREBASE_PROJECT_ID'),
      'FIREBASE_AUTH_DOMAIN' =>
        const String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
      'FIREBASE_STORAGE_BUCKET' =>
        const String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
      'FIREBASE_MEASUREMENT_ID' =>
        const String.fromEnvironment('FIREBASE_MEASUREMENT_ID'),
      'FIREBASE_IOS_BUNDLE_ID' =>
        const String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID'),
      'FIREBASE_ANDROID_CLIENT_ID' =>
        const String.fromEnvironment('FIREBASE_ANDROID_CLIENT_ID'),
      'FIREBASE_IOS_CLIENT_ID' =>
        const String.fromEnvironment('FIREBASE_IOS_CLIENT_ID'),
      _ => null,
    };
    if (value == null && kDebugMode) {
      debugPrint('Unknown Firebase dart-define key requested: $key');
    }
    return value == null || value.isEmpty ? null : value;
  }
}
