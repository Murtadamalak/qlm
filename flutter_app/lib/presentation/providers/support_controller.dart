import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/datasources/support_remote_data_source.dart';

class SupportController extends ChangeNotifier {
  final SupportRemoteDataSource _remoteDataSource;

  SupportController({SupportRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? SupportRemoteDataSource();

  Stream<String?> watchSupportPhoneNumber() {
    return _remoteDataSource.watchSupportPhoneNumber();
  }

  Future<void> openWhatsApp({
    required String phoneNumber,
    String message = 'Hello, I need assistance with my order.',
  }) async {
    final url = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw StateError('Unable to open WhatsApp');
    }
  }
}
