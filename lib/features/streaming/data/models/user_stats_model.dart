import 'package:streamer/features/streaming/domain/entities/user_stats_entity.dart';

class UserStatsModel extends UserStatsEntity {
  const UserStatsModel({
    required super.totalStreams,
    required super.totalViewers,
    required super.followersCount,
    required super.followingCount,
    required super.totalWatchTime,
    required super.lastStreamDate,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalStreams: json['totalStreams'] ?? 0,
      totalViewers: json['totalViewers'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      totalWatchTime: Duration(seconds: json['totalWatchTimeSeconds'] ?? 0),
      lastStreamDate: DateTime.fromMillisecondsSinceEpoch(
        json['lastStreamDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalStreams': totalStreams,
      'totalViewers': totalViewers,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'totalWatchTimeSeconds': totalWatchTime.inSeconds,
      'lastStreamDate': lastStreamDate.millisecondsSinceEpoch,
    };
  }

  factory UserStatsModel.mock() {
    return UserStatsModel(
      totalStreams: 12,
      totalViewers: 1450,
      followersCount: 89,
      followingCount: 156,
      totalWatchTime: const Duration(hours: 45, minutes: 30),
      lastStreamDate: DateTime.now().subtract(const Duration(days: 2)),
    );
  }
}
