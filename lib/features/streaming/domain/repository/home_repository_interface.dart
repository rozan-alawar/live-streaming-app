import 'package:streamer/features/streaming/domain/entities/feature_entity.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';
import 'package:streamer/features/streaming/domain/entities/quick_action_entity.dart';
import 'package:streamer/features/streaming/domain/entities/stream_entity.dart';
import 'package:streamer/features/streaming/domain/entities/user_stats_entity.dart';

import '../entities/home_entity.dart';

abstract class HomeRepositoryInterface {
  // Home Data
  Future<HomeDataEntity> getHomeData();
  Future<void> refreshHomeData();

  // Streams
  Future<List<StreamEntity>> getLiveStreams();
  Future<List<StreamEntity>> getRecommendedStreams();
  Future<List<StreamEntity>> getPopularStreams();
  Future<StreamEntity?> getStreamById(String streamId);

  // Notifications
  Future<List<NotificationEntity>> getNotifications();
  Future<int> getUnreadNotificationsCount();
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> markAllNotificationsAsRead();
  Future<void> deleteNotification(String notificationId);

  // Quick Actions
  Future<List<QuickActionEntity>> getQuickActions();
  Future<void> updateQuickActionOrder(List<String> actionIds);

  // Features
  Future<List<FeatureEntity>> getFeatures();
  Future<List<FeatureEntity>> getAvailableFeatures();
  Future<List<FeatureEntity>> getNewFeatures();

  // User Stats
  Future<UserStatsEntity> getUserStats();
  Future<void> updateUserStats();

  // Search & Discovery
  Future<List<StreamEntity>> searchStreams(String query);
  Future<List<StreamEntity>> getStreamsByCategory(String category);

  // User Preferences
  Future<Map<String, dynamic>> getUserPreferences();
  Future<void> updateUserPreferences(Map<String, dynamic> preferences);

  // Cache Management
  Future<void> clearCache();
  Future<DateTime?> getLastCacheUpdate();

  // Real-time Updates
  Stream<List<StreamEntity>> get liveStreamsStream;
  Stream<List<NotificationEntity>> get notificationsStream;
  Stream<int> get unreadNotificationsCountStream;
}
