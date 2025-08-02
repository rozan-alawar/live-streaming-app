import 'package:equatable/equatable.dart';
import 'package:streamer/features/streaming/domain/entities/feature_entity.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';
import 'package:streamer/features/streaming/domain/entities/quick_action_entity.dart';
import 'package:streamer/features/streaming/domain/entities/stream_entity.dart';
import 'package:streamer/features/streaming/domain/entities/user_stats_entity.dart';

class HomeDataEntity extends Equatable {
  final List<StreamEntity> liveStreams;
  final List<StreamEntity> recommendedStreams;
  final List<NotificationEntity> notifications;
  final List<QuickActionEntity> quickActions;
  final List<FeatureEntity> features;
  final UserStatsEntity? userStats;

  const HomeDataEntity({
    required this.liveStreams,
    required this.recommendedStreams,
    required this.notifications,
    required this.quickActions,
    required this.features,
    this.userStats,
  });

  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  List<StreamEntity> get popularStreams =>
      liveStreams.where((s) => s.viewerCount > 100).toList();

  @override
  List<Object?> get props => [
    liveStreams,
    recommendedStreams,
    notifications,
    quickActions,
    features,
    userStats,
  ];
}
