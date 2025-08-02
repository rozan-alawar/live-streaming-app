import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/constants/app_colors.dart';
import 'package:streamer/core/di/dependency_injection.dart';
import 'package:streamer/core/widgets/custom_text_widget.dart';
import 'package:streamer/features/streaming/presentation/controllers/home_state.dart';

class NotificationsScreen extends ConsumerWidget {
  final HomeStateSuccess state;
  const NotificationsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          'Notifications',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          if (state.unreadNotificationsCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomText(
                '${state.unreadNotificationsCount}',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          const SizedBox(width: 24),
        ],
      ),
      body: Column(
        children: [
          // Notifications Section
          if (state.notifications.isNotEmpty) ...[
            Container(
              height:
                  MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    ...state.notifications.take(3).map((notification) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              notification.isRead
                                  ? AppColors.white
                                  : AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                notification.isRead
                                    ? AppColors.border
                                    : AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    notification.title,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    notification.message,
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            if (!notification.isRead)
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(homeControllerProvider.notifier)
                                      .markNotificationAsRead(notification.id);
                                },
                                child: const Icon(
                                  Icons.mark_email_read,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
