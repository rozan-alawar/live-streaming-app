import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/features/auth/data/models/auth_state_model.dart';
import 'package:streamer/features/auth/domain/entities/user_entity.dart';
import 'package:streamer/features/auth/presentation/controllers/auth_controller.dart';
import 'package:streamer/features/splash/presentation/controller/splash_controller.dart';
import 'package:streamer/features/streaming/data/datasources/home_data_source.dart';
import 'package:streamer/features/streaming/data/repositories/home_repository.dart';
import 'package:streamer/features/streaming/domain/repository/home_repository_interface.dart';
import 'package:streamer/features/streaming/domain/usecases/home_usecases.dart';
import 'package:streamer/features/streaming/presentation/controllers/home_controller.dart';
import 'package:streamer/features/streaming/presentation/controllers/home_state.dart';

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

// Home Data Sources
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSourceImpl();
});

// Home Repository
final homeRepositoryProvider = Provider<HomeRepositoryInterface>((ref) {
  return HomeRepository(
    remoteDataSource: ref.read(homeRemoteDataSourceProvider),
  );
});

// Home Use Cases
final getHomeDataUseCaseProvider = Provider<GetHomeDataUseCase>((ref) {
  return GetHomeDataUseCase(ref.read(homeRepositoryProvider));
});

final refreshHomeDataUseCaseProvider = Provider<RefreshHomeDataUseCase>((ref) {
  return RefreshHomeDataUseCase(ref.read(homeRepositoryProvider));
});

final getLiveStreamsUseCaseProvider = Provider<GetLiveStreamsUseCase>((ref) {
  return GetLiveStreamsUseCase(ref.read(homeRepositoryProvider));
});

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((
  ref,
) {
  return GetNotificationsUseCase(ref.read(homeRepositoryProvider));
});

final markNotificationAsReadUseCaseProvider =
    Provider<MarkNotificationAsReadUseCase>((ref) {
      return MarkNotificationAsReadUseCase(ref.read(homeRepositoryProvider));
    });

final searchStreamsUseCaseProvider = Provider<SearchStreamsUseCase>((ref) {
  return SearchStreamsUseCase(ref.read(homeRepositoryProvider));
});

final getUserStatsUseCaseProvider = Provider<GetUserStatsUseCase>((ref) {
  return GetUserStatsUseCase(ref.read(homeRepositoryProvider));
});

// Home Controller
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    return HomeController(
      getHomeDataUseCase: ref.read(getHomeDataUseCaseProvider),
      refreshHomeDataUseCase: ref.read(refreshHomeDataUseCaseProvider),
      getLiveStreamsUseCase: ref.read(getLiveStreamsUseCaseProvider),
      getNotificationsUseCase: ref.read(getNotificationsUseCaseProvider),
      markNotificationAsReadUseCase: ref.read(
        markNotificationAsReadUseCaseProvider,
      ),
      searchStreamsUseCase: ref.read(searchStreamsUseCaseProvider),
      getUserStatsUseCase: ref.read(getUserStatsUseCaseProvider),
    );
  },
);
