import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRemoteDataSource {
  final FirebaseStorage _storage;

  StorageRemoteDataSource({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadPrintFile({
    required File file,
    required String userId,
    required String fileName,
  }) async {
    final ref = _storage.ref().child('print_jobs/$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName');
    final task = await ref.putFile(file);
    return task.ref.getDownloadURL();
  }
}
