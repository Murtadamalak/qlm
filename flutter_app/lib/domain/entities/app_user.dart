import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String id;
  final String phoneNumber;
  final String role;
  final String? displayName;

  const AppUser({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.displayName,
  });

  @override
  List<Object?> get props => [id, phoneNumber, role, displayName];
}
