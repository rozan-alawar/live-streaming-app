import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/features/auth/data/models/auth_state_model.dart';
import 'package:streamer/features/auth/domain/entities/user_entity.dart';
import 'package:streamer/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streamer/features/splash/presentation/controller/splash_controller.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository_interface.dart';

final splashControllerProvider = NotifierProvider<SplashController, void>(() {
  return SplashController();
});

// Firebase Providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Data Source Providers
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(firebaseAuth: ref.read(firebaseAuthProvider));
});

// Repository Providers
final authRepositoryProvider = Provider<AuthRepositoryInterface>((ref) {
  return AuthRepository(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
  );
});

// Provider for AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthStateModel>(
      (ref) => AuthController(authRepository: ref.read(authRepositoryProvider)),
    );

// Provider for auth state changes stream
final authStateStreamProvider = StreamProvider<UserEntity?>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Use Cases Providers (if implementing use cases)
// final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
//   return SignInUseCase(authRepository: ref.read(authRepositoryProvider));
// });

// final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
//   return SignUpUseCase(authRepository: ref.read(authRepositoryProvider));
// });

// final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
//   return SignOutUseCase(authRepository: ref.read(authRepositoryProvider));
// });
