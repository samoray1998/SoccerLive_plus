import 'package:flutter/material.dart';
import '../models/competition_model.dart';

class CompetitionProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  final List<Competition> _competitions = [];
  final List<Competition> _filteredCompetitions = [];
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Competition> get competitions => _competitions;
  List<Competition> get filteredCompetitions => _searchQuery.isEmpty 
      ? _competitions 
      : _filteredCompetitions;

  void setSearchQuery(String query) {
    _searchQuery = query;
    
    if (query.isEmpty) {
      notifyListeners();
      return;
    }

    _filteredCompetitions.clear();
    
    final lowercaseQuery = query.toLowerCase();
    _filteredCompetitions.addAll(
      _competitions.where((competition) => 
        competition.name.toLowerCase().contains(lowercaseQuery) ||
        competition.country.toLowerCase().contains(lowercaseQuery)
      )
    );
    
    notifyListeners();
  }

  Future<void> loadCompetitions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Clear existing data
      _competitions.clear();
      
      // Sample data
      _competitions.addAll([
        Competition(
          id: 39, 
          name: 'Premier League',
          country: 'England',
          logo: 'https://media.api-sports.io/football/leagues/39.png',
          type: 'League',
          seasonYear: 2023,
        ),
        Competition(
          id: 140, 
          name: 'La Liga',
          country: 'Spain',
          logo: 'https://media.api-sports.io/football/leagues/140.png',
          type: 'League',
          seasonYear: 2023,
        ),
        Competition(
          id: 135, 
          name: 'Serie A',
          country: 'Italy',
          logo: 'https://media.api-sports.io/football/leagues/135.png',
          type: 'League',
          seasonYear: 2023,
        ),
        Competition(
          id: 78, 
          name: 'Bundesliga',
          country: 'Germany',
          logo: 'https://media.api-sports.io/football/leagues/78.png',
          type: 'League',
          seasonYear: 2023,
        ),
        Competition(
          id: 61, 
          name: 'Ligue 1',
          country: 'France',
          logo: 'https://media.api-sports.io/football/leagues/61.png',
          type: 'League',
          seasonYear: 2023,
        ),
        Competition(
          id: 2, 
          name: 'UEFA Champions League',
          country: 'Europe',
          logo: 'https://media.api-sports.io/football/leagues/2.png',
          type: 'Cup',
          seasonYear: 2023,
        ),
        Competition(
          id: 3, 
          name: 'UEFA Europa League',
          country: 'Europe',
          logo: 'https://media.api-sports.io/football/leagues/3.png',
          type: 'Cup',
          seasonYear: 2023,
        ),
        Competition(
          id: 45, 
          name: 'FA Cup',
          country: 'England',
          logo: 'https://media.api-sports.io/football/leagues/45.png',
          type: 'Cup',
          seasonYear: 2023,
        ),
        Competition(
          id: 48, 
          name: 'Copa del Rey',
          country: 'Spain',
          logo: 'https://media.api-sports.io/football/leagues/48.png',
          type: 'Cup',
          seasonYear: 2023,
        ),
        Competition(
          id: 81, 
          name: 'DFB Pokal',
          country: 'Germany',
          logo: 'https://media.api-sports.io/football/leagues/81.png',
          type: 'Cup',
          seasonYear: 2023,
        ),
        Competition(
          id: 66, 
          name: 'Coupe de France',
          country: 'France',
          logo: 'https://media.api-sports.io/football/leagues/66.png',
          type: 'Cup',
          seasonYear: 2023,
        ),
        Competition(
          id: 137, 
          name: 'Coppa Italia',
          country: 'Italy',
          logo: 'https://media.api-sports.io/football/leagues/137.png',
          type: 'Cup',
          seasonYear: 2023,
        ),
      ]);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int competitionId) async {
    final index = _competitions.indexWhere((competition) => competition.id == competitionId);
    
    if (index != -1) {
      final competition = _competitions[index];
      final updatedCompetition = competition.copyWith(
        isFavorite: !competition.isFavorite,
      );
      
      _competitions[index] = updatedCompetition;
      
      // If we have filtered competitions, update them too
      if (_searchQuery.isNotEmpty) {
        final filteredIndex = _filteredCompetitions.indexWhere(
          (competition) => competition.id == competitionId
        );
        
        if (filteredIndex != -1) {
          _filteredCompetitions[filteredIndex] = updatedCompetition;
        }
      }
      
      notifyListeners();
      
      // TODO: In the future, update the favorite status in Firestore
      try {
        // Simulate API call to save favorite
        await Future.delayed(const Duration(milliseconds: 500));
        print('Competition ${competition.name} favorite status updated to ${updatedCompetition.isFavorite}');
      } catch (e) {
        // Revert the change on error
        _competitions[index] = competition;
        
        if (_searchQuery.isNotEmpty) {
          final filteredIndex = _filteredCompetitions.indexWhere(
            (competition) => competition.id == competitionId
          );
          
          if (filteredIndex != -1) {
            _filteredCompetitions[filteredIndex] = competition;
          }
        }
        
        notifyListeners();
        throw Exception('Failed to update favorite status: $e');
      }
    }
  }

  // Method to get Competition by ID
  Future<Competition?> getCompetitionById(int id) async {
    final index = _competitions.indexWhere((competition) => competition.id == id);
    
    if (index != -1) {
      return _competitions[index];
    }
    
    // If not found locally, try to fetch from API
    try {
      _isLoading = true;
      notifyListeners();
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _isLoading = false;
      notifyListeners();
      
      // For demo purposes, return a fake competition if ID matches expected range
      if (id >= 1 && id <= 200) {
        return Competition(
          id: id, 
          name: 'Competition $id',
          country: 'Country',
          logo: 'https://media.api-sports.io/football/leagues/$id.png',
          type: 'League',
          seasonYear: 2023,
        );
      }
      
      return null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Methods for Competition Details Screen

  Future<List<Standing>> getStandings(int competitionId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Sample data
      return [
        Standing(
          rank: 1,
          team: Team(id: 1, name: 'Arsenal', logo: 'https://media.api-sports.io/football/teams/42.png'),
          points: 84,
          goalsDiff: 56,
          form: 'WWWWD',
          stats: StandingStats(played: 36, win: 27, draw: 3, lose: 6, goalsFor: 89, goalsAgainst: 33),
        ),
        Standing(
          rank: 2,
          team: Team(id: 2, name: 'Manchester City', logo: 'https://media.api-sports.io/football/teams/50.png'),
          points: 82,
          goalsDiff: 54,
          form: 'WWWWW',
          stats: StandingStats(played: 35, win: 26, draw: 4, lose: 5, goalsFor: 87, goalsAgainst: 33),
        ),
        Standing(
          rank: 3,
          team: Team(id: 3, name: 'Liverpool', logo: 'https://media.api-sports.io/football/teams/40.png'),
          points: 75,
          goalsDiff: 43,
          form: 'WWLWW',
          stats: StandingStats(played: 36, win: 23, draw: 6, lose: 7, goalsFor: 76, goalsAgainst: 33),
        ),
        Standing(
          rank: 4,
          team: Team(id: 4, name: 'Aston Villa', logo: 'https://media.api-sports.io/football/teams/66.png'),
          points: 67,
          goalsDiff: 21,
          form: 'WLWDL',
          stats: StandingStats(played: 36, win: 20, draw: 7, lose: 9, goalsFor: 69, goalsAgainst: 48),
        ),
        Standing(
          rank: 5,
          team: Team(id: 5, name: 'Tottenham Hotspur', logo: 'https://media.api-sports.io/football/teams/47.png'),
          points: 60,
          goalsDiff: 11,
          form: 'LWWLD',
          stats: StandingStats(played: 35, win: 18, draw: 6, lose: 11, goalsFor: 67, goalsAgainst: 56),
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load standings: $e');
    }
  }

  Future<List<Match>> getMatches(int competitionId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Sample data
      return [
        Match(
          id: '101',
          homeTeam: 'Arsenal',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/42.png',
          awayTeam: 'Everton',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/45.png',
          date: '2023-05-19',
          time: '15:00',
          score: '3 - 1',
          status: 'FT',
        ),
        Match(
          id: '102',
          homeTeam: 'Manchester City',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/50.png',
          awayTeam: 'West Ham',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/48.png',
          date: '2023-05-19',
          time: '15:00',
          score: '2 - 0',
          status: 'FT',
        ),
        Match(
          id: '103',
          homeTeam: 'Liverpool',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/40.png',
          awayTeam: 'Wolves',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/39.png',
          date: '2023-05-19',
          time: '15:00',
          score: '4 - 0',
          status: 'FT',
        ),
        Match(
          id: '104',
          homeTeam: 'Chelsea',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/49.png',
          awayTeam: 'Bournemouth',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/35.png',
          date: '2023-05-19',
          time: '15:00',
          status: 'NS',
        ),
        Match(
          id: '105',
          homeTeam: 'Manchester United',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/33.png',
          awayTeam: 'Brighton',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/51.png',
          date: '2023-05-19',
          time: '15:00',
          status: 'NS',
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load matches: $e');
    }
  }

  Future<List<Team>> getTeams(int competitionId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Sample data
      return [
        Team(id: 1, name: 'Arsenal', logo: 'https://media.api-sports.io/football/teams/42.png'),
        Team(id: 2, name: 'Manchester City', logo: 'https://media.api-sports.io/football/teams/50.png'),
        Team(id: 3, name: 'Liverpool', logo: 'https://media.api-sports.io/football/teams/40.png'),
        Team(id: 4, name: 'Aston Villa', logo: 'https://media.api-sports.io/football/teams/66.png'),
        Team(id: 5, name: 'Tottenham Hotspur', logo: 'https://media.api-sports.io/football/teams/47.png'),
        Team(id: 6, name: 'Manchester United', logo: 'https://media.api-sports.io/football/teams/33.png'),
        Team(id: 7, name: 'Chelsea', logo: 'https://media.api-sports.io/football/teams/49.png'),
        Team(id: 8, name: 'Newcastle United', logo: 'https://media.api-sports.io/football/teams/34.png'),
        Team(id: 9, name: 'West Ham United', logo: 'https://media.api-sports.io/football/teams/48.png'),
        Team(id: 10, name: 'Wolverhampton Wanderers', logo: 'https://media.api-sports.io/football/teams/39.png'),
      ];
    } catch (e) {
      throw Exception('Failed to load teams: $e');
    }
  }

  Future<void> toggleTeamSubscription(int teamId) async {
    // TODO: Implement with Firebase
    await Future.delayed(const Duration(milliseconds: 500));
    print('Toggled subscription for team with ID: $teamId');
  }
  
  // Get team matches (for a specific team in a competition)
  Future<List<Match>> getTeamMatches(int teamId, int competitionId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // In a real app, we would filter matches by team ID
      // For this demo, we'll return some sample matches
      return [
        Match(
          id: '201',
          homeTeam: 'Arsenal',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/42.png',
          awayTeam: 'Manchester United',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/33.png',
          date: '2023-05-01',
          time: '20:00',
          score: '2 - 1',
          status: 'FT',
        ),
        Match(
          id: '202',
          homeTeam: 'Chelsea',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/49.png',
          awayTeam: 'Arsenal',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/42.png',
          date: '2023-05-07',
          time: '15:00',
          score: '1 - 3',
          status: 'FT',
        ),
        Match(
          id: '203',
          homeTeam: 'Arsenal',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/42.png',
          awayTeam: 'Tottenham Hotspur',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/47.png',
          date: '2023-05-14',
          time: '17:30',
          status: 'NS',
        ),
        Match(
          id: '204',
          homeTeam: 'Newcastle United',
          homeTeamLogo: 'https://media.api-sports.io/football/teams/34.png',
          awayTeam: 'Arsenal',
          awayTeamLogo: 'https://media.api-sports.io/football/teams/42.png',
          date: '2023-05-21',
          time: '15:00',
          status: 'NS',
        ),
      ];
    } catch (e) {
      throw Exception('Failed to load team matches: $e');
    }
  }
  
  // Get match details
  Future<dynamic> getMatchDetails(String matchId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Sample match details
      if (matchId == '101') {
        return {
          'id': '101',
          'homeTeam': 'Arsenal',
          'awayTeam': 'Everton',
          'homeTeamLogo': 'https://media.api-sports.io/football/teams/42.png',
          'awayTeamLogo': 'https://media.api-sports.io/football/teams/45.png',
          'homeGoals': 3,
          'awayGoals': 1,
          'date': '2023-05-19',
          'time': '15:00',
          'status': 'FT',
          'venue': 'Emirates Stadium',
          'referee': 'Michael Oliver',
          'events': [
            {
              'type': 'goal',
              'minute': 21,
              'team': 'home',
              'player': {
                'id': 1001,
                'name': 'Bukayo Saka',
                'number': 7,
                'position': 'RW',
                'nationality': 'England'
              }
            },
            {
              'type': 'goal',
              'minute': 39,
              'team': 'away',
              'player': {
                'id': 2005,
                'name': 'Abdoulaye Doucouré',
                'number': 16,
                'position': 'MF',
                'nationality': 'Mali'
              }
            },
            {
              'type': 'goal',
              'minute': 65,
              'team': 'home',
              'player': {
                'id': 1002,
                'name': 'Gabriel Martinelli',
                'number': 11,
                'position': 'LW',
                'nationality': 'Brazil'
              },
              'assistedBy': {
                'id': 1001,
                'name': 'Bukayo Saka',
                'number': 7,
                'position': 'RW',
                'nationality': 'England'
              }
            },
            {
              'type': 'card',
              'minute': 72,
              'team': 'away',
              'player': {
                'id': 2002,
                'name': 'Amadou Onana',
                'number': 8,
                'position': 'MF',
                'nationality': 'Belgium'
              },
              'detail': 'Yellow Card'
            },
            {
              'type': 'goal',
              'minute': 88,
              'team': 'home',
              'player': {
                'id': 1003,
                'name': 'Martin Ødegaard',
                'number': 8,
                'position': 'AM',
                'nationality': 'Norway'
              }
            }
          ],
          'homeStats': {
            'possession': 62,
            'shots': 18,
            'shotsOnTarget': 7,
            'corners': 8,
            'offsides': 2,
            'fouls': 9
          },
          'awayStats': {
            'possession': 38,
            'shots': 9,
            'shotsOnTarget': 3,
            'corners': 4,
            'offsides': 3,
            'fouls': 11
          },
          'homeLineup': {
            'formation': '4-3-3',
            'startingXI': [
              {
                'id': 1020,
                'name': 'Aaron Ramsdale',
                'number': 1,
                'position': 'GK',
                'nationality': 'England',
                'stats': {'saves': 2, 'conceded': 1}
              },
              {
                'id': 1021,
                'name': 'Ben White',
                'number': 4,
                'position': 'RB',
                'nationality': 'England',
                'stats': {'tackles': 3, 'interceptions': 2}
              },
              {
                'id': 1022,
                'name': 'Gabriel Magalhães',
                'number': 6,
                'position': 'CB',
                'nationality': 'Brazil',
                'stats': {'clearances': 5, 'interceptions': 3}
              },
              {
                'id': 1023,
                'name': 'William Saliba',
                'number': 12,
                'position': 'CB',
                'nationality': 'France',
                'stats': {'clearances': 4, 'interceptions': 1}
              },
              {
                'id': 1024,
                'name': 'Oleksandr Zinchenko',
                'number': 35,
                'position': 'LB',
                'nationality': 'Ukraine',
                'stats': {'tackles': 2, 'assists': 0}
              },
              {
                'id': 1025,
                'name': 'Thomas Partey',
                'number': 5,
                'position': 'CM',
                'nationality': 'Ghana',
                'stats': {'passes': 78, 'tackles': 4}
              },
              {
                'id': 1026,
                'name': 'Granit Xhaka',
                'number': 34,
                'position': 'CM',
                'nationality': 'Switzerland',
                'stats': {'passes': 85, 'shots': 2}
              },
              {
                'id': 1003,
                'name': 'Martin Ødegaard',
                'number': 8,
                'position': 'AM',
                'nationality': 'Norway',
                'stats': {'goals': 1, 'assists': 0}
              },
              {
                'id': 1001,
                'name': 'Bukayo Saka',
                'number': 7,
                'position': 'RW',
                'nationality': 'England',
                'stats': {'goals': 1, 'assists': 1}
              },
              {
                'id': 1027,
                'name': 'Gabriel Jesus',
                'number': 9,
                'position': 'ST',
                'nationality': 'Brazil',
                'stats': {'shots': 4, 'dribbles': 3}
              },
              {
                'id': 1002,
                'name': 'Gabriel Martinelli',
                'number': 11,
                'position': 'LW',
                'nationality': 'Brazil',
                'stats': {'goals': 1, 'shots': 3}
              }
            ],
            'substitutes': [
              {
                'id': 1028,
                'name': 'Kieran Tierney',
                'number': 3,
                'position': 'LB',
                'nationality': 'Scotland',
                'stats': {}
              },
              {
                'id': 1029,
                'name': 'Leandro Trossard',
                'number': 19,
                'position': 'FW',
                'nationality': 'Belgium',
                'stats': {}
              },
              {
                'id': 1030,
                'name': 'Eddie Nketiah',
                'number': 14,
                'position': 'ST',
                'nationality': 'England',
                'stats': {}
              },
              {
                'id': 1031,
                'name': 'Takehiro Tomiyasu',
                'number': 18,
                'position': 'RB',
                'nationality': 'Japan',
                'stats': {}
              },
              {
                'id': 1032,
                'name': 'Jorginho',
                'number': 20,
                'position': 'CM',
                'nationality': 'Italy',
                'stats': {}
              }
            ],
            'teamFormation': {
              'formation': '4-3-3',
              'players': [
                {'player_id': 1020, 'x': 50, 'y': 90},  // GK
                {'player_id': 1021, 'x': 20, 'y': 75},  // RB
                {'player_id': 1022, 'x': 40, 'y': 75},  // CB
                {'player_id': 1023, 'x': 60, 'y': 75},  // CB
                {'player_id': 1024, 'x': 80, 'y': 75},  // LB
                {'player_id': 1025, 'x': 30, 'y': 55},  // CM
                {'player_id': 1026, 'x': 50, 'y': 55},  // CM
                {'player_id': 1003, 'x': 70, 'y': 55},  // AM
                {'player_id': 1001, 'x': 20, 'y': 30},  // RW
                {'player_id': 1027, 'x': 50, 'y': 30},  // ST
                {'player_id': 1002, 'x': 80, 'y': 30}   // LW
              ]
            }
          },
          'awayLineup': {
            'formation': '4-5-1',
            'startingXI': [
              {
                'id': 2001,
                'name': 'Jordan Pickford',
                'number': 1,
                'position': 'GK',
                'nationality': 'England',
                'stats': {'saves': 4, 'conceded': 3}
              },
              {
                'id': 2010,
                'name': 'Seamus Coleman',
                'number': 23,
                'position': 'RB',
                'nationality': 'Ireland',
                'stats': {'tackles': 2, 'clearances': 3}
              },
              {
                'id': 2011,
                'name': 'Yerry Mina',
                'number': 13,
                'position': 'CB',
                'nationality': 'Colombia',
                'stats': {'clearances': 6, 'blocks': 2}
              },
              {
                'id': 2012,
                'name': 'James Tarkowski',
                'number': 2,
                'position': 'CB',
                'nationality': 'England',
                'stats': {'clearances': 7, 'blocks': 1}
              },
              {
                'id': 2013,
                'name': 'Vitaliy Mykolenko',
                'number': 19,
                'position': 'LB',
                'nationality': 'Ukraine',
                'stats': {'tackles': 3, 'interceptions': 2}
              },
              {
                'id': 2014,
                'name': 'Alex Iwobi',
                'number': 17,
                'position': 'RM',
                'nationality': 'Nigeria',
                'stats': {'passes': 35, 'dribbles': 2}
              },
              {
                'id': 2002,
                'name': 'Amadou Onana',
                'number': 8,
                'position': 'CM',
                'nationality': 'Belgium',
                'stats': {'tackles': 5, 'passes': 40}
              },
              {
                'id': 2003,
                'name': 'Idrissa Gana Gueye',
                'number': 27,
                'position': 'CM',
                'nationality': 'Senegal',
                'stats': {'tackles': 4, 'interceptions': 3}
              },
              {
                'id': 2005,
                'name': 'Abdoulaye Doucouré',
                'number': 16,
                'position': 'CM',
                'nationality': 'Mali',
                'stats': {'goals': 1, 'shots': 2}
              },
              {
                'id': 2015,
                'name': 'Dwight McNeil',
                'number': 7,
                'position': 'LM',
                'nationality': 'England',
                'stats': {'crosses': 4, 'dribbles': 2}
              },
              {
                'id': 2016,
                'name': 'Dominic Calvert-Lewin',
                'number': 9,
                'position': 'ST',
                'nationality': 'England',
                'stats': {'shots': 3, 'aerials won': 5}
              }
            ],
            'substitutes': [
              {
                'id': 2017,
                'name': 'Demarai Gray',
                'number': 11,
                'position': 'FW',
                'nationality': 'England',
                'stats': {}
              },
              {
                'id': 2018,
                'name': 'Neal Maupay',
                'number': 20,
                'position': 'ST',
                'nationality': 'France',
                'stats': {}
              },
              {
                'id': 2019,
                'name': 'Tom Davies',
                'number': 26,
                'position': 'CM',
                'nationality': 'England',
                'stats': {}
              },
              {
                'id': 2020,
                'name': 'Nathan Patterson',
                'number': 3,
                'position': 'RB',
                'nationality': 'Scotland',
                'stats': {}
              },
              {
                'id': 2021,
                'name': 'Mason Holgate',
                'number': 4,
                'position': 'CB',
                'nationality': 'England',
                'stats': {}
              }
            ],
            'teamFormation': {
              'formation': '4-5-1',
              'players': [
                {'player_id': 2001, 'x': 50, 'y': 90},  // GK
                {'player_id': 2010, 'x': 20, 'y': 75},  // RB
                {'player_id': 2011, 'x': 40, 'y': 75},  // CB
                {'player_id': 2012, 'x': 60, 'y': 75},  // CB
                {'player_id': 2013, 'x': 80, 'y': 75},  // LB
                {'player_id': 2014, 'x': 20, 'y': 55},  // RM
                {'player_id': 2002, 'x': 40, 'y': 55},  // CM
                {'player_id': 2003, 'x': 50, 'y': 55},  // CM
                {'player_id': 2005, 'x': 60, 'y': 55},  // CM
                {'player_id': 2015, 'x': 80, 'y': 55},  // LM
                {'player_id': 2016, 'x': 50, 'y': 30}   // ST
              ]
            }
          }
        };
      }
      return {};
    } catch (e) {
      throw Exception('Failed to load match details: $e');
    }
  }
}

class Match {
  final String id;
  final String homeTeam;
  final String homeTeamLogo;
  final String awayTeam;
  final String awayTeamLogo;
  final String date;
  final String time;
  final String? score;
  final String status;  // 'NS' = Not Started, 'FT' = Full Time, etc.

  Match({
    required this.id,
    required this.homeTeam,
    required this.homeTeamLogo,
    required this.awayTeam,
    required this.awayTeamLogo,
    required this.date,
    required this.time,
    this.score,
    required this.status,
  });
}