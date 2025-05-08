import 'package:flutter/foundation.dart';

import '../models/competition.dart';
import '../services/dummy_data_service.dart';

class CompetitionsProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isFavoriteFilterEnabled = false;
  String? _searchQuery;
  String? _errorMessage;
  final List<Competition> _competitions = [];
  final Set<int> _favoriteCompetitionIds = {};
  
  bool get isLoading => _isLoading;
  bool get isFavoriteFilterEnabled => _isFavoriteFilterEnabled;
  String? get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  List<Competition> get competitions => _filteredCompetitions();
  List<Competition> get favoriteCompetitions => _competitions
      .where((c) => _favoriteCompetitionIds.contains(c.id))
      .toList();

  get popularCompetitions => null;

  get allCompetitions => null;
  
  List<Competition> _filteredCompetitions() {
    var filteredList = _competitions;
    
    if (_isFavoriteFilterEnabled) {
      filteredList = filteredList
          .where((c) => _favoriteCompetitionIds.contains(c.id))
          .toList();
    }
    
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      final query = _searchQuery!.toLowerCase();
      filteredList = filteredList
          .where((c) => 
              c.name.toLowerCase().contains(query) || 
              c.country.toLowerCase().contains(query))
          .toList();
    }
    
    return filteredList;
  }
  
  Future<void> loadCompetitions() async {
    if (_competitions.isNotEmpty) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Get competitions from dummy data service
      final competitions = DummyDataService.getSampleCompetitions();
      
      _competitions.clear();
      _competitions.addAll(competitions);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
  
  void setSearchQuery(String? query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void toggleFavoriteFilter(bool enabled) {
    _isFavoriteFilterEnabled = enabled;
    notifyListeners();
  }
  
  void toggleFavoriteCompetition(int competitionId) {
    if (_favoriteCompetitionIds.contains(competitionId)) {
      _favoriteCompetitionIds.remove(competitionId);
    } else {
      _favoriteCompetitionIds.add(competitionId);
    }
    notifyListeners();
  }
  
  bool isFavoriteCompetition(int competitionId) {
    return _favoriteCompetitionIds.contains(competitionId);
  }
  
  Competition? getCompetitionById(int competitionId) {
    try {
      return _competitions.firstWhere((c) => c.id == competitionId);
    } catch (e) {
      return null;
    }
  }

  searchCompetitions(String text) {}
}