import 'package:streamer/features/streaming/data/datasources/home_data_source.dart';
import 'package:streamer/features/streaming/domain/entities/feature_entity.dart';
import 'package:streamer/features/streaming/domain/entities/home_entity.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';
import 'package:streamer/features/streaming/domain/entities/quick_action_entity.dart';
import 'package:streamer/features/streaming/domain/entities/stream_entity.dart';
import 'package:streamer/features/streaming/domain/entities/user_stats_entity.dart';
import 'package:streamer/features/streaming/domain/repository/home_repository_interface.dart';

class HomeRepository implements HomeRepositoryInterface {
  final HomeRemoteDataSource _remoteDataSource;

  // Cache
  HomeDataEntity? _cachedHomeData;
  DateTime? _lastCacheUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  HomeRepository({required HomeRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<HomeDataEntity> getHomeData() async {
    try {
      // Return cached data if still valid
      if (_isCacheValid()) {
        return _cachedHomeData!;
      }

      final homeData = await _remoteDataSource.getHomeData();
      _updateCache(homeData);
      return homeData;
    } catch (e) {
      // Return cached data if available, otherwise rethrow
      if (_cachedHomeData != null) {
        return _cachedHomeData!;
      }
      rethrow;
    }
  }

  @override
  Future<void> refreshHomeData() async {
    try {
      await _remoteDataSource.refreshHomeData();
      _clearCache();
    } catch (e) {
      throw Exception('Failed to refresh home data: ${e.toString()}');
    }
  }

  @override
  Future<List<StreamEntity>> getLiveStreams() async {
    try {
      return await _remoteDataSource.getLiveStreams();
    } catch (e) {
      throw Exception('Failed to get live streams: ${e.toString()}');
    }
  }

  @override
  Future<List<StreamEntity>> getRecommendedStreams() async {
    try {
      return await _remoteDataSource.getRecommendedStreams();
    } catch (e) {
      throw Exception('Failed to get recommended streams: ${e.toString()}');
    }
  }

  @override
  Future<List<StreamEntity>> getPopularStreams() async {
    try {
      final liveStreams = await _remoteDataSource.getLiveStreams();
      return liveStreams.where((stream) => stream.viewerCount > 100).toList()
        ..sort((a, b) => b.viewerCount.compareTo(a.viewerCount));
    } catch (e) {
      throw Exception('Failed to get popular streams: ${e.toString()}');
    }
  }

  @override
  Future<StreamEntity?> getStreamById(String streamId) async {
    try {
      final liveStreams = await _remoteDataSource.getLiveStreams();
      final recommendedStreams =
          await _remoteDataSource.getRecommendedStreams();

      final allStreams = [...liveStreams, ...recommendedStreams];
      return allStreams.where((stream) => stream.id == streamId).firstOrNull;
    } catch (e) {
      throw Exception('Failed to get stream by id: ${e.toString()}');
    }
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      return await _remoteDataSource.getNotifications();
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }

  @override
  Future<int> getUnreadNotificationsCount() async {
    try {
      final notifications = await _remoteDataSource.getNotifications();
      return notifications.where((n) => !n.isRead).length;
    } catch (e) {
      throw Exception(
        'Failed to get unread notifications count: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _remoteDataSource.markNotificationAsRead(notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    try {
      final notifications = await _remoteDataSource.getNotifications();
      for (final notification in notifications.where((n) => !n.isRead)) {
        await _remoteDataSource.markNotificationAsRead(notification.id);
      }
    } catch (e) {
      throw Exception(
        'Failed to mark all notifications as read: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    // TODO: Implement delete notification in remote data source
    throw UnimplementedError('Delete notification not implemented yet');
  }

  @override
  Future<List<QuickActionEntity>> getQuickActions() async {
    try {
      return await _remoteDataSource.getQuickActions();
    } catch (e) {
      throw Exception('Failed to get quick actions: ${e.toString()}');
    }
  }

  @override
  Future<void> updateQuickActionOrder(List<String> actionIds) async {
    // TODO: Implement update quick action order
    throw UnimplementedError('Update quick action order not implemented yet');
  }

  @override
  Future<List<FeatureEntity>> getFeatures() async {
    try {
      return await _remoteDataSource.getFeatures();
    } catch (e) {
      throw Exception('Failed to get features: ${e.toString()}');
    }
  }

  @override
  Future<List<FeatureEntity>> getAvailableFeatures() async {
    try {
      final features = await _remoteDataSource.getFeatures();
      return features.where((f) => f.isAvailable).toList();
    } catch (e) {
      throw Exception('Failed to get available features: ${e.toString()}');
    }
  }

  @override
  Future<List<FeatureEntity>> getNewFeatures() async {
    try {
      final features = await _remoteDataSource.getFeatures();
      return features.where((f) => f.isNew).toList();
    } catch (e) {
      throw Exception('Failed to get new features: ${e.toString()}');
    }
  }

  @override
  Future<UserStatsEntity> getUserStats() async {
    try {
      return await _remoteDataSource.getUserStats();
    } catch (e) {
      throw Exception('Failed to get user stats: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserStats() async {
    // TODO: Implement update user stats
    throw UnimplementedError('Update user stats not implemented yet');
  }

  @override
  Future<List<StreamEntity>> searchStreams(String query) async {
    try {
      return await _remoteDataSource.searchStreams(query);
    } catch (e) {
      throw Exception('Failed to search streams: ${e.toString()}');
    }
  }

  @override
  Future<List<StreamEntity>> getStreamsByCategory(String category) async {
    try {
      final liveStreams = await _remoteDataSource.getLiveStreams();
      return liveStreams
          .where((stream) => stream.tags.contains(category.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get streams by category: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserPreferences() async {
    // TODO: Implement get user preferences
    return {
      'theme': 'light',
      'notifications': true,
      'autoPlay': false,
      'quality': 'high',
    };
  }

  @override
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    // TODO: Implement update user preferences
    throw UnimplementedError('Update user preferences not implemented yet');
  }

  @override
  Future<void> clearCache() async {
    _clearCache();
  }

  @override
  Future<DateTime?> getLastCacheUpdate() async {
    return _lastCacheUpdate;
  }

  @override
  Stream<List<StreamEntity>> get liveStreamsStream => _remoteDataSource
      .liveStreamsStream
      .map((streams) => streams.cast<StreamEntity>());

  @override
  Stream<List<NotificationEntity>> get notificationsStream => _remoteDataSource
      .notificationsStream
      .map((notifications) => notifications.cast<NotificationEntity>());

  @override
  Stream<int> get unreadNotificationsCountStream => _remoteDataSource
      .notificationsStream
      .map((notifications) => notifications.where((n) => !n.isRead).length);

  // Private helper methods
  bool _isCacheValid() {
    if (_cachedHomeData == null || _lastCacheUpdate == null) return false;
    return DateTime.now().difference(_lastCacheUpdate!) < _cacheValidDuration;
  }

  void _updateCache(HomeDataEntity data) {
    _cachedHomeData = data;
    _lastCacheUpdate = DateTime.now();
  }

  void _clearCache() {
    _cachedHomeData = null;
    _lastCacheUpdate = null;
  }
}
