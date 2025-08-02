import 'package:equatable/equatable.dart';

enum NotificationType {
  streamStarted,
  newFollower,
  friendRequest,
  systemUpdate,
  general,
}

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    type,
    createdAt,
    isRead,
    data,
  ];
}
