import 'package:hive/hive.dart';
import '../models/competition.dart';
import '../models/match.dart';
import '../models/user_preferences.dart';

class CacheService {
  // Competition caching
  Future<List<Competition>> getCompetitions() async {
    try {
      final box = Hive.box<Competition>('competitions');
      return box.values.toList();
    } catch (e) {
      print('Error getting competitions from cache: $e');
      return [];
    }
  }

  Future<void> saveCompetitions(List<Competition> competitions) async {
    try {
      final box = Hive.box<Competition>('competitions');
      
      // Clear existing data
      await box.clear();
      
      // Add new data
      for (var competition in competitions) {
        await box.put(competition.id, competition);
      }
    } catch (e) {
      print('Error saving competitions to cache: $e');
    }
  }

  // Match caching
  Future<List<SoccerMatch>> getMatchesByDate(String date) async {
    try {
      final box = Hive.box<SoccerMatch>('matches');
      
      // Filter matches by date
      return box.values.where((match) => match.date == date).toList();
    } catch (e) {
      print('Error getting matches from cache: $e');
      return [];
    }
  }

  Future<void> saveMatchesByDate(String date, List<SoccerMatch> matches) async {
    try {
      final box = Hive.box<SoccerMatch>('matches');
      
      // Remove old matches for this date
      final keysToRemove = box.keys.where((key) {
        final match = box.get(key);
        return match != null && match.date == date;
      }).toList();
      
      for (var key in keysToRemove) {
        await box.delete(key);
      }
      
      // Add new matches
      for (var match in matches) {
        await box.put(match.id, match);
      }
    } catch (e) {
      print('Error saving matches to cache: $e');
    }
  }

  // Clear all cache
  Future<void> clearCache() async {
    try {
      final competitionsBox = Hive.box<Competition>('competitions');
      final matchesBox = Hive.box<SoccerMatch>('matches');
      
      await competitionsBox.clear();
      await matchesBox.clear();
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  getUserPreferences() {}

  saveUserPreferences(UserPreferences preferences) {}
}
