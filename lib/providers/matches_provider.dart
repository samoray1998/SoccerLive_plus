import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/match.dart';
import '../services/dummy_data_service.dart';

class MatchesProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedDate;
  final Map<String, List<SoccerMatch>> _cachedMatches = {};
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedDate => _selectedDate;
  
  List<SoccerMatch> get allMatches {
    List<SoccerMatch> allMatches = [];
    _cachedMatches.values.forEach((matchesList) {
      allMatches.addAll(matchesList);
    });
    return allMatches;
  }
  
  List<SoccerMatch> get matches {
    if (_selectedDate == null) return [];
    return _cachedMatches[_selectedDate] ?? [];
  }
  
  List<SoccerMatch> get selectedDateMatches => matches;
  
  List<SoccerMatch> get liveMatches {
    if (_selectedDate == null) return [];
    return matches.where((match) => match.isLive).toList();
  }
  
  // Method to set the selected date and load matches for that date
  Future<void> setSelectedDate(String date) async {
    _selectedDate = date;
    notifyListeners();
    await refreshMatches();
  }
  
  // Method to refresh matches for the selected date
  Future<void> refreshMatches() async {
    if (_selectedDate == null) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final todayFormatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final isToday = _selectedDate == todayFormatted;
      
      // Get matches from dummy data service
      final matches = DummyDataService.getSampleMatches(includeToday: isToday);
      
      // Filter to only include matches for the selected date
      final filteredMatches = matches.where((match) => match.date == _selectedDate).toList();
      
      // Cache the results
      _cachedMatches[_selectedDate!] = filteredMatches;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  // Get details for a specific match by ID
  SoccerMatch? getMatchById(int matchId) {
    for (final matches in _cachedMatches.values) {
      for (final match in matches) {
        if (match.id == matchId) {
          return match;
        }
      }
    }
    return null;
  }
  
  // Initialize with today's matches
  void initializeWithToday() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    setSelectedDate(today);
  }
}