import 'package:streamer/features/streaming/domain/entities/feature_entity.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';
import 'package:streamer/features/streaming/domain/entities/quick_action_entity.dart';
import 'package:streamer/features/streaming/domain/entities/stream_entity.dart';
import 'package:streamer/features/streaming/domain/entities/user_stats_entity.dart';
import 'package:streamer/features/streaming/domain/repository/home_repository_interface.dart';

import '../entities/home_entity.dart';

// Get Home Data Use Case
class GetHomeDataUseCase {
  final HomeRepositoryInterface _repository;

  GetHomeDataUseCase(this._repository);

  Future<HomeDataEntity> call() async {
    try {
      return await _repository.getHomeData();
    } catch (e) {
      throw Exception('Failed to get home data: ${e.toString()}');
    }
  }
}

// Refresh Home Data Use Case
class RefreshHomeDataUseCase {
  final HomeRepositoryInterface _repository;

  RefreshHomeDataUseCase(this._repository);

  Future<void> call() async {
    try {
      await _repository.refreshHomeData();
    } catch (e) {
      throw Exception('Failed to refresh home data: ${e.toString()}');
    }
  }
}

// Get Live Streams Use Case
class GetLiveStreamsUseCase {
  final HomeRepositoryInterface _repository;

  GetLiveStreamsUseCase(this._repository);

  Future<List<StreamEntity>> call() async {
    try {
      return await _repository.getLiveStreams();
    } catch (e) {
      throw Exception('Failed to get live streams: ${e.toString()}');
    }
  }
}

// Get Notifications Use Case
class GetNotificationsUseCase {
  final HomeRepositoryInterface _repository;

  GetNotificationsUseCase(this._repository);

  Future<List<NotificationEntity>> call() async {
    try {
      return await _repository.getNotifications();
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }
}

// Mark Notification as Read Use Case
class MarkNotificationAsReadUseCase {
  final HomeRepositoryInterface _repository;

  MarkNotificationAsReadUseCase(this._repository);

  Future<void> call(String notificationId) async {
    try {
      await _repository.markNotificationAsRead(notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }
}

// Get User Stats Use Case
class GetUserStatsUseCase {
  final HomeRepositoryInterface _repository;

  GetUserStatsUseCase(this._repository);

  Future<UserStatsEntity> call() async {
    try {
      return await _repository.getUserStats();
    } catch (e) {
      throw Exception('Failed to get user stats: ${e.toString()}');
    }
  }
}

// Search Streams Use Case
class SearchStreamsUseCase {
  final HomeRepositoryInterface _repository;

  SearchStreamsUseCase(this._repository);

  Future<List<StreamEntity>> call(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }
      return await _repository.searchStreams(query);
    } catch (e) {
      throw Exception('Failed to search streams: ${e.toString()}');
    }
  }
}

// Get Quick Actions Use Case
class GetQuickActionsUseCase {
  final HomeRepositoryInterface _repository;

  GetQuickActionsUseCase(this._repository);

  Future<List<QuickActionEntity>> call() async {
    try {
      return await _repository.getQuickActions();
    } catch (e) {
      throw Exception('Failed to get quick actions: ${e.toString()}');
    }
  }
}

// Get Features Use Case
class GetFeaturesUseCase {
  final HomeRepositoryInterface _repository;

  GetFeaturesUseCase(this._repository);

  Future<List<FeatureEntity>> call() async {
    try {
      return await _repository.getFeatures();
    } catch (e) {
      throw Exception('Failed to get features: ${e.toString()}');
    }
  }
}

// Update User Preferences Use Case
class UpdateUserPreferencesUseCase {
  final HomeRepositoryInterface _repository;

  UpdateUserPreferencesUseCase(this._repository);

  Future<void> call(Map<String, dynamic> preferences) async {
    try {
      await _repository.updateUserPreferences(preferences);
    } catch (e) {
      throw Exception('Failed to update user preferences: ${e.toString()}');
    }
  }
}
