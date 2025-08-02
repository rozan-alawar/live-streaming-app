import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/router/app_routes.dart';
import 'package:streamer/core/router/navigation_service.dart';

import '../../data/models/auth_state_model.dart';
import '../../domain/repositories/auth_repository_interface.dart';

class AuthController extends StateNotifier<AuthStateModel> {
  final AuthRepositoryInterface _authRepository;

  AuthController({required AuthRepositoryInterface authRepository})
    : _authRepository = authRepository,
      super(const AuthStateModel(state: AuthState.initial)) {
    _initAuthState();
  }

  void _initAuthState() {
    final isSignedIn = _authRepository.isSignedIn;
    if (isSignedIn) {
      _getCurrentUser();
    } else {
      state = const AuthStateModel(state: AuthState.unauthenticated);
    }
  }

  Future<void> _getCurrentUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        state = AuthStateModel(state: AuthState.authenticated, user: user);
      } else {
        state = const AuthStateModel(state: AuthState.unauthenticated);
      }
    } catch (e) {
      state = AuthStateModel(
        state: AuthState.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(state: AuthState.loading);

      final user = await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        state = AuthStateModel(state: AuthState.authenticated, user: user);
        NavigationService.pushReplacementNamed(RouteNames.home);
        log('User signed in: ${user.email}');
      } else {
        state = const AuthStateModel(
          state: AuthState.error,
          errorMessage: 'Sign in failed',
        );
      }
    } catch (e) {
      state = AuthStateModel(
        state: AuthState.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(state: AuthState.loading);

      final user = await _authRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        state = AuthStateModel(state: AuthState.authenticated, user: user);
      } else {
        state = const AuthStateModel(
          state: AuthState.error,
          errorMessage: 'Account creation failed',
        );
      }
    } catch (e) {
      state = AuthStateModel(
        state: AuthState.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> signOut() async {
    try {
      state = state.copyWith(state: AuthState.loading);

      await _authRepository.signOut();

      state = const AuthStateModel(state: AuthState.unauthenticated);
    } catch (e) {
      state = AuthStateModel(
        state: AuthState.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _authRepository.resetPassword(email: email);
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  void clearError() {
    if (state.hasError) {
      state = state.copyWith(
        state: AuthState.unauthenticated,
        errorMessage: null,
      );
    }
  }

  void resetToInitial() {
    state = const AuthStateModel(state: AuthState.initial);
  }
}
