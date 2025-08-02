import 'package:streamer/features/streaming/data/models/feature_model.dart';
import 'package:streamer/features/streaming/data/models/notification_model.dart';
import 'package:streamer/features/streaming/data/models/quick_action_model.dart';
import 'package:streamer/features/streaming/data/models/stream_model.dart';
import 'package:streamer/features/streaming/data/models/user_stats_model.dart';
import 'package:streamer/features/streaming/domain/entities/home_entity.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';

class HomeDataModel extends HomeDataEntity {
  const HomeDataModel({
    required super.liveStreams,
    required super.recommendedStreams,
    required super.notifications,
    required super.quickActions,
    required super.features,
    super.userStats,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      liveStreams:
          (json['liveStreams'] as List<dynamic>?)
              ?.map((e) => StreamModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recommendedStreams:
          (json['recommendedStreams'] as List<dynamic>?)
              ?.map((e) => StreamModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notifications:
          (json['notifications'] as List<dynamic>?)
              ?.map(
                (e) => NotificationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      quickActions:
          (json['quickActions'] as List<dynamic>?)
              ?.map((e) => QuickActionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      features:
          (json['features'] as List<dynamic>?)
              ?.map((e) => FeatureModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userStats:
          json['userStats'] != null
              ? UserStatsModel.fromJson(
                json['userStats'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'liveStreams':
          liveStreams.map((e) => (e as StreamModel).toJson()).toList(),
      'recommendedStreams':
          recommendedStreams.map((e) => (e as StreamModel).toJson()).toList(),
      'notifications':
          notifications.map((e) => (e as NotificationModel).toJson()).toList(),
      'quickActions':
          quickActions.map((e) => (e as QuickActionModel).toJson()).toList(),
      'features': features.map((e) => (e as FeatureModel).toJson()).toList(),
      'userStats': (userStats as UserStatsModel?)?.toJson(),
    };
  }

  factory HomeDataModel.mock() {
    return HomeDataModel(
      liveStreams: [
        StreamModel.mock(
          title: 'Gaming Session',
          hostName: 'GamerPro',
          viewerCount: 234,
        ),
        StreamModel.mock(
          title: 'Cooking Show',
          hostName: 'ChefMaster',
          viewerCount: 89,
        ),
        StreamModel.mock(
          title: 'Music Live',
          hostName: 'MusicLover',
          viewerCount: 456,
        ),
      ],
      recommendedStreams: [
        StreamModel.mock(
          title: 'Tech Talk',
          hostName: 'TechGuru',
          viewerCount: 167,
        ),
        StreamModel.mock(
          title: 'Art Stream',
          hostName: 'ArtistX',
          viewerCount: 78,
        ),
      ],
      notifications: [
        NotificationModel.mock(
          title: 'New Follower',
          message: 'John Doe started following you',
          type: NotificationType.newFollower,
        ),
        NotificationModel.mock(
          title: 'Stream Started',
          message: 'Your friend is now live!',
          type: NotificationType.streamStarted,
        ),
        NotificationModel.mock(
          title: 'System Update',
          message: 'New features available',
          type: NotificationType.systemUpdate,
        ),
      ],
      quickActions: QuickActionModel.getMockData(),
      features: FeatureModel.getMockData(),
      userStats: UserStatsModel.mock(),
    );
  }
}
