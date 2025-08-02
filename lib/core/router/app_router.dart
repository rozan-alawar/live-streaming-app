import 'package:flutter/material.dart';
import 'package:streamer/core/router/app_routes.dart';
import 'package:streamer/features/splash/presentation/pages/splash_screen.dart';
import 'package:streamer/features/streaming/presentation/controllers/home_state.dart';
import 'package:streamer/features/streaming/presentation/pages/home_page.dart';
import 'package:streamer/features/streaming/presentation/pages/notifications_screen.dart';

import '../../features/auth/presentation/pages/auth_wrapper.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.initial:
        return _buildRoute(const SplashScreen(), settings);
      case RouteNames.auth:
        return _buildRoute(const AuthWrapper(), settings);

      case RouteNames.signIn:
        return _buildRoute(const SignInPage(), settings);

      case RouteNames.signUp:
        return _buildRoute(const SignUpPage(), settings);

      case RouteNames.home:
        return _buildRoute(const HomePage(), settings);
      case RouteNames.notification:
        final args = settings.arguments as Map<String, dynamic>?;

        return _buildRoute(
          NotificationsScreen(state: args?['state'] as HomeStateSuccess),
          settings,
        );

      // case RouteNames.liveStreaming:
      //   final args = settings.arguments as Map<String, dynamic>?;
      //   final isHost = args?['isHost'] ?? false;
      //   return _buildRoute(
      //     LiveStreamingPage(isHost: isHost),
      //     settings,
      //   );

      default:
        return _buildRoute(const _NotFoundPage(), settings);
    }
  }

  static PageRoute<T> _buildRoute<T>(Widget child, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide transition from right to left
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Custom transitions for different routes
  static PageRoute<T> _buildFadeRoute<T>(Widget child, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRoute<T> _buildScaleRoute<T>(
    Widget child,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;
        var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));

        return ScaleTransition(scale: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
