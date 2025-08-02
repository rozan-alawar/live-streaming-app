import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/router/app_routes.dart';
import 'package:streamer/core/router/navigation_service.dart';

class SplashController extends Notifier<void> {
  late AnimationController logoController;
  late AnimationController textController;
  late AnimationController backgroundController;

  late Animation<double> logoScaleAnimation;
  late Animation<double> logoOpacityAnimation;
  late Animation<double> textOpacityAnimation;
  late Animation<double> textSlideAnimation;
  late Animation<Color?> backgroundColorAnimation;

  BuildContext? context;

  @override
  void build() {}

  void init(TickerProvider vsync, BuildContext context) {
    this.context = context;

    // Logo animation controller
    logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: vsync,
    );

    // Text animation controller
    textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    // Background animation controller (not needed for white background but keeping for consistency)
    backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    // Logo animations - bouncy entrance
    logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.elasticOut),
    );

    logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Text animations - smooth slide up
    textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeInOut));

    textSlideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: textController, curve: Curves.easeOutCubic),
    );

    // Background animation (keeping white)
    backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.white,
    ).animate(
      CurvedAnimation(parent: backgroundController, curve: Curves.easeInOut),
    );
  }

  Future<void> startAnimations() async {
    // Start logo animation first
    logoController.forward();

    // Wait a bit then start text animation
    await Future.delayed(const Duration(milliseconds: 600));
    textController.forward();

    // Start background animation
    backgroundController.forward();

    // Wait for animations to complete, then navigate
    await Future.delayed(const Duration(milliseconds: 2500));
    _navigateToNext();
  }

  void _navigateToNext() {
    if (context != null) {
      NavigationService.pushReplacementNamed(RouteNames.auth);
    }
  }

  void disposeControllers() {
    logoController.dispose();
    textController.dispose();
    backgroundController.dispose();
  }
}
