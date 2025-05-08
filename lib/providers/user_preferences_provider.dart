import 'package:flutter/foundation.dart';
import '../models/user_preferences.dart';
import '../services/firestore_service.dart';
import '../services/cache_service.dart';

class UserPreferencesProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  final CacheService _cacheService;
  
  UserPreferences? _userPreferences;
  bool _isLoading = false;
  String? _errorMessage;
  
  UserPreferencesProvider(this._firestoreService, this._cacheService);

  UserPreferences? get userPreferences => _userPreferences;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUserPreferences(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Try to get preferences from cache first
      final cachedPreferences = await _cacheService.getUserPreferences();
      
      if (cachedPreferences != null) {
        _userPreferences = cachedPreferences;
        notifyListeners();
      }

      // Always fetch from Firestore to get the latest
      final preferences = await _firestoreService.getUserPreferences(userId);
      
      if (preferences != null) {
        _userPreferences = preferences;
        
        // Save to cache
        await _cacheService.saveUserPreferences(preferences);
      } else if (_userPreferences == null) {
        // If no preferences found in Firestore and cache, create default
        _userPreferences = UserPreferences.empty();
        await saveUserPreferences(userId, _userPreferences!);
      }
    } catch (e) {
      _errorMessage = 'Failed to load user preferences: ${e.toString()}';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserPreferences(String userId, UserPreferences preferences) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Save to Firestore
      await _firestoreService.saveUserPreferences(userId, preferences);
      
      // Update local state
      _userPreferences = preferences;
      
      // Save to cache
      await _cacheService.saveUserPreferences(preferences);
    } catch (e) {
      _errorMessage = 'Failed to save user preferences: ${e.toString()}';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavoriteCompetition(String userId, int competitionId) async {
    try {
      if (_userPreferences == null) {
        await loadUserPreferences(userId);
      }

      if (_userPreferences != null && !_userPreferences!.favoriteCompetitions.contains(competitionId)) {
        final updatedFavorites = List<int>.from(_userPreferences!.favoriteCompetitions)..add(competitionId);
        
        final updatedPreferences = _userPreferences!.copyWith(
          favoriteCompetitions: updatedFavorites,
        );

        await saveUserPreferences(userId, updatedPreferences);
      }
    } catch (e) {
      _errorMessage = 'Failed to add favorite competition: ${e.toString()}';
      print(_errorMessage);
    }
  }

  Future<void> removeFavoriteCompetition(String userId, int competitionId) async {
    try {
      if (_userPreferences == null) {
        await loadUserPreferences(userId);
      }

      if (_userPreferences != null && _userPreferences!.favoriteCompetitions.contains(competitionId)) {
        final updatedFavorites = List<int>.from(_userPreferences!.favoriteCompetitions)
          ..remove(competitionId);
        
        final updatedPreferences = _userPreferences!.copyWith(
          favoriteCompetitions: updatedFavorites,
        );

        await saveUserPreferences(userId, updatedPreferences);
      }
    } catch (e) {
      _errorMessage = 'Failed to remove favorite competition: ${e.toString()}';
      print(_errorMessage);
    }
  }

  Future<void> toggleFavoriteCompetition(String userId, int competitionId) async {
    try {
      if (_userPreferences == null) {
        await loadUserPreferences(userId);
      }

      if (_userPreferences != null) {
        if (_userPreferences!.favoriteCompetitions.contains(competitionId)) {
          await removeFavoriteCompetition(userId, competitionId);
        } else {
          await addFavoriteCompetition(userId, competitionId);
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to toggle favorite competition: ${e.toString()}';
      print(_errorMessage);
    }
  }

  Future<void> addSubscribedMatch(String userId, int matchId) async {
    try {
      if (_userPreferences == null) {
        await loadUserPreferences(userId);
      }

      if (_userPreferences != null && !_userPreferences!.subscribedMatches.contains(matchId)) {
        final updatedSubscriptions = List<int>.from(_userPreferences!.subscribedMatches)..add(matchId);
        
        final updatedPreferences = _userPreferences!.copyWith(
          subscribedMatches: updatedSubscriptions,
        );

        await saveUserPreferences(userId, updatedPreferences);
      }
    } catch (e) {
      _errorMessage = 'Failed to add subscribed match: ${e.toString()}';
      print(_errorMessage);
    }
  }

  Future<void> removeSubscribedMatch(String userId, int matchId) async {
    try {
      if (_userPreferences == null) {
        await loadUserPreferences(userId);
      }

      if (_userPreferences != null && _userPreferences!.subscribedMatches.contains(matchId)) {
        final updatedSubscriptions = List<int>.from(_userPreferences!.subscribedMatches)
          ..remove(matchId);
        
        final updatedPreferences = _userPreferences!.copyWith(
          subscribedMatches: updatedSubscriptions,
        );

        await saveUserPreferences(userId, updatedPreferences);
      }
    } catch (e) {
      _errorMessage = 'Failed to remove subscribed match: ${e.toString()}';
      print(_errorMessage);
    }
  }

  Future<void> toggleSubscribedMatch(String userId, int matchId) async {
    try {
      if (_userPreferences == null) {
        await loadUserPreferences(userId);
      }

      if (_userPreferences != null) {
        if (_userPreferences!.subscribedMatches.contains(matchId)) {
          await removeSubscribedMatch(userId, matchId);
        } else {
          await addSubscribedMatch(userId, matchId);
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to toggle subscribed match: ${e.toString()}';
      print(_errorMessage);
    }
  }

  Future<void> updateNotificationSettings(String userId, NotificationSettings settings) async {
    try {
      if (_userPreferences == null) {
        await loadUserPreferences(userId);
      }

      if (_userPreferences != null) {
        final updatedPreferences = _userPreferences!.copyWith(
          notificationSettings: settings,
        );

        await saveUserPreferences(userId, updatedPreferences);
      }
    } catch (e) {
      _errorMessage = 'Failed to update notification settings: ${e.toString()}';
      print(_errorMessage);
    }
  }

  Future<void> updateLastViewedDate(String userId, String date) async {
    try {
      if (_userPreferences == null) {
        await loadUserPreferences(userId);
      }

      if (_userPreferences != null) {
        final updatedPreferences = _userPreferences!.copyWith(
          lastViewedDate: date,
        );

        await saveUserPreferences(userId, updatedPreferences);
      }
    } catch (e) {
      _errorMessage = 'Failed to update last viewed date: ${e.toString()}';
      print(_errorMessage);
    }
  }
  // Add these methods to handle competition subscriptions
Future<void> addSubscribedCompetition(String userId, int competitionId) async {
  try {
    if (_userPreferences == null) {
      await loadUserPreferences(userId);
    }

    if (_userPreferences != null && 
        !_userPreferences!.subscribedCompetitions.contains(competitionId)) {
      final updatedSubs = List<int>.from(_userPreferences!.subscribedCompetitions)
        ..add(competitionId);
      
      final updatedPreferences = _userPreferences!.copyWith(
        subscribedCompetitions: updatedSubs,
      );

      await saveUserPreferences(userId, updatedPreferences);
    }
  } catch (e) {
    _errorMessage = 'Failed to add subscribed competition: ${e.toString()}';
    print(_errorMessage);
  }
}

Future<void> removeSubscribedCompetition(String userId, int competitionId) async {
  try {
    if (_userPreferences == null) {
      await loadUserPreferences(userId);
    }

    if (_userPreferences != null && 
        _userPreferences!.subscribedCompetitions.contains(competitionId)) {
      final updatedSubs = List<int>.from(_userPreferences!.subscribedCompetitions)
        ..remove(competitionId);
      
      final updatedPreferences = _userPreferences!.copyWith(
        subscribedCompetitions: updatedSubs,
      );

      await saveUserPreferences(userId, updatedPreferences);
    }
  } catch (e) {
    _errorMessage = 'Failed to remove subscribed competition: ${e.toString()}';
    print(_errorMessage);
  }
}

Future<void> toggleSubscribedCompetition(String userId, int competitionId) async {
  try {
    if (_userPreferences == null) {
      await loadUserPreferences(userId);
    }

    if (_userPreferences != null) {
      if (_userPreferences!.subscribedCompetitions.contains(competitionId)) {
        await removeSubscribedCompetition(userId, competitionId);
      } else {
        await addSubscribedCompetition(userId, competitionId);
      }
    }
  } catch (e) {
    _errorMessage = 'Failed to toggle subscribed competition: ${e.toString()}';
    print(_errorMessage);
  }
}

// Add this getter method
bool isCompetitionSubscribed(int competitionId) {
  return _userPreferences?.subscribedCompetitions.contains(competitionId) ?? false;
}

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
