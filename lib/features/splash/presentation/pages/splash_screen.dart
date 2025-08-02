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
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            // Top spacer
            const Spacer(flex: 2),

            // Logo and App Name Section
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with animation
                  AnimatedBuilder(
                    animation: controller.logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: controller.logoOpacityAnimation.value,
                        child: Transform.scale(
                          scale: controller.logoScaleAnimation.value,
                          child: Image.asset(
                            'assets/streamer.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // App Name with animation
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
                          child: // App Name
                              Column(
                            children: [
                              AnimatedBuilder(
                                animation: controller.textController,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity:
                                        controller.textOpacityAnimation.value,
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
                                    opacity:
                                        controller.textOpacityAnimation.value *
                                        0.8,
                                    child: Transform.translate(
                                      offset: Offset(
                                        0,
                                        controller.textSlideAnimation.value +
                                            10,
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
                ],
              ),
            ),

            // Loading indicator section
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Loading indicator
                  AnimatedBuilder(
                    animation: controller.textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: controller.textOpacityAnimation.value,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 80),
                          child: const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
