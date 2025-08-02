import 'package:streamer/features/streaming/domain/entities/feature_entity.dart';

class FeatureModel extends FeatureEntity {
  const FeatureModel({
    required super.id,
    required super.title,
    required super.description,
    required super.iconData,
    required super.colorHex,
    required super.route,
    super.isAvailable,
    super.isNew,
  });

  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    return FeatureModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      iconData: json['iconData'] ?? 'Icons.widgets',
      colorHex: json['colorHex'] ?? '#6C5CE7',
      route: json['route'] ?? '/',
      isAvailable: json['isAvailable'] ?? true,
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconData': iconData,
      'colorHex': colorHex,
      'route': route,
      'isAvailable': isAvailable,
      'isNew': isNew,
    };
  }

  static List<FeatureModel> getMockData() {
    return [
      const FeatureModel(
        id: 'live_streaming',
        title: 'Live Streaming',
        description: 'Start your own live stream',
        iconData: 'Icons.videocam',
        colorHex: '#6C5CE7',
        route: '/live-stream',
        isAvailable: true,
      ),
      const FeatureModel(
        id: 'watch_live',
        title: 'Watch Live',
        description: 'Join live streams',
        iconData: 'Icons.tv',
        colorHex: '#00B894',
        route: '/watch-live',
        isAvailable: true,
      ),
      const FeatureModel(
        id: 'friends',
        title: 'Friends',
        description: 'Connect with friends',
        iconData: 'Icons.people',
        colorHex: '#17A2B8',
        route: '/friends',
        isAvailable: false,
      ),
      const FeatureModel(
        id: 'settings',
        title: 'Settings',
        description: 'Customize your experience',
        iconData: 'Icons.settings',
        colorHex: '#FFC107',
        route: '/settings',
        isAvailable: true,
      ),
    ];
  }
}
