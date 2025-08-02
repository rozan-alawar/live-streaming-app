import 'package:equatable/equatable.dart';

class StreamEntity extends Equatable {
  final String id;
  final String title;
  final String hostName;
  final String? hostAvatar;
  final int viewerCount;
  final DateTime startTime;
  final bool isLive;
  final String? thumbnail;
  final List<String> tags;

  const StreamEntity({
    required this.id,
    required this.title,
    required this.hostName,
    this.hostAvatar,
    required this.viewerCount,
    required this.startTime,
    required this.isLive,
    this.thumbnail,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    hostName,
    hostAvatar,
    viewerCount,
    startTime,
    isLive,
    thumbnail,
    tags,
  ];
}
