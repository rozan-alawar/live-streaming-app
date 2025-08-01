import '../entities/user_entity.dart';

abstract class AuthRepositoryInterface {
  // Authentication Methods
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserEntity?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  // Password Management
  Future<void> resetPassword({required String email});

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  // User Management
  Future<UserEntity?> getCurrentUser();

  Future<void> updateUserProfile({String? displayName, String? photoURL});

  // Email Verification
  Future<void> sendEmailVerification();

  Future<void> reloadUser();

  // Stream for auth state changes
  Stream<UserEntity?> get authStateChanges;

  // Check if user is signed in
  bool get isSignedIn;
}
