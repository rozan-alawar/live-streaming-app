import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamer/features/streaming/domain/entities/feature_entity.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';
import 'package:streamer/features/streaming/domain/entities/quick_action_entity.dart';
import 'package:streamer/features/streaming/presentation/controllers/home_state.dart';

import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/home_usecases.dart';

class HomeController extends StateNotifier<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;
  final RefreshHomeDataUseCase _refreshHomeDataUseCase;
  final GetLiveStreamsUseCase _getLiveStreamsUseCase;
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  final SearchStreamsUseCase _searchStreamsUseCase;
  final GetUserStatsUseCase _getUserStatsUseCase;

  HomeController({
    required GetHomeDataUseCase getHomeDataUseCase,
    required RefreshHomeDataUseCase refreshHomeDataUseCase,
    required GetLiveStreamsUseCase getLiveStreamsUseCase,
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
    required SearchStreamsUseCase searchStreamsUseCase,
    required GetUserStatsUseCase getUserStatsUseCase,
  }) : _getHomeDataUseCase = getHomeDataUseCase,
       _refreshHomeDataUseCase = refreshHomeDataUseCase,
       _getLiveStreamsUseCase = getLiveStreamsUseCase,
       _getNotificationsUseCase = getNotificationsUseCase,
       _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
       _searchStreamsUseCase = searchStreamsUseCase,
       _getUserStatsUseCase = getUserStatsUseCase,
       super(const HomeState.initial());

  // Initialize home data
  Future<void> initialize() async {
    if (state.isLoading) return;

    state = const HomeState.loading();

    try {
      final homeData = await _getHomeDataUseCase();
      state = HomeState.success(homeData);
    } catch (e) {
      state = HomeState.error(e.toString());
    }
  }

  // Refresh home data
  Future<void> refresh() async {
    // Don't show loading state during refresh, keep current data visible
    final currentState = state;

    try {
      await _refreshHomeDataUseCase();
      final homeData = await _getHomeDataUseCase();
      state = HomeState.success(homeData);
    } catch (e) {
      // Keep current state if refresh fails
      if (currentState is HomeStateSuccess) {
        state = currentState.copyWith(isRefreshing: false);
      } else {
        state = HomeState.error(e.toString());
      }
    }
  }

  // Get live streams
  Future<void> loadLiveStreams() async {
    if (state is! HomeStateSuccess) return;

    final successState = state as HomeStateSuccess;

    try {
      final liveStreams = await _getLiveStreamsUseCase();
      final updatedHomeData = HomeDataEntity(
        liveStreams: liveStreams,
        recommendedStreams: successState.homeData.recommendedStreams,
        notifications: successState.homeData.notifications,
        quickActions: successState.homeData.quickActions,
        features: successState.homeData.features,
        userStats: successState.homeData.userStats,
      );

      state = successState.copyWith(homeData: updatedHomeData);
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  // Search streams
  Future<void> searchStreams(String query) async {
    if (query.trim().isEmpty) {
      // Clear search results
      if (state is HomeStateSuccess) {
        final successState = state as HomeStateSuccess;
        state = successState.copyWith(searchResults: []);
      }
      return;
    }

    try {
      final searchResults = await _searchStreamsUseCase(query);

      if (state is HomeStateSuccess) {
        final successState = state as HomeStateSuccess;
        state = successState.copyWith(searchResults: searchResults);
      }
    } catch (e) {
      // Handle search error
    }
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    if (state is! HomeStateSuccess) return;

    try {
      await _markNotificationAsReadUseCase(notificationId);

      // Update local state
      final successState = state as HomeStateSuccess;
      final updatedNotifications =
          successState.homeData.notifications.map((n) {
            if (n.id == notificationId) {
              return NotificationEntity(
                id: n.id,
                title: n.title,
                message: n.message,
                type: n.type,
                createdAt: n.createdAt,
                isRead: true,
                data: n.data,
              );
            }
            return n;
          }).toList();

      final updatedHomeData = HomeDataEntity(
        liveStreams: successState.homeData.liveStreams,
        recommendedStreams: successState.homeData.recommendedStreams,
        notifications: updatedNotifications,
        quickActions: successState.homeData.quickActions,
        features: successState.homeData.features,
        userStats: successState.homeData.userStats,
      );

      state = successState.copyWith(homeData: updatedHomeData);
    } catch (e) {
      // Handle error
    }
  }

  // Get user stats
  Future<void> loadUserStats() async {
    if (state is! HomeStateSuccess) return;

    try {
      final userStats = await _getUserStatsUseCase();

      final successState = state as HomeStateSuccess;
      final updatedHomeData = HomeDataEntity(
        liveStreams: successState.homeData.liveStreams,
        recommendedStreams: successState.homeData.recommendedStreams,
        notifications: successState.homeData.notifications,
        quickActions: successState.homeData.quickActions,
        features: successState.homeData.features,
        userStats: userStats,
      );

      state = successState.copyWith(homeData: updatedHomeData);
    } catch (e) {
      // Handle error silently
    }
  }

  // Filter streams by category
  void filterStreamsByCategory(String category) {
    if (state is! HomeStateSuccess) return;

    final successState = state as HomeStateSuccess;
    final filteredStreams =
        successState.homeData.liveStreams
            .where((stream) => stream.tags.contains(category.toLowerCase()))
            .toList();

    state = successState.copyWith(searchResults: filteredStreams);
  }

  // Clear search results
  void clearSearch() {
    if (state is HomeStateSuccess) {
      final successState = state as HomeStateSuccess;
      state = successState.copyWith(searchResults: []);
    }
  }

  // Handle navigation to feature
  void navigateToFeature(FeatureEntity feature) {
    // This could trigger navigation logic
    // For now, we'll just track the action
    if (state is HomeStateSuccess) {
      final successState = state as HomeStateSuccess;
      state = successState.copyWith(lastSelectedFeature: feature);
    }
  }

  // Handle quick action
  void executeQuickAction(QuickActionEntity action) {
    // This could trigger navigation or action logic
    if (state is HomeStateSuccess) {
      final successState = state as HomeStateSuccess;
      state = successState.copyWith(lastSelectedAction: action);
    }
  }

  // Reset state
  void reset() {
    state = const HomeState.initial();
  }
}
