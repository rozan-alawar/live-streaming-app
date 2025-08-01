import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/di/dependency_injection.dart';
import 'package:streamer/features/streaming/presentation/pages/home_page.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/auth_state_model.dart';
import 'sign_in_page.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    switch (authState.state) {
      case AuthState.loading:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        );

      case AuthState.authenticated:
        if (authState.user != null) {
          return const HomePage();
        }
        return const SignInPage();

      case AuthState.unauthenticated:
      case AuthState.error:
      case AuthState.initial:
      default:
        return const SignInPage();
    }
  }
}
