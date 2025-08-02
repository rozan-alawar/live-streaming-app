import 'package:equatable/equatable.dart';

class FeatureEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconData;
  final String colorHex;
  final String route;
  final bool isAvailable;
  final bool isNew;

  const FeatureEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconData,
    required this.colorHex,
    required this.route,
    this.isAvailable = true,
    this.isNew = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconData,
    colorHex,
    route,
    isAvailable,
    isNew,
  ];
}
