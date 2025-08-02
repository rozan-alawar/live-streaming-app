import 'package:equatable/equatable.dart';

class QuickActionEntity extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String iconData;
  final String route;
  final bool isEnabled;
  final Map<String, dynamic>? params;

  const QuickActionEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.route,
    this.isEnabled = true,
    this.params,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    iconData,
    route,
    isEnabled,
    params,
  ];
}
