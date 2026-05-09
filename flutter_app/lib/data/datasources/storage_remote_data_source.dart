import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRemoteDataSource {
  final FirebaseStorage _storage;

  StorageRemoteDataSource({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadPrintFileBytes({
    required Uint8List bytes,
    required String userId,
    required String fileName,
    required String contentType,
  }) async {
    final safeFileName = fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final ref = _storage.ref().child(
          'print_jobs/$userId/${DateTime.now().millisecondsSinceEpoch}_$safeFileName',
        );
    final metadata = SettableMetadata(contentType: contentType);
    final task = await ref.putData(bytes, metadata);
    return task.ref.getDownloadURL();
  }
}
