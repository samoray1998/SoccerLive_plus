import 'package:flutter/foundation.dart';
import '../models/match.dart';
import '../services/fcm_service.dart';
import '../services/firestore_service.dart';

class NotificationsProvider with ChangeNotifier {
  final FCMService _fcmService;
  final FirestoreService _firestoreService;

  bool _isInitialized = false;
  bool _areNotificationsEnabled = false;
  List<int> _subscribedMatchIds = [];
  String? _errorMessage;

  NotificationsProvider(this._fcmService, this._firestoreService);

  bool get isInitialized => _isInitialized;
  bool get areNotificationsEnabled => _areNotificationsEnabled;
  List<int> get subscribedMatchIds => _subscribedMatchIds;
  String? get errorMessage => _errorMessage;

  Future<void> initialize(String userId) async {
    try {
      if (!_isInitialized) {
        // Initialize FCM
        final enabled = await _fcmService.requestPermission();
        _areNotificationsEnabled = enabled;

        // Get device token
        final token = await _fcmService.getToken();

        // Save token to Firestore
        if (token != null) {
          await _firestoreService.saveDeviceToken(userId, token);
        }

        // Load subscribed matches
        final subscriptions =
            await _firestoreService.getUserSubscriptions(userId);
        _subscribedMatchIds = subscriptions;

        _isInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize notifications: ${e.toString()}';
      print(_errorMessage);
    }
  }

  Future<bool> subscribeToMatch(String userId, SoccerMatch match) async {
    try {
      // Add to local list
      if (!_subscribedMatchIds.contains(match.id)) {
        _subscribedMatchIds.add(match.id);
        notifyListeners();
      }

      // Subscribe to match topic in FCM
      final matchTopic = 'match_${match.id}';
      await _fcmService.subscribeToTopic(matchTopic);

      // Save to Firestore
      await _firestoreService.addMatchSubscription(userId, match.id);

      return true;
    } catch (e) {
      _errorMessage = 'Failed to subscribe to match: ${e.toString()}';
      print(_errorMessage);

      // Roll back if failed
      if (_subscribedMatchIds.contains(match.id)) {
        _subscribedMatchIds.remove(match.id);
        notifyListeners();
      }

      return false;
    }
  }

  Future<bool> unsubscribeFromMatch(String userId, SoccerMatch match) async {
    try {
      // Remove from local list
      if (_subscribedMatchIds.contains(match.id)) {
        _subscribedMatchIds.remove(match.id);
        notifyListeners();
      }

      // Unsubscribe from match topic in FCM
      final matchTopic = 'match_${match.id}';
      await _fcmService.unsubscribeFromTopic(matchTopic);

      // Remove from Firestore
      await _firestoreService.removeMatchSubscription(userId, match.id);

      return true;
    } catch (e) {
      _errorMessage = 'Failed to unsubscribe from match: ${e.toString()}';
      print(_errorMessage);

      // Roll back if failed
      if (!_subscribedMatchIds.contains(match.id)) {
        _subscribedMatchIds.add(match.id);
        notifyListeners();
      }

      return false;
    }
  }

  Future<bool> toggleMatchSubscription(String userId, SoccerMatch match) async {
    if (_subscribedMatchIds.contains(match.id)) {
      return await unsubscribeFromMatch(userId, match);
    } else {
      return await subscribeToMatch(userId, match);
    }
  }

  Future<bool> subscribeToCompetition(String userId, int competitionId) async {
    try {
      // Subscribe to competition topic in FCM
      final competitionTopic = 'competition_$competitionId';
      await _fcmService.subscribeToTopic(competitionTopic);

      // Save to Firestore
      await _firestoreService.addCompetitionSubscription(userId, competitionId);

      return true;
    } catch (e) {
      _errorMessage = 'Failed to subscribe to competition: ${e.toString()}';
      print(_errorMessage);
      return false;
    }
  }

  Future<bool> unsubscribeFromCompetition(
      String userId, int competitionId) async {
    try {
      // Unsubscribe from competition topic in FCM
      final competitionTopic = 'competition_$competitionId';
      await _fcmService.unsubscribeFromTopic(competitionTopic);

      // Remove from Firestore
      await _firestoreService.removeCompetitionSubscription(
          userId, competitionId);

      return true;
    } catch (e) {
      _errorMessage = 'Failed to unsubscribe from competition: ${e.toString()}';
      print(_errorMessage);
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  isCompetitionSubscribed(int competitionId) {}

  void toggleCompetitionSubscription(int competitionId) {}
}
