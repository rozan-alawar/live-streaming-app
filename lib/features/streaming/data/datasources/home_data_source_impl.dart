import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streamer/features/streaming/data/datasources/home_data_source.dart';
import 'package:streamer/features/streaming/data/models/feature_model.dart';
import 'package:streamer/features/streaming/data/models/home_data_model.dart';
import 'package:streamer/features/streaming/data/models/notification_model.dart';
import 'package:streamer/features/streaming/data/models/quick_action_model.dart';
import 'package:streamer/features/streaming/data/models/stream_model.dart';
import 'package:streamer/features/streaming/data/models/user_stats_model.dart';
import 'package:streamer/features/streaming/domain/entities/notification_entity.dart';

class FirebaseHomeDataSource implements HomeRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // Collections
  static const String _streamsCollection = 'streams';
  static const String _notificationsCollection = 'notifications';
  static const String _usersCollection = 'users';
  static const String _featuresCollection = 'features';
  static const String _quickActionsCollection = 'quickActions';

  // Stream controllers for real-time updates
  final StreamController<List<StreamModel>> _liveStreamsController =
      StreamController<List<StreamModel>>.broadcast();
  final StreamController<List<NotificationModel>> _notificationsController =
      StreamController<List<NotificationModel>>.broadcast();

  StreamSubscription<QuerySnapshot>? _streamsSubscription;
  StreamSubscription<QuerySnapshot>? _notificationsSubscription;

  FirebaseHomeDataSource({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance {
    _setupRealtimeListeners();
  }

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  void _setupRealtimeListeners() {
    // Listen to live streams
    _streamsSubscription = _firestore
        .collection(_streamsCollection)
        .where('isLive', isEqualTo: true)
        .orderBy('startTime', descending: true)
        .snapshots()
        .listen((snapshot) {
          final streams =
              snapshot.docs
                  .map((doc) {
                    final data = doc.data();
                    return StreamModel.fromJson({...data, 'id': doc.id});
                  })
                  .whereType<StreamModel>()
                  .toList();
          _liveStreamsController.add(streams);
        });

    // Listen to user notifications
    if (_currentUserId.isNotEmpty) {
      _notificationsSubscription = _firestore
          .collection(_notificationsCollection)
          .where('userId', isEqualTo: _currentUserId)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .snapshots()
          .listen((snapshot) {
            final notifications =
                snapshot.docs
                    .map(
                      (doc) => NotificationModel.fromJson({
                        ...doc.data(),
                        'id': doc.id,
                      }),
                    )
                    .toList();
            _notificationsController.add(notifications);
          });
    }
  }

  @override
  Future<HomeDataModel> getHomeData() async {
    try {
      final futures = await Future.wait([
        getLiveStreams(),
        getRecommendedStreams(),
        getNotifications(),
        getQuickActions(),
        getFeatures(),
        getUserStats(),
      ]);

      return HomeDataModel(
        liveStreams: futures[0] as List<StreamModel>,
        recommendedStreams: futures[1] as List<StreamModel>,
        notifications: futures[2] as List<NotificationModel>,
        quickActions: futures[3] as List<QuickActionModel>,
        features: futures[4] as List<FeatureModel>,
        userStats: futures[5] as UserStatsModel?,
      );
    } catch (e) {
      throw Exception('Failed to get home data from Firebase: ${e.toString()}');
    }
  }

  @override
  Future<void> refreshHomeData() async {
    // Firebase automatically provides fresh data, but we can clear cache if needed
    try {
      await _firestore.clearPersistence();
    } catch (e) {
      // Ignore cache clear errors
    }
  }

  @override
  Future<List<StreamModel>> getLiveStreams() async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_streamsCollection)
              .where('isLive', isEqualTo: true)
              .orderBy('viewerCount', descending: true)
              .limit(20)
              .get();

      return querySnapshot.docs
          .map(
            (doc) => StreamModel.fromJson({
              ...(doc.data() is Map<String, dynamic> ? doc.data() : {}),
              'id': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get live streams: ${e.toString()}');
    }
  }

  @override
  Future<List<StreamModel>> getRecommendedStreams() async {
    try {
      // Get user's viewing history and preferences for recommendations
      final userDoc =
          await _firestore
              .collection(_usersCollection)
              .doc(_currentUserId)
              .get();

      List<String> preferredTags = [];
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        preferredTags = List<String>.from(userData['preferredTags'] ?? []);
      }

      Query query = _firestore
          .collection(_streamsCollection)
          .where('isLive', isEqualTo: true)
          .orderBy('startTime', descending: true);

      // If user has preferences, filter by tags
      if (preferredTags.isNotEmpty) {
        query = query.where('tags', arrayContainsAny: preferredTags);
      }

      final querySnapshot = await query.limit(10).get();

      return querySnapshot.docs
          .map(
            (doc) => StreamModel.fromJson({
              if (doc.data() != null && doc.data() is Map<String, dynamic>)
                ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      // Fallback to general streams if recommendation fails
      return getLiveStreams();
    }
  }

  @override
  Future<List<StreamModel>> searchStreams(String query) async {
    try {
      if (query.trim().isEmpty) return [];

      // Firebase doesn't support full-text search natively
      // We'll search by title and host name
      final futures = await Future.wait([
        // Search by title
        _firestore
            .collection(_streamsCollection)
            .where('title', isGreaterThanOrEqualTo: query)
            .where('title', isLessThan: '$query\uf8ff')
            .get(),
        // Search by host name
        _firestore
            .collection(_streamsCollection)
            .where('hostName', isGreaterThanOrEqualTo: query)
            .where('hostName', isLessThan: '$query\uf8ff')
            .get(),
      ]);

      final allDocs = <QueryDocumentSnapshot>[];
      for (final snapshot in futures) {
        allDocs.addAll(snapshot.docs);
      }

      // Remove duplicates and convert to models
      final uniqueDocs = allDocs.toSet().toList();
      return uniqueDocs
          .map(
            (doc) => StreamModel.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to search streams: ${e.toString()}');
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      if (_currentUserId.isEmpty) return [];

      final querySnapshot =
          await _firestore
              .collection(_notificationsCollection)
              .where('userId', isEqualTo: _currentUserId)
              .orderBy('createdAt', descending: true)
              .limit(50)
              .get();

      return querySnapshot.docs
          .map(
            (doc) => NotificationModel.fromJson({...doc.data(), 'id': doc.id}),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection(_notificationsCollection)
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Failed to mark notification as read: ${e.toString()}');
    }
  }

  @override
  Future<List<QuickActionModel>> getQuickActions() async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_quickActionsCollection)
              .where('isEnabled', isEqualTo: true)
              .orderBy('order')
              .get();

      if (querySnapshot.docs.isEmpty) {
        // Return default quick actions if none configured
        return QuickActionModel.getMockData();
      }

      return querySnapshot.docs
          .map(
            (doc) => QuickActionModel.fromJson({...doc.data(), 'id': doc.id}),
          )
          .toList();
    } catch (e) {
      // Fallback to default actions
      return QuickActionModel.getMockData();
    }
  }

  @override
  Future<List<FeatureModel>> getFeatures() async {
    try {
      final querySnapshot =
          await _firestore
              .collection(_featuresCollection)
              .orderBy('order')
              .get();

      if (querySnapshot.docs.isEmpty) {
        // Return default features if none configured
        return FeatureModel.getMockData();
      }

      return querySnapshot.docs
          .map((doc) => FeatureModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      // Fallback to default features
      return FeatureModel.getMockData();
    }
  }

  @override
  Future<UserStatsModel> getUserStats() async {
    try {
      if (_currentUserId.isEmpty) return UserStatsModel.mock();

      final userStatsDoc =
          await _firestore
              .collection(_usersCollection)
              .doc(_currentUserId)
              .collection('stats')
              .doc('streaming')
              .get();

      if (!userStatsDoc.exists) {
        return UserStatsModel.mock();
      }

      return UserStatsModel.fromJson(
        userStatsDoc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      // Return mock data if fetching fails
      return UserStatsModel.mock();
    }
  }

  // Helper methods for managing streams
  Future<String> createStream({
    required String title,
    required String hostName,
    List<String> tags = const [],
  }) async {
    try {
      final streamData = {
        'title': title,
        'hostName': hostName,
        'hostId': _currentUserId,
        'hostAvatar': _auth.currentUser?.photoURL,
        'viewerCount': 0,
        'startTime': FieldValue.serverTimestamp(),
        'isLive': true,
        'tags': tags,
        'thumbnail': null,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _firestore
          .collection(_streamsCollection)
          .add(streamData);

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create stream: ${e.toString()}');
    }
  }

  Future<void> updateStreamViewerCount(String streamId, int viewerCount) async {
    try {
      await _firestore.collection(_streamsCollection).doc(streamId).update({
        'viewerCount': viewerCount,
      });
    } catch (e) {
      throw Exception('Failed to update viewer count: ${e.toString()}');
    }
  }

  Future<void> endStream(String streamId) async {
    try {
      await _firestore.collection(_streamsCollection).doc(streamId).update({
        'isLive': false,
        'endTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to end stream: ${e.toString()}');
    }
  }

  // Notification helpers
  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) async {
    try {
      await _firestore.collection(_notificationsCollection).add({
        'userId': userId,
        'title': title,
        'message': message,
        'type': type.name,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
        'data': data,
      });
    } catch (e) {
      throw Exception('Failed to create notification: ${e.toString()}');
    }
  }

  @override
  Stream<List<StreamModel>> get liveStreamsStream =>
      _liveStreamsController.stream;

  @override
  Stream<List<NotificationModel>> get notificationsStream =>
      _notificationsController.stream;

  void dispose() {
    _streamsSubscription?.cancel();
    _notificationsSubscription?.cancel();
    _liveStreamsController.close();
    _notificationsController.close();
  }
}
