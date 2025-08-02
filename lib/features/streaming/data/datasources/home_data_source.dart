import 'dart:async';
import 'dart:math';

import 'package:streamer/features/streaming/data/models/feature_model.dart';
import 'package:streamer/features/streaming/data/models/home_data_model.dart';
import 'package:streamer/features/streaming/data/models/notification_model.dart';
import 'package:streamer/features/streaming/data/models/quick_action_model.dart';
import 'package:streamer/features/streaming/data/models/stream_model.dart';
import 'package:streamer/features/streaming/data/models/user_stats_model.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataModel> getHomeData();
  Future<void> refreshHomeData();

  Future<List<StreamModel>> getLiveStreams();
  Future<List<StreamModel>> getRecommendedStreams();
  Future<List<StreamModel>> searchStreams(String query);

  Future<List<NotificationModel>> getNotifications();
  Future<void> markNotificationAsRead(String notificationId);

  Future<List<QuickActionModel>> getQuickActions();
  Future<List<FeatureModel>> getFeatures();
  Future<UserStatsModel> getUserStats();

  Stream<List<StreamModel>> get liveStreamsStream;
  Stream<List<NotificationModel>> get notificationsStream;
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // Simulate network delay
  static const Duration _networkDelay = Duration(milliseconds: 800);

  // In-memory storage for mock data
  late List<StreamModel> _liveStreams;
  late List<StreamModel> _recommendedStreams;
  late List<NotificationModel> _notifications;
  late List<QuickActionModel> _quickActions;
  late List<FeatureModel> _features;
  late UserStatsModel _userStats;

  // Stream controllers for real-time updates
  final StreamController<List<StreamModel>> _liveStreamsController =
      StreamController<List<StreamModel>>.broadcast();
  final StreamController<List<NotificationModel>> _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();

  HomeRemoteDataSourceImpl() {
    _initializeMockData();
    _startMockUpdates();
  }

  void _initializeMockData() {
    _liveStreams = [
      StreamModel.mock(
        id: 'stream_1',
        title: '🎮 Epic Gaming Session - Fortnite Battle Royale',
        hostName: 'GamerPro_2024',
        viewerCount: 234,
      ),
      StreamModel.mock(
        id: 'stream_2',
        title: '🍳 Cooking Masterclass - Italian Pasta',
        hostName: 'ChefMaster',
        viewerCount: 89,
      ),
      StreamModel.mock(
        id: 'stream_3',
        title: '🎵 Live Music Session - Acoustic Covers',
        hostName: 'MusicLover',
        viewerCount: 456,
      ),
      StreamModel.mock(
        id: 'stream_4',
        title: '💻 Code with Me - Building Flutter App',
        hostName: 'DevCoder',
        viewerCount: 178,
      ),
      StreamModel.mock(
        id: 'stream_5',
        title: '🎨 Digital Art Creation - Portrait Drawing',
        hostName: 'ArtistX',
        viewerCount: 67,
      ),
    ];

    _recommendedStreams = [
      StreamModel.mock(
        id: 'rec_1',
        title: '🔬 Science Experiments at Home',
        hostName: 'ScienceGuy',
        viewerCount: 123,
      ),
      StreamModel.mock(
        id: 'rec_2',
        title: '💪 Morning Workout Routine',
        hostName: 'FitnessCoach',
        viewerCount: 201,
      ),
      StreamModel.mock(
        id: 'rec_3',
        title: '📚 Book Review & Discussion',
        hostName: 'BookWorm',
        viewerCount: 45,
      ),
    ];

    _notifications = [
      NotificationModel.mock(
        title: '🎉 New Follower',
        message: 'Your friend MusicLover is now live!',
        type: NotificationType.streamStarted,
      ),
      NotificationModel.mock(
        title: '🚀 System Update',
        message: 'New features available - Check them out!',
        type: NotificationType.systemUpdate,
      ),
      NotificationModel.mock(
        title: '👥 Friend Request',
        message: 'Sarah wants to be your friend',
        type: NotificationType.friendRequest,
      ),
    ];

    _quickActions = QuickActionModel.getMockData();
    _features = FeatureModel.getMockData();
    _userStats = UserStatsModel.mock();
  }

  void _startMockUpdates() {
    // Simulate real-time updates every 10 seconds
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _updateMockData();
    });
  }

  void _updateMockData() {
    final random = Random();

    // Update viewer counts for live streams
    for (int i = 0; i < _liveStreams.length; i++) {
      final oldStream = _liveStreams[i];
      final newViewerCount = oldStream.viewerCount + random.nextInt(20) - 10;
      _liveStreams[i] = StreamModel(
        id: oldStream.id,
        title: oldStream.title,
        hostName: oldStream.hostName,
        hostAvatar: oldStream.hostAvatar,
        viewerCount: newViewerCount.clamp(0, 1000),
        startTime: oldStream.startTime,
        isLive: oldStream.isLive,
        thumbnail: oldStream.thumbnail,
        tags: oldStream.tags,
      );
    }

    // Occasionally add new notifications
    if (random.nextBool() && random.nextInt(3) == 0) {
      final newNotification = NotificationModel.mock(
        title: '🔔 Live Update',
        message: 'New activity in your network',
        type: NotificationType.general,
      );
      _notifications.insert(0, newNotification);

      // Keep only latest 10 notifications
      if (_notifications.length > 10) {
        _notifications = _notifications.take(10).toList();
      }
    }

    // Emit updates to streams
    _liveStreamsController.add(_liveStreams);
    _notificationsController.add(_notifications);
  }

  @override
  Future<HomeDataModel> getHomeData() async {
    await Future.delayed(_networkDelay);

    return HomeDataModel(
      liveStreams: _liveStreams,
      recommendedStreams: _recommendedStreams,
      notifications: _notifications,
      quickActions: _quickActions,
      features: _features,
      userStats: _userStats,
    );
  }

  @override
  Future<void> refreshHomeData() async {
    await Future.delayed(_networkDelay);

    // Simulate data refresh by updating some values
    final random = Random();

    // Update user stats
    _userStats = UserStatsModel(
      totalStreams: _userStats.totalStreams + random.nextInt(2),
      totalViewers: _userStats.totalViewers + random.nextInt(50),
      followersCount: _userStats.followersCount + random.nextInt(5),
      followingCount: _userStats.followingCount,
      totalWatchTime:
          _userStats.totalWatchTime + Duration(minutes: random.nextInt(30)),
      lastStreamDate: _userStats.lastStreamDate,
    );

    // Add a new recommended stream occasionally
    if (random.nextBool()) {
      _recommendedStreams.add(
        StreamModel.mock(
          title: '🎯 Fresh Content - Just for You',
          hostName: 'NewCreator${random.nextInt(100)}',
          viewerCount: random.nextInt(200),
        ),
      );
    }
  }

  @override
  Future<List<StreamModel>> getLiveStreams() async {
    await Future.delayed(_networkDelay);
    return _liveStreams;
  }

  @override
  Future<List<StreamModel>> getRecommendedStreams() async {
    await Future.delayed(_networkDelay);
    return _recommendedStreams;
  }

  @override
  Future<List<StreamModel>> searchStreams(String query) async {
    await Future.delayed(_networkDelay);

    if (query.trim().isEmpty) return [];

    final allStreams = [..._liveStreams, ..._recommendedStreams];
    return allStreams.where((stream) {
      return stream.title.toLowerCase().contains(query.toLowerCase()) ||
          stream.hostName.toLowerCase().contains(query.toLowerCase()) ||
          stream.tags.any(
            (tag) => tag.toLowerCase().contains(query.toLowerCase()),
          );
    }).toList();
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(_networkDelay);
    return _notifications;
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      final notification = _notifications[index];
      _notifications[index] = NotificationModel(
        id: notification.id,
        title: notification.title,
        message: notification.message,
        type: notification.type,
        createdAt: notification.createdAt,
        isRead: true,
        data: notification.data,
      );

      _notificationsController.add(_notifications);
    }
  }

  @override
  Future<List<QuickActionModel>> getQuickActions() async {
    await Future.delayed(_networkDelay);
    return _quickActions;
  }

  @override
  Future<List<FeatureModel>> getFeatures() async {
    await Future.delayed(_networkDelay);
    return _features;
  }

  @override
  Future<UserStatsModel> getUserStats() async {
    await Future.delayed(_networkDelay);
    return _userStats;
  }

  @override
  Stream<List<StreamModel>> get liveStreamsStream =>
      _liveStreamsController.stream;

  @override
  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsController.stream;

  void dispose() {
    _liveStreamsController.close();
    _notificationsController.close();
  }
}
