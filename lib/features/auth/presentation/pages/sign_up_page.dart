import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/di/dependency_injection.dart';
import 'package:streamer/core/widgets/custom_text_field.dart';
import 'package:streamer/core/widgets/custom_text_widget.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/auth_state_model.dart';
import 'sign_in_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen<AuthStateModel>(authControllerProvider, (previous, next) {
      if (next.hasError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(next.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
        ref.read(authControllerProvider.notifier).clearError();
      } else if (next.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: CustomText(AppStrings.accountCreatedSuccessfully),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    kToolbarHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // Logo - responsive size
                    SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom > 0
                              ? 60
                              : 80,
                      child: Image.asset(
                        "assets/streamer.png",
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom > 0
                              ? 16
                              : 32,
                    ),

                    const CustomHeading(AppStrings.createNewAccount),

                    SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom > 0
                              ? 24
                              : 40,
                    ),

                    // Email field - now dynamic
                    CustomTextField(
                      hint: AppStrings.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterEmail;
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return AppStrings.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Password field - now dynamic
                    CustomTextField(
                      hint: AppStrings.password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppStrings.pleaseEnterPassword;
                        }
                        if (value.length < 6) {
                          return AppStrings.passwordTooShort;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Confirm Password field - new
                    CustomTextField(
                      hint: AppStrings.confirmPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return AppStrings.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Remember me checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const CustomCaptionText(AppStrings.rememberMe),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sign up button
                    CustomButton(
                      text: AppStrings.signUp,
                      onPressed: _signUp,
                      isLoading: authState.isLoading,
                    ),

                    const SizedBox(height: 32),

                    // Flexible spacer
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 20),
                      ),
                    ),

                    // Bottom section - Sign in link
                    Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom > 0
                                ? 16
                                : 24,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CustomCaptionText(
                            AppStrings.alreadyHaveAccount,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignInPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const CustomText(
                              AppStrings.signIn,
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
