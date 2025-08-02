import 'package:streamer/features/streaming/domain/entities/quick_action_entity.dart';

class QuickActionModel extends QuickActionEntity {
  const QuickActionModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.iconData,
    required super.route,
    super.isEnabled,
    super.params,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      iconData: json['iconData'] ?? 'Icons.widgets',
      route: json['route'] ?? '/',
      isEnabled: json['isEnabled'] ?? true,
      params: json['params'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'iconData': iconData,
      'route': route,
      'isEnabled': isEnabled,
      'params': params,
    };
  }

  static List<QuickActionModel> getMockData() {
    return [
      const QuickActionModel(
        id: 'go_live',
        title: 'Go Live',
        subtitle: 'Start streaming now',
        iconData: 'Icons.videocam',
        route: '/live-stream',
        params: {'isHost': true},
      ),
      const QuickActionModel(
        id: 'join_live',
        title: 'Join Live',
        subtitle: 'Watch live streams',
        iconData: 'Icons.tv',
        route: '/live-stream',
        params: {'isHost': false},
      ),
    ];
  }
}
