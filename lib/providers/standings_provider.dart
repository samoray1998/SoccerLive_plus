import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/standing.dart';
import '../services/dummy_data_service.dart';

class StandingsProvider with ChangeNotifier {
  Map<int, List<Standing>> _standings = {};
  bool _isLoading = false;
  String? _errorMessage;

  /// Get all standings
  Map<int, List<Standing>> get allStandings => _standings;

  /// Get standings for a specific competition
  List<Standing> getStandingsByCompetitionId(int competitionId) {
    return _standings[competitionId] ?? [];
  }

  /// Check if provider is loading data
  bool get isLoading => _isLoading;

  /// Get error message if any
  String? get errorMessage => _errorMessage;

  /// Load standings for a specific competition
  Future<void> loadStandings(int competitionId) async {
    // Skip if standings are already loaded
    if (_standings.containsKey(competitionId) && _standings[competitionId]!.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // In a real app, this would make an API call
      // For now, we'll use dummy data
      final standings = DummyDataService.getStandingsForCompetition(competitionId);
      
      _standings[competitionId] = standings;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load standings: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Refresh standings for a specific competition
  Future<void> refreshStandings(int competitionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // In a real app, this would make an API call
      // For now, we'll use dummy data
      final standings = DummyDataService.getStandingsForCompetition(competitionId);
      
      _standings[competitionId] = standings;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to refresh standings: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Clear all standings data
  void clearStandings() {
    _standings = {};
    notifyListeners();
  }
}