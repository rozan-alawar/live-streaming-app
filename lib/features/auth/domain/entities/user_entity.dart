import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime createdAt;
  final bool isEmailVerified;
  final String? phoneNumber;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.createdAt,
    this.isEmailVerified = false,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoURL,
    createdAt,
    isEmailVerified,
    phoneNumber,
  ];

  @override
  String toString() {
    return 'UserEntity(uid: $uid, email: $email, displayName: $displayName)';
  }
}
