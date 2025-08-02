import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.type,
    required super.createdAt,
    super.isRead,
    super.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        json['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      isRead: json['isRead'] ?? false,
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isRead': isRead,
      'data': data,
    };
  }

  factory NotificationModel.mock({
    String? title,
    String? message,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title ?? 'New Notification',
      message: message ?? 'You have a new notification',
      type: type ?? NotificationType.general,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    );
  }
}
