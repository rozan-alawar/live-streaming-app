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

    logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: vsync,
    );

    logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.elasticOut),
    );

    logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeIn));

    textSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: textController, curve: Curves.easeOutCubic),
    );

    backgroundColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.white,
    ).animate(
      CurvedAnimation(parent: backgroundController, curve: Curves.easeInOut),
    );
  }

  Future<void> startAnimations() async {
    logoController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    textController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 1200));

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
