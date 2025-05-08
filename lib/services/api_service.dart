import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/competition.dart';
import '../models/match.dart';
import '../models/team.dart';

class ApiService {
  // For this simplified version, we'll use mock data instead of making real API calls
  
  Future<List<Competition>> getCompetitions() async {
    // Sample competitions data
    return [
      Competition(
        id: 39,
        name: 'Premier League',
        country: 'England',
        logo: 'https://media.api-sports.io/football/leagues/39.png',
        flag: 'https://media.api-sports.io/flags/gb.svg',
        currentSeason: 2023,
        isPopular: true,
      ),
      Competition(
        id: 140,
        name: 'La Liga',
        country: 'Spain',
        logo: 'https://media.api-sports.io/football/leagues/140.png',
        flag: 'https://media.api-sports.io/flags/es.svg',
        currentSeason: 2023,
        isPopular: true,
      ),
      Competition(
        id: 135,
        name: 'Serie A',
        country: 'Italy',
        logo: 'https://media.api-sports.io/football/leagues/135.png',
        flag: 'https://media.api-sports.io/flags/it.svg',
        currentSeason: 2023,
        isPopular: true,
      ),
      Competition(
        id: 78,
        name: 'Bundesliga',
        country: 'Germany',
        logo: 'https://media.api-sports.io/football/leagues/78.png',
        flag: 'https://media.api-sports.io/flags/de.svg',
        currentSeason: 2023,
        isPopular: true,
      ),
    ];
  }
  
  Future<List<SoccerMatch>> getMatchesByDate(String date) async {
    // Generate some sample matches for the given date
    return _getMockMatches(date);
  }
  
  Future<List<SoccerMatch>> getMatchesByCompetition(int competitionId, {String? date}) async {
    // Filter mock matches by competition ID
    final matches = _getMockMatches(date ?? _getCurrentDate());
    return matches.where((match) => match.competitionId == competitionId).toList();
  }
  
  Future<List<SoccerMatch>> getLiveMatches() async {
    // Return some sample live matches
    final matches = _getMockMatches(_getCurrentDate());
    
    // Mark a few matches as live
    for (var i = 0; i < matches.length; i++) {
      if (i % 3 == 0) {  // Make every third match "live"
        matches[i] = matches[i].copyWith(
          status: MatchStatus.firstHalf,
          elapsed: 25,
          homeGoals: 1,
          awayGoals: 0,
        );
      }
    }
    
    return matches.where((match) => match.isLive).toList();
  }
  
  Future<SoccerMatch?> getMatchDetails(int matchId) async {
    // Find a match by ID from mock data
    final matches = _getMockMatches(_getCurrentDate());
    return matches.firstWhere((match) => match.id == matchId, orElse: () => matches.first);
  }
  
  // Helper method to generate mock matches
  List<SoccerMatch> _getMockMatches(String date) {
    final competitions = [
      {'id': 39, 'name': 'Premier League', 'logo': 'https://media.api-sports.io/football/leagues/39.png'},
      {'id': 140, 'name': 'La Liga', 'logo': 'https://media.api-sports.io/football/leagues/140.png'},
      {'id': 135, 'name': 'Serie A', 'logo': 'https://media.api-sports.io/football/leagues/135.png'},
      {'id': 78, 'name': 'Bundesliga', 'logo': 'https://media.api-sports.io/football/leagues/78.png'},
    ];
    
    final teamsByLeague = {
      39: [
        {'id': 40, 'name': 'Liverpool', 'logo': 'https://media.api-sports.io/football/teams/40.png'},
        {'id': 33, 'name': 'Manchester United', 'logo': 'https://media.api-sports.io/football/teams/33.png'},
        {'id': 50, 'name': 'Manchester City', 'logo': 'https://media.api-sports.io/football/teams/50.png'},
        {'id': 47, 'name': 'Tottenham', 'logo': 'https://media.api-sports.io/football/teams/47.png'},
        {'id': 49, 'name': 'Chelsea', 'logo': 'https://media.api-sports.io/football/teams/49.png'},
        {'id': 42, 'name': 'Arsenal', 'logo': 'https://media.api-sports.io/football/teams/42.png'},
      ],
      140: [
        {'id': 529, 'name': 'Barcelona', 'logo': 'https://media.api-sports.io/football/teams/529.png'},
        {'id': 541, 'name': 'Real Madrid', 'logo': 'https://media.api-sports.io/football/teams/541.png'},
        {'id': 530, 'name': 'Atletico Madrid', 'logo': 'https://media.api-sports.io/football/teams/530.png'},
        {'id': 532, 'name': 'Valencia', 'logo': 'https://media.api-sports.io/football/teams/532.png'},
      ],
      135: [
        {'id': 489, 'name': 'AC Milan', 'logo': 'https://media.api-sports.io/football/teams/489.png'},
        {'id': 505, 'name': 'Inter', 'logo': 'https://media.api-sports.io/football/teams/505.png'},
        {'id': 496, 'name': 'Juventus', 'logo': 'https://media.api-sports.io/football/teams/496.png'},
        {'id': 487, 'name': 'Lazio', 'logo': 'https://media.api-sports.io/football/teams/487.png'},
      ],
      78: [
        {'id': 157, 'name': 'Bayern Munich', 'logo': 'https://media.api-sports.io/football/teams/157.png'},
        {'id': 165, 'name': 'Borussia Dortmund', 'logo': 'https://media.api-sports.io/football/teams/165.png'},
        {'id': 173, 'name': 'RB Leipzig', 'logo': 'https://media.api-sports.io/football/teams/173.png'},
        {'id': 169, 'name': 'Eintracht Frankfurt', 'logo': 'https://media.api-sports.io/football/teams/169.png'},
      ],
    };
    
    final List<SoccerMatch> matches = [];
    int matchId = 1000;
    
    for (var competition in competitions) {
      final competitionId = competition['id'] as int;
      final teams = teamsByLeague[competitionId] ?? [];
      
      // Generate 2 matches for each competition
      for (var i = 0; i < teams.length - 1; i += 2) {
        final homeTeam = teams[i];
        final awayTeam = teams[i + 1];
        
        matches.add(
          SoccerMatch(
            id: matchId++,
            date: date,
            time: '${15 + (i * 2)}:00',
            competitionId: competitionId,
            competitionName: competition['name'] as String,
            competitionLogo: competition['logo'] as String,
            homeTeam: Team(
              id: homeTeam['id'] as int,
              name: homeTeam['name'] as String,
              logo: homeTeam['logo'] as String,
            ),
            awayTeam: Team(
              id: awayTeam['id'] as int,
              name: awayTeam['name'] as String,
              logo: awayTeam['logo'] as String,
            ),
            status: MatchStatus.notStarted,
            isSubscribed: false,
          ),
        );
      }
    }
    
    return matches;
  }
  
  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
