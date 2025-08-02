import 'package:flutter/material.dart';
import 'package:streamer/features/streaming/presentation/controllers/home_state.dart';
import 'package:streamer/features/streaming/presentation/pages/live_page.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_widget.dart';

class QuickActions extends StatelessWidget {
  QuickActions({super.key, required this.state});
  HomeStateSuccess state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Quick Actions',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Start Live Stream
              Expanded(
                child: _buildActionCard(
                  title: 'Go Live',
                  subtitle: 'Start streaming now',
                  icon: Icons.videocam,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => _navigateToLiveStreaming(context, isHost: true),
                ),
              ),
              const SizedBox(width: 16),
              // Join Stream
              Expanded(
                child: _buildActionCard(
                  title: 'Join Live',
                  subtitle: 'Watch live streams',
                  icon: Icons.tv,
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.secondaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  onTap: () => _navigateToLiveStreaming(context, isHost: false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
            const SizedBox(height: 16),
            CustomText(
              title,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
            const SizedBox(height: 4),
            CustomText(
              subtitle,
              fontSize: 12,
              color: AppColors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLiveStreaming(BuildContext context, {required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LivePage(isHost: isHost)),
    );
  }
}
