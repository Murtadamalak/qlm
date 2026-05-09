import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.phoneNumber,
    required super.role,
    super.displayName,
  });

  factory AppUserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return AppUserModel(
      id: doc.id,
      phoneNumber: data['phone_number'] as String? ?? '',
      role: data['role'] as String? ?? 'customer',
      displayName: data['display_name'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phone_number': phoneNumber,
      'role': role,
      'display_name': displayName,
    }..removeWhere((key, value) => value == null);
  }
}
