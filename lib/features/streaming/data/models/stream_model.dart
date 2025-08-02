import 'package:streamer/features/streaming/domain/entities/stream_entity.dart';

class StreamModel extends StreamEntity {
  const StreamModel({
    required super.id,
    required super.title,
    required super.hostName,
    super.hostAvatar,
    required super.viewerCount,
    required super.startTime,
    required super.isLive,
    super.thumbnail,
    super.tags,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      hostName: json['hostName'] ?? '',
      hostAvatar: json['hostAvatar'],
      viewerCount: json['viewerCount'] ?? 0,
      startTime: DateTime.fromMillisecondsSinceEpoch(
        json['startTime'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      isLive: json['isLive'] ?? false,
      thumbnail: json['thumbnail'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hostName': hostName,
      'hostAvatar': hostAvatar,
      'viewerCount': viewerCount,
      'startTime': startTime.millisecondsSinceEpoch,
      'isLive': isLive,
      'thumbnail': thumbnail,
      'tags': tags,
    };
  }

  factory StreamModel.mock({
    String? id,
    String? title,
    String? hostName,
    int? viewerCount,
  }) {
    return StreamModel(
      id: id ?? 'stream_${DateTime.now().millisecondsSinceEpoch}',
      title: title ?? 'Amazing Live Stream',
      hostName: hostName ?? 'StreamHost',
      viewerCount: viewerCount ?? 45,
      startTime: DateTime.now().subtract(const Duration(minutes: 30)),
      isLive: true,
      tags: const ['gaming', 'fun'],
    );
  }
}
