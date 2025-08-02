import 'package:equatable/equatable.dart';

class UserStatsEntity extends Equatable {
  final int totalStreams;
  final int totalViewers;
  final int followersCount;
  final int followingCount;
  final Duration totalWatchTime;
  final DateTime lastStreamDate;

  const UserStatsEntity({
    required this.totalStreams,
    required this.totalViewers,
    required this.followersCount,
    required this.followingCount,
    required this.totalWatchTime,
    required this.lastStreamDate,
  });

  @override
  List<Object?> get props => [
    totalStreams,
    totalViewers,
    followersCount,
    followingCount,
    totalWatchTime,
    lastStreamDate,
  ];
}
