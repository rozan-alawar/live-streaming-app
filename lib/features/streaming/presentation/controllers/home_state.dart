import 'package:equatable/equatable.dart';
import 'package:streamer/features/streaming/domain/entities/feature_entity.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';
import 'package:streamer/features/streaming/domain/entities/quick_action_entity.dart';
import 'package:streamer/features/streaming/domain/entities/stream_entity.dart';
import 'package:streamer/features/streaming/domain/entities/user_stats_entity.dart';

import '../../domain/entities/home_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];

  // State getters
  bool get isInitial => this is HomeStateInitial;
  bool get isLoading => this is HomeStateLoading;
  bool get isSuccess => this is HomeStateSuccess;
  bool get isError => this is HomeStateError;

  // Factory constructors
  const factory HomeState.initial() = HomeStateInitial;
  const factory HomeState.loading() = HomeStateLoading;
  const factory HomeState.success(HomeDataEntity homeData) = HomeStateSuccess;
  const factory HomeState.error(String message) = HomeStateError;
}

class HomeStateInitial extends HomeState {
  const HomeStateInitial();

  @override
  String toString() => 'HomeStateInitial()';
}

class HomeStateLoading extends HomeState {
  const HomeStateLoading();

  @override
  String toString() => 'HomeStateLoading()';
}

class HomeStateSuccess extends HomeState {
  final HomeDataEntity homeData;
  final List<StreamEntity> searchResults;
  final bool isRefreshing;
  final FeatureEntity? lastSelectedFeature;
  final QuickActionEntity? lastSelectedAction;

  const HomeStateSuccess(
    this.homeData, {
    this.searchResults = const [],
    this.isRefreshing = false,
    this.lastSelectedFeature,
    this.lastSelectedAction,
  });

  @override
  List<Object?> get props => [
    homeData,
    searchResults,
    isRefreshing,
    lastSelectedFeature,
    lastSelectedAction,
  ];

  HomeStateSuccess copyWith({
    HomeDataEntity? homeData,
    List<StreamEntity>? searchResults,
    bool? isRefreshing,
    FeatureEntity? lastSelectedFeature,
    QuickActionEntity? lastSelectedAction,
  }) {
    return HomeStateSuccess(
      homeData ?? this.homeData,
      searchResults: searchResults ?? this.searchResults,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      lastSelectedFeature: lastSelectedFeature ?? this.lastSelectedFeature,
      lastSelectedAction: lastSelectedAction ?? this.lastSelectedAction,
    );
  }

  // Convenience getters
  List<StreamEntity> get liveStreams => homeData.liveStreams;
  List<StreamEntity> get recommendedStreams => homeData.recommendedStreams;
  List<NotificationEntity> get notifications => homeData.notifications;
  List<QuickActionEntity> get quickActions => homeData.quickActions;
  List<FeatureEntity> get features => homeData.features;
  UserStatsEntity? get userStats => homeData.userStats;

  int get unreadNotificationsCount => homeData.unreadNotificationsCount;
  List<StreamEntity> get popularStreams => homeData.popularStreams;

  bool get hasSearchResults => searchResults.isNotEmpty;
  bool get hasNotifications => notifications.isNotEmpty;
  bool get hasLiveStreams => liveStreams.isNotEmpty;

  @override
  String toString() =>
      'HomeStateSuccess(homeData: $homeData, searchResults: ${searchResults.length}, isRefreshing: $isRefreshing)';
}

class HomeStateError extends HomeState {
  final String message;

  const HomeStateError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'HomeStateError(message: $message)';
}
