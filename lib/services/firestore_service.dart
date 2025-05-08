import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_preferences.dart';
import '../config/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new user document if it doesn't exist
  Future<void> createUserIfNotExists(String userId) async {
    try {
      final userDoc = _firestore.collection(AppConstants.usersCollection).doc(userId);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        // Create new user document with default preferences
        await userDoc.set({
          'created_at': FieldValue.serverTimestamp(),
          'last_login': FieldValue.serverTimestamp(),
          'device_tokens': [],
          'preferences': UserPreferences.empty().toJson(),
        });
        
        print('Created new user document for $userId');
      } else {
        // Update last login timestamp
        await userDoc.update({
          'last_login': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating/updating user: $e');
      throw Exception('Failed to initialize user data: $e');
    }
  }

  // Save device token for FCM
  Future<void> saveDeviceToken(String userId, String token) async {
    try {
      final userDoc = _firestore.collection(AppConstants.usersCollection).doc(userId);
      
      // Add token to array if it doesn't exist
      await userDoc.update({
        //'device_tokens': FieldValue.arrayUnion([token]),
      });
    } catch (e) {
      print('Error saving device token: $e');
    }
  }

  // Get user preferences
  Future<UserPreferences?> getUserPreferences(String userId) async {
    try {
      final docSnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      
      if (docSnapshot.exists && docSnapshot.data()!.containsKey('preferences')) {
        return UserPreferences.fromJson(docSnapshot.data()!['preferences']);
      }
      
      return null;
    } catch (e) {
      print('Error getting user preferences: $e');
      return null;
    }
  }

  // Save user preferences
  Future<void> saveUserPreferences(String userId, UserPreferences preferences) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'preferences': preferences.toJson(),
      });
    } catch (e) {
      print('Error saving user preferences: $e');
      throw Exception('Failed to save user preferences: $e');
    }
  }

  // Get user's match subscriptions
  Future<List<int>> getUserSubscriptions(String userId) async {
    try {
      final docSnapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc('matches')
          .get();
      
      if (docSnapshot.exists && docSnapshot.data() != null) {
        return List<int>.from(docSnapshot.data()!['matchIds'] ?? []);
      }
      
      return [];
    } catch (e) {
      print('Error getting user subscriptions: $e');
      return [];
    }
  }

  // Add match subscription
  Future<void> addMatchSubscription(String userId, int matchId) async {
    try {
      final subscriptionsDoc = _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc('matches');
      
      // Create or update the document
      await subscriptionsDoc.set({
        'matchIds': FieldValue.arrayUnion([matchId]),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding match subscription: $e');
      throw Exception('Failed to subscribe to match: $e');
    }
  }

  // Remove match subscription
  Future<void> removeMatchSubscription(String userId, int matchId) async {
    try {
      final subscriptionsDoc = _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc('matches');
      
      await subscriptionsDoc.update({
        'matchIds': FieldValue.arrayRemove([matchId]),
      });
    } catch (e) {
      print('Error removing match subscription: $e');
      throw Exception('Failed to unsubscribe from match: $e');
    }
  }

  // Add competition subscription
  Future<void> addCompetitionSubscription(String userId, int competitionId) async {
    try {
      final subscriptionsDoc = _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc('competitions');
      
      // Create or update the document
      await subscriptionsDoc.set({
        'competitionIds': FieldValue.arrayUnion([competitionId]),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding competition subscription: $e');
      throw Exception('Failed to subscribe to competition: $e');
    }
  }

  // Remove competition subscription
  Future<void> removeCompetitionSubscription(String userId, int competitionId) async {
    try {
      final subscriptionsDoc = _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc('competitions');
      
      await subscriptionsDoc.update({
        'competitionIds': FieldValue.arrayRemove([competitionId]),
      });
    } catch (e) {
      print('Error removing competition subscription: $e');
      throw Exception('Failed to unsubscribe from competition: $e');
    }
  }
}
