import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/core/di/dependency_injection.dart';
import 'package:streamer/features/streaming/presentation/controllers/home_state.dart';
import 'package:streamer/features/streaming/presentation/pages/live_page.dart';
import 'package:streamer/features/streaming/presentation/widgets/quick_actions.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../widgets/feature_card.dart';
import '../widgets/user_header.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final homeState = ref.watch(homeControllerProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(homeControllerProvider.notifier).refresh();
          },
          child: _buildBody(homeState, user),
        ),
      ),
    );
  }

  Widget _buildBody(HomeState homeState, user) {
    if (homeState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (homeState.isError) {
      final errorState = homeState as HomeStateError;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            const CustomText(
              'Error loading data',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: 8),
            CustomText(
              errorState.message,
              fontSize: 14,
              color: AppColors.textSecondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Retry',
              onPressed: () {
                ref.read(homeControllerProvider.notifier).initialize();
              },
            ),
          ],
        ),
      );
    }

    if (homeState.isSuccess) {
      final successState = homeState as HomeStateSuccess;
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Section
            UserHeader(successState, user: user),

            const SizedBox(height: 24),

            // Welcome Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CustomText(
                        'Welcome to Streamer!',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      Image.asset('assets/streamer.png', width: 50, height: 50),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const CustomText(
                    'Ready to start streaming or watch amazing content?',
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Quick Actions
            QuickActions(state: successState),

            const SizedBox(height: 32),

            // Live Streams Section
            if (successState.liveStreams.isNotEmpty) ...[
              _buildLiveStreamsSection(successState),
              const SizedBox(height: 32),
            ],

            // Features Section
            _buildFeaturesSection(successState),

            const SizedBox(height: 32),

            // User Stats Section
            if (successState.userStats != null) ...[
              _buildUserStatsSection(successState),
              const SizedBox(height: 32),
            ],

            const SizedBox(height: 32),
          ],
        ),
      );
    }

    // Fallback for initial state
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildLiveStreamsSection(HomeStateSuccess state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Live Now ',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all live streams
                },
                child: const CustomText(
                  'See All',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.liveStreams.length,
              itemBuilder: (context, index) {
                final stream = state.liveStreams[index];
                return Container(
                  width: 280,
                  margin: EdgeInsets.only(
                    right: index < state.liveStreams.length - 1 ? 16 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textSecondary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CustomText(
                              'LIVE',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                            const Spacer(),
                            CustomText(
                              '${stream.viewerCount} viewers',
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomText(
                          stream.title,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: AppColors.primary,
                              child: CustomText(
                                stream.hostName[0].toUpperCase(),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomText(
                                stream.hostName,
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        CustomButton(
                          text: 'Join Stream',
                          height: 45,
                          onPressed:
                              () => _navigateToLiveStreaming(
                                context,
                                isHost: false,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(HomeStateSuccess state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Features',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
            children:
                state.features.map((feature) {
                  IconData iconData = Icons.widgets;
                  Color color = AppColors.primary;

                  // Map feature icons and colors
                  switch (feature.iconData) {
                    case 'videocam':
                      iconData = Icons.videocam;
                      color = AppColors.primary;
                      break;
                    case 'tv':
                      iconData = Icons.tv;
                      color = AppColors.secondary;
                      break;
                    case 'people':
                      iconData = Icons.people;
                      color = AppColors.info;
                      break;
                    case 'settings':
                      iconData = Icons.settings;
                      color = AppColors.warning;
                      break;
                  }

                  return FeatureCard(
                    icon: iconData,
                    title: feature.title,
                    description: feature.description,
                    color: color,
                    onTap: () {
                      if (feature.route == '/live/host') {
                        _navigateToLiveStreaming(context, isHost: true);
                      } else if (feature.route == '/live/audience') {
                        _navigateToLiveStreaming(context, isHost: false);
                      } else {
                        _showComingSoon(context, feature.title);
                      }
                    },
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsSection(HomeStateSuccess state) {
    final stats = state.userStats!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            'Your Stats',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
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
                Expanded(
                  child: _buildStatItem('Streams', '${stats.totalStreams}'),
                ),
                Expanded(
                  child: _buildStatItem('Viewers', '${stats.totalViewers}'),
                ),
                Expanded(
                  child: _buildStatItem('Followers', '${stats.followersCount}'),
                ),
                Expanded(
                  child: _buildStatItem('Following', '${stats.followingCount}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        CustomText(
          value,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
        const SizedBox(height: 4),
        CustomText(label, fontSize: 12, color: AppColors.textSecondary),
      ],
    );
  }

  void _navigateToLiveStreaming(BuildContext context, {required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LivePage(isHost: isHost)),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: CustomText(
              '$feature Feature',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            content: const CustomText(
              'This feature is coming soon! Stay tuned for updates.',
              fontSize: 16,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const CustomText(
                  'OK',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
    );
  }
}
