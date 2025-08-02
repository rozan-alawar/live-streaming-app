import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/di/dependency_injection.dart';
import 'package:streamer/core/router/app_routes.dart';
import 'package:streamer/core/router/navigation_service.dart';
import 'package:streamer/features/streaming/presentation/controllers/home_state.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../../auth/domain/entities/user_entity.dart';

class UserHeader extends ConsumerWidget {
  final UserEntity? user;
  final HomeStateSuccess state;

  const UserHeader(this.state, {super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // User Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child:
                user?.photoURL != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(27),
                      child: Image.network(
                        user!.photoURL!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => _buildInitials(),
                      ),
                    )
                    : _buildInitials(),
          ),

          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  _getGreeting(),
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 4),
                CustomText(
                  user?.displayName ?? _getNameFromEmail(),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const CustomText(
                      'Online',
                      fontSize: 12,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Notification & Settings
          Row(
            children: [
              // Notifications
              GestureDetector(
                onTap: () {
                  NavigationService.pushNamed(
                    RouteNames.notification,
                    arguments: {"state": state},
                  );
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.textSecondary,
                          size: 25,
                        ),
                      ),
                      // Notification badge
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: const CustomText(
                            '3',
                            fontSize: 9,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Settings/Menu
              GestureDetector(
                onTap: () => _showUserMenu(context, ref),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitials() {
    final name = user?.displayName ?? _getNameFromEmail();
    final initials =
        name
            .split(' ')
            .map((word) => word.isNotEmpty ? word[0] : '')
            .take(2)
            .join()
            .toUpperCase();

    return Center(
      child: CustomText(
        initials.isEmpty ? 'U' : initials,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
    );
  }

  String _getNameFromEmail() {
    if (user?.email == null) return 'User';
    final emailName = user!.email.split('@')[0];
    return emailName
        .replaceAll('.', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join(' ');
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _showUserMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 24),

                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to profile
                  },
                ),

                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to settings
                  },
                ),

                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to help
                  },
                ),

                const Divider(height: 32),

                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showSignOutDialog(context, ref);
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? AppColors.error : AppColors.textSecondary,
      ),
      title: CustomText(
        title,
        fontSize: 16,
        color: isDestructive ? AppColors.error : AppColors.textPrimary,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const CustomText(
              'Sign Out',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            content: const CustomText(
              'Are you sure you want to sign out?',
              fontSize: 16,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const CustomText(
                  'Cancel',
                  color: AppColors.textSecondary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(authControllerProvider.notifier).signOut();
                },
                child: const CustomText(
                  'Sign Out',
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
    );
  }
}
