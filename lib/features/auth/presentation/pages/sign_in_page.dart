import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/di/dependency_injection.dart';
import 'package:streamer/core/widgets/custom_text_widget.dart';
import 'package:streamer/features/auth/presentation/pages/sign_up_page.dart';
import 'package:streamer/features/auth/presentation/widgets/forget_password_dialog.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/auth_state_model.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider.notifier)
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => ForgotPasswordDialog(
            onResetPassword: (email) async {
              try {
                await ref
                    .read(authControllerProvider.notifier)
                    .resetPassword(email: email);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: CustomText(AppStrings.passwordResetEmailSent),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: CustomText(
                        e.toString().replaceFirst('Exception: ', ''),
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
          ),
    );
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
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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

                    const CustomText(
                      AppStrings.loginToYourAccount,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom > 0
                              ? 24
                              : 40,
                    ),

                    // Form fields
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
                        const CustomText(
                          AppStrings.rememberMe,
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Sign in button
                    CustomButton(
                      text: AppStrings.signIn,
                      onPressed: _signIn,
                      isLoading: authState.isLoading,
                    ),

                    const SizedBox(height: 16),

                    // Forgot password
                    TextButton(
                      onPressed: _showForgotPasswordDialog,
                      child: const CustomText(
                        AppStrings.forgotPassword,
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // Flexible spacer that adjusts to keyboard
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 20),
                      ),
                    ),

                    // Bottom section - Sign up link
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
                          const CustomText(
                            AppStrings.dontHaveAccount,
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const CustomText(
                              AppStrings.signUp,
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
