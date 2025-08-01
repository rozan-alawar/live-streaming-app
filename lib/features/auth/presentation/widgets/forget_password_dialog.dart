import 'package:flutter/material.dart';
import 'package:streamer/core/constants/app_colors.dart';
import 'package:streamer/core/constants/app_strings.dart';
import 'package:streamer/core/widgets/custom_text_field.dart';
import 'package:streamer/core/widgets/custom_text_widget.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final Future<void> Function(String email) onResetPassword;

  const ForgotPasswordDialog({super.key, required this.onResetPassword});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomText(AppStrings.pleaseEnterEmail),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    ).hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: CustomText(AppStrings.pleaseEnterValidEmail),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onResetPassword(_emailController.text.trim());
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const CustomText(
        AppStrings.resetPassword,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            AppStrings.resetPasswordMessage,
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            hint: AppStrings.email,
            prefixIcon: const Icon(Icons.email_outlined),
            controller: _emailController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const CustomText(
            AppStrings.cancel,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _handleResetPassword,
          child:
              _isLoading
                  ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                  : const CustomText(
                    AppStrings.send,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
        ),
      ],
    );
  }
}
