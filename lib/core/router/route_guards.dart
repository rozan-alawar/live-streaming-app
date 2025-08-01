import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/di/dependency_injection.dart';
import 'package:streamer/core/router/app_routes.dart';

import 'navigation_service.dart';

abstract class RouteGuard {
  bool canActivate(BuildContext context, WidgetRef ref);
  String get redirectRoute;
}

class AuthGuard implements RouteGuard {
  @override
  bool canActivate(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authControllerProvider);
    return authState.isAuthenticated;
  }

  @override
  String get redirectRoute => RouteNames.signIn;
}

class GuestGuard implements RouteGuard {
  @override
  bool canActivate(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authControllerProvider);
    return !authState.isAuthenticated;
  }

  @override
  String get redirectRoute => RouteNames.home;
}

class RouteGuardService {
  static final List<RouteGuard> _guards = [];

  static void registerGuards() {
    _guards.addAll([AuthGuard(), GuestGuard()]);
  }

  static bool canActivateRoute(
    String routeName,
    BuildContext context,
    WidgetRef ref,
  ) {
    final guard = _getGuardForRoute(routeName);
    if (guard == null) return true;

    final canActivate = guard.canActivate(context, ref);
    if (!canActivate) {
      NavigationService.pushReplacementNamed(guard.redirectRoute);
    }
    return canActivate;
  }

  static RouteGuard? _getGuardForRoute(String routeName) {
    switch (routeName) {
      case RouteNames.home:
      case RouteNames.profile:
      case RouteNames.settings:
      case RouteNames.liveStreaming:
      case RouteNames.editProfile:
        return _guards.firstWhere((guard) => guard is AuthGuard);

      case RouteNames.signIn:
      case RouteNames.signUp:
      case RouteNames.forgotPassword:
        return _guards.firstWhere((guard) => guard is GuestGuard);

      default:
        return null;
    }
  }
}

// Protected Route Widget
class ProtectedRoute extends ConsumerWidget {
  final Widget child;
  final RouteGuard guard;
  final String? redirectRoute;

  const ProtectedRoute({
    super.key,
    required this.child,
    required this.guard,
    this.redirectRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (guard.canActivate(context, ref)) {
      return child;
    } else {
      // Redirect to appropriate route
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.pushReplacementNamed(
          redirectRoute ?? guard.redirectRoute,
        );
      });

      // Show loading while redirecting
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}

// Auth Protected Route
class AuthProtectedRoute extends ConsumerWidget {
  final Widget child;

  const AuthProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProtectedRoute(guard: AuthGuard(), child: child);
  }
}

// Guest Only Route
class GuestOnlyRoute extends ConsumerWidget {
  final Widget child;

  const GuestOnlyRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProtectedRoute(guard: GuestGuard(), child: child);
  }
}
