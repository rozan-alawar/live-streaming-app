import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/constants/app_colors.dart';
import 'package:streamer/core/constants/app_strings.dart';
import 'package:streamer/core/di/dependency_injection.dart';
import 'package:streamer/core/widgets/custom_text_widget.dart';
import 'package:streamer/features/splash/presentation/controller/splash_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late SplashController controller;

  @override
  void initState() {
    super.initState();
    controller = ref.read(splashControllerProvider.notifier);
    controller.init(this, context);
    controller.startAnimations();
  }

  @override
  void dispose() {
    controller.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: controller.backgroundController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  controller.backgroundColorAnimation.value ??
                      AppColors.primary,
                  (controller.backgroundColorAnimation.value ??
                          AppColors.primary)
                      .withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: controller.logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: controller.logoOpacityAnimation.value,
                        child: Transform.scale(
                          scale: controller.logoScaleAnimation.value,
                          child: Image.asset("assets/streamer.png"),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // App Name
                  AnimatedBuilder(
                    animation: controller.textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: controller.textOpacityAnimation.value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            controller.textSlideAnimation.value,
                          ),
                          child: const CustomText(
                            AppStrings.appName,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Tagline
                  AnimatedBuilder(
                    animation: controller.textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: controller.textOpacityAnimation.value * 0.8,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            controller.textSlideAnimation.value + 10,
                          ),
                          child: const CustomText(
                            AppStrings.multiStreamingWithFriends,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
