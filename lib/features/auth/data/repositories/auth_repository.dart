import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository_interface.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepository implements AuthRepositoryInterface {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserEntity?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _remoteDataSource.resetPassword(email: email);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // TODO: Implement change password
    throw UnimplementedError('Change password not implemented yet');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      return await _remoteDataSource.getCurrentUser();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    // TODO: Implement update user profile
    throw UnimplementedError('Update user profile not implemented yet');
  }

  @override
  Future<void> sendEmailVerification() async {
    // TODO: Implement send email verification
    throw UnimplementedError('Send email verification not implemented yet');
  }

  @override
  Future<void> reloadUser() async {
    // TODO: Implement reload user
    throw UnimplementedError('Reload user not implemented yet');
  }

  @override
  Stream<UserEntity?> get authStateChanges =>
      _remoteDataSource.authStateChanges;

  @override
  bool get isSignedIn => _remoteDataSource.isSignedIn;
}
