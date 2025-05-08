import '../models/match.dart';
import '../models/team.dart';
import '../models/competition.dart';
import '../models/standing.dart';

class DummyDataService {
  // Generate sample competition data
  static List<Competition> getSampleCompetitions() {
    return [
      Competition(
        id: 1,
        name: "Premier League",
        country: "England",
        logo: "https://media.api-sports.io/football/leagues/39.png",
        flag: "https://media.api-sports.io/flags/gb.svg",
        currentSeason: 2024,
        isPopular: true,
      ),
      Competition(
        id: 2,
        name: "La Liga",
        country: "Spain",
        logo: "https://media.api-sports.io/football/leagues/140.png",
        flag: "https://media.api-sports.io/flags/es.svg",
        currentSeason: 2024,
        isPopular: true,
      ),
      Competition(
        id: 3,
        name: "Bundesliga",
        country: "Germany",
        logo: "https://media.api-sports.io/football/leagues/78.png",
        flag: "https://media.api-sports.io/flags/de.svg",
        currentSeason: 2024,
        isPopular: true,
      ),
      Competition(
        id: 4,
        name: "Serie A",
        country: "Italy",
        logo: "https://media.api-sports.io/football/leagues/135.png",
        flag: "https://media.api-sports.io/flags/it.svg",
        currentSeason: 2024,
        isPopular: true,
      ),
      Competition(
        id: 5,
        name: "Saudi Pro League",
        country: "Saudi Arabia",
        logo: "https://media.api-sports.io/football/leagues/307.png",
        flag: "https://media.api-sports.io/flags/sa.svg",
        currentSeason: 2024,
        isPopular: false,
      ),
      Competition(
        id: 6,
        name: "Egyptian Premier League",
        country: "Egypt",
        logo: "https://media.api-sports.io/football/leagues/233.png",
        flag: "https://media.api-sports.io/flags/eg.svg",
        currentSeason: 2024,
        isPopular: false,
      ),
      Competition(
        id: 7,
        name: "Ligue 1",
        country: "France",
        logo: "https://media.api-sports.io/football/leagues/61.png",
        flag: "https://media.api-sports.io/flags/fr.svg",
        currentSeason: 2024,
        isPopular: true,
      ),
    ];
  }

  // Generate sample match data
  static List<SoccerMatch> getSampleMatches({bool includeToday = true}) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    
    return [
      if (includeToday) ...[
        // Today's live matches
        SoccerMatch(
          id: 1001,
          date: _formatDate(today),
          time: '15:00',
          competitionId: 1,
          competitionName: 'Premier League',
          competitionLogo: 'https://media.api-sports.io/football/leagues/39.png',
          homeTeam: Team(
            id: 40,
            name: 'Liverpool',
            logo: 'https://media.api-sports.io/football/teams/40.png',
          ),
          awayTeam: Team(
            id: 33,
            name: 'Manchester United',
            logo: 'https://media.api-sports.io/football/teams/33.png',
          ),
          status: MatchStatus.secondHalf,
          stadium: 'Anfield',
          referee: 'Michael Oliver',
          elapsed: 70,
          homeGoals: 2,
          awayGoals: 1,
        ),
        
        // Today's upcoming match
        SoccerMatch(
          id: 1002,
          date: _formatDate(today),
          time: '20:00',
          competitionId: 1,
          competitionName: 'Premier League',
          competitionLogo: 'https://media.api-sports.io/football/leagues/39.png',
          homeTeam: Team(
            id: 50,
            name: 'Manchester City',
            logo: 'https://media.api-sports.io/football/teams/50.png',
          ),
          awayTeam: Team(
            id: 47,
            name: 'Tottenham',
            logo: 'https://media.api-sports.io/football/teams/47.png',
          ),
          status: MatchStatus.notStarted,
          stadium: 'Etihad Stadium',
          referee: 'Anthony Taylor',
        ),
      ],
      
      // Yesterday's completed matches
      SoccerMatch(
        id: 1003,
        date: _formatDate(yesterday),
        time: '17:30',
        competitionId: 2,
        competitionName: 'La Liga',
        competitionLogo: 'https://media.api-sports.io/football/leagues/140.png',
        homeTeam: Team(
          id: 529,
          name: 'Barcelona',
          logo: 'https://media.api-sports.io/football/teams/529.png',
          winner: true,
        ),
        awayTeam: Team(
          id: 541,
          name: 'Real Madrid',
          logo: 'https://media.api-sports.io/football/teams/541.png',
          winner: false,
        ),
        status: MatchStatus.fullTime,
        stadium: 'Camp Nou',
        referee: 'Mateu Lahoz',
        homeGoals: 3,
        awayGoals: 1,
      ),
      
      // Tomorrow's upcoming matches
      SoccerMatch(
        id: 1004,
        date: _formatDate(tomorrow),
        time: '14:00',
        competitionId: 3,
        competitionName: 'Bundesliga',
        competitionLogo: 'https://media.api-sports.io/football/leagues/78.png',
        homeTeam: Team(
          id: 157,
          name: 'Bayern Munich',
          logo: 'https://media.api-sports.io/football/teams/157.png',
        ),
        awayTeam: Team(
          id: 165,
          name: 'Borussia Dortmund',
          logo: 'https://media.api-sports.io/football/teams/165.png',
        ),
        status: MatchStatus.notStarted,
        stadium: 'Allianz Arena',
        referee: 'Felix Brych',
      ),
      
      SoccerMatch(
        id: 1005,
        date: _formatDate(tomorrow),
        time: '19:45',
        competitionId: 4,
        competitionName: 'Serie A',
        competitionLogo: 'https://media.api-sports.io/football/leagues/135.png',
        homeTeam: Team(
          id: 496,
          name: 'Juventus',
          logo: 'https://media.api-sports.io/football/teams/496.png',
        ),
        awayTeam: Team(
          id: 487,
          name: 'Lazio',
          logo: 'https://media.api-sports.io/football/teams/487.png',
        ),
        status: MatchStatus.notStarted,
        stadium: 'Allianz Stadium',
        referee: 'Daniele Orsato',
      ),
      
      // Saudi Pro League
      SoccerMatch(
        id: 1006,
        date: _formatDate(tomorrow),
        time: '18:00',
        competitionId: 5,
        competitionName: 'Saudi Pro League',
        competitionLogo: 'https://media.api-sports.io/football/leagues/307.png',
        homeTeam: Team(
          id: 2931,
          name: 'Al Nassr',
          logo: 'https://media.api-sports.io/football/teams/2931.png',
        ),
        awayTeam: Team(
          id: 2932,
          name: 'Al Hilal',
          logo: 'https://media.api-sports.io/football/teams/2932.png',
        ),
        status: MatchStatus.notStarted,
        stadium: 'Al-Awwal Park',
        referee: 'Mohammed Al-Hoaish',
      ),
      
      // Egyptian Premier League
      SoccerMatch(
        id: 1007,
        date: _formatDate(tomorrow),
        time: '16:00',
        competitionId: 6,
        competitionName: 'Egyptian Premier League',
        competitionLogo: 'https://media.api-sports.io/football/leagues/233.png',
        homeTeam: Team(
          id: 1040,
          name: 'Al Ahly',
          logo: 'https://media.api-sports.io/football/teams/1040.png',
        ),
        awayTeam: Team(
          id: 1038,
          name: 'Zamalek',
          logo: 'https://media.api-sports.io/football/teams/1038.png',
        ),
        status: MatchStatus.notStarted,
        stadium: 'Cairo International Stadium',
        referee: 'Ibrahim Nour El-Din',
      ),
    ];
  }
  
  // Helper function to format date as yyyy-MM-dd
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  // Generate sample match details with lineups and events
  static Map<String, dynamic> getMatchDetails(int matchId) {
    // For now, return sample data for any match ID
    // In a real app, this would be specific to the match
    return {
      'summary': {
        'events': [
          {
            'type': 'goal',
            'minute': 23,
            'player': {
              'id': 101,
              'name': 'Mohamed Salah',
              'photo': null,
              'position': 'FW',
              'number': 11,
              'nationality': 'EGY',
              'stats': {}
            },
            'assistedBy': {
              'id': 102,
              'name': 'Trent Alexander-Arnold',
              'photo': null,
              'position': 'DF',
              'number': 66,
              'nationality': 'ENG',
              'stats': {}
            },
            'team': 'Liverpool'
          },
          {
            'type': 'card',
            'minute': 35,
            'player': {
              'id': 201,
              'name': 'Bruno Fernandes',
              'photo': null,
              'position': 'MF',
              'number': 8,
              'nationality': 'POR',
              'stats': {}
            },
            'detail': 'Yellow Card',
            'team': 'Manchester United'
          },
          {
            'type': 'goal',
            'minute': 45,
            'player': {
              'id': 103,
              'name': 'Virgil van Dijk',
              'photo': null,
              'position': 'DF',
              'number': 4,
              'nationality': 'NED',
              'stats': {}
            },
            'team': 'Liverpool'
          },
          {
            'type': 'goal',
            'minute': 67,
            'player': {
              'id': 202,
              'name': 'Marcus Rashford',
              'photo': null,
              'position': 'FW',
              'number': 10,
              'nationality': 'ENG',
              'stats': {}
            },
            'team': 'Manchester United'
          }
        ]
      },
      'lineups': {
        'home': {
          'team': 'Liverpool',
          'formation': '4-3-3',
          'startingXI': [
            {
              'id': 100,
              'name': 'Alisson',
              'photo': null,
              'position': 'GK',
              'number': 1,
              'nationality': 'BRA',
              'stats': {}
            },
            {
              'id': 102,
              'name': 'Trent Alexander-Arnold',
              'photo': null,
              'position': 'DF',
              'number': 66,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 103,
              'name': 'Virgil van Dijk',
              'photo': null,
              'position': 'DF',
              'number': 4,
              'nationality': 'NED',
              'stats': {}
            },
            {
              'id': 104,
              'name': 'Ibrahima Konaté',
              'photo': null,
              'position': 'DF',
              'number': 5,
              'nationality': 'FRA',
              'stats': {}
            },
            {
              'id': 105,
              'name': 'Andy Robertson',
              'photo': null,
              'position': 'DF',
              'number': 26,
              'nationality': 'SCO',
              'stats': {}
            },
            {
              'id': 106,
              'name': 'Fabinho',
              'photo': null,
              'position': 'MF',
              'number': 3,
              'nationality': 'BRA',
              'stats': {}
            },
            {
              'id': 107,
              'name': 'Thiago',
              'photo': null,
              'position': 'MF',
              'number': 6,
              'nationality': 'ESP',
              'stats': {}
            },
            {
              'id': 108,
              'name': 'Jordan Henderson',
              'photo': null,
              'position': 'MF',
              'number': 14,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 101,
              'name': 'Mohamed Salah',
              'photo': null,
              'position': 'FW',
              'number': 11,
              'nationality': 'EGY',
              'stats': {}
            },
            {
              'id': 109,
              'name': 'Roberto Firmino',
              'photo': null,
              'position': 'FW',
              'number': 9,
              'nationality': 'BRA',
              'stats': {}
            },
            {
              'id': 110,
              'name': 'Luis Díaz',
              'photo': null,
              'position': 'FW',
              'number': 23,
              'nationality': 'COL',
              'stats': {}
            }
          ],
          'substitutes': [
            {
              'id': 111,
              'name': 'Caoimhín Kelleher',
              'photo': null,
              'position': 'GK',
              'number': 62,
              'nationality': 'IRL',
              'stats': {}
            },
            {
              'id': 112,
              'name': 'Joe Gomez',
              'photo': null,
              'position': 'DF',
              'number': 12,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 113,
              'name': 'Darwin Núñez',
              'photo': null,
              'position': 'FW',
              'number': 27,
              'nationality': 'URU',
              'stats': {}
            }
          ],
          'formation_positions': [
            { 'player_id': 100, 'x': 50, 'y': 95 }, // GK
            { 'player_id': 102, 'x': 15, 'y': 75 }, // RB
            { 'player_id': 103, 'x': 35, 'y': 75 }, // CB
            { 'player_id': 104, 'x': 65, 'y': 75 }, // CB
            { 'player_id': 105, 'x': 85, 'y': 75 }, // LB
            { 'player_id': 106, 'x': 50, 'y': 55 }, // DM
            { 'player_id': 107, 'x': 35, 'y': 40 }, // CM
            { 'player_id': 108, 'x': 65, 'y': 40 }, // CM
            { 'player_id': 101, 'x': 15, 'y': 20 }, // RW
            { 'player_id': 109, 'x': 50, 'y': 20 }, // CF
            { 'player_id': 110, 'x': 85, 'y': 20 }  // LW
          ]
        },
        'away': {
          'team': 'Manchester United',
          'formation': '4-2-3-1',
          'startingXI': [
            {
              'id': 200,
              'name': 'David de Gea',
              'photo': null,
              'position': 'GK',
              'number': 1,
              'nationality': 'ESP',
              'stats': {}
            },
            {
              'id': 203,
              'name': 'Aaron Wan-Bissaka',
              'photo': null,
              'position': 'DF',
              'number': 29,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 204,
              'name': 'Raphaël Varane',
              'photo': null,
              'position': 'DF',
              'number': 19,
              'nationality': 'FRA',
              'stats': {}
            },
            {
              'id': 205,
              'name': 'Harry Maguire',
              'photo': null,
              'position': 'DF',
              'number': 5,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 206,
              'name': 'Luke Shaw',
              'photo': null,
              'position': 'DF',
              'number': 23,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 207,
              'name': 'Scott McTominay',
              'photo': null,
              'position': 'MF',
              'number': 39,
              'nationality': 'SCO',
              'stats': {}
            },
            {
              'id': 208,
              'name': 'Fred',
              'photo': null,
              'position': 'MF',
              'number': 17,
              'nationality': 'BRA',
              'stats': {}
            },
            {
              'id': 209,
              'name': 'Jadon Sancho',
              'photo': null,
              'position': 'MF',
              'number': 25,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 201,
              'name': 'Bruno Fernandes',
              'photo': null,
              'position': 'MF',
              'number': 8,
              'nationality': 'POR',
              'stats': {}
            },
            {
              'id': 202,
              'name': 'Marcus Rashford',
              'photo': null,
              'position': 'FW',
              'number': 10,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 210,
              'name': 'Cristiano Ronaldo',
              'photo': null,
              'position': 'FW',
              'number': 7,
              'nationality': 'POR',
              'stats': {}
            }
          ],
          'substitutes': [
            {
              'id': 211,
              'name': 'Tom Heaton',
              'photo': null,
              'position': 'GK',
              'number': 22,
              'nationality': 'ENG',
              'stats': {}
            },
            {
              'id': 212,
              'name': 'Victor Lindelöf',
              'photo': null,
              'position': 'DF',
              'number': 2,
              'nationality': 'SWE',
              'stats': {}
            },
            {
              'id': 213,
              'name': 'Anthony Martial',
              'photo': null,
              'position': 'FW',
              'number': 9,
              'nationality': 'FRA',
              'stats': {}
            }
          ],
          'formation_positions': [
            { 'player_id': 200, 'x': 50, 'y': 95 }, // GK
            { 'player_id': 203, 'x': 15, 'y': 75 }, // RB
            { 'player_id': 204, 'x': 35, 'y': 75 }, // CB
            { 'player_id': 205, 'x': 65, 'y': 75 }, // CB
            { 'player_id': 206, 'x': 85, 'y': 75 }, // LB
            { 'player_id': 207, 'x': 35, 'y': 55 }, // DM
            { 'player_id': 208, 'x': 65, 'y': 55 }, // DM
            { 'player_id': 209, 'x': 15, 'y': 35 }, // RM
            { 'player_id': 201, 'x': 50, 'y': 35 }, // CAM
            { 'player_id': 202, 'x': 85, 'y': 35 }, // LM
            { 'player_id': 210, 'x': 50, 'y': 15 }  // ST
          ]
        }
      },
      'statistics': {
        'home': {
          'possession': 58,
          'shots': 15,
          'shotsOnTarget': 7,
          'corners': 6,
          'offsides': 2,
          'fouls': 8
        },
        'away': {
          'possession': 42,
          'shots': 9,
          'shotsOnTarget': 4,
          'corners': 4,
          'offsides': 3,
          'fouls': 12
        }
      }
    };
  }

  // Generate sample standings data for a competition
  static List<Standing> getStandingsForCompetition(int competitionId) {
    // Premier League standings
    if (competitionId == 1) {
      return [
        Standing(
          position: 1,
          team: Team(
            id: 40,
            name: 'Liverpool',
            logo: 'https://media.api-sports.io/football/teams/40.png',
          ),
          playedGames: 10,
          won: 8,
          draw: 1,
          lost: 1,
          points: 25,
          goalsFor: 24,
          goalsAgainst: 8,
          goalDifference: 16,
          form: 'WWDWW',
        ),
        Standing(
          position: 2,
          team: Team(
            id: 50,
            name: 'Manchester City',
            logo: 'https://media.api-sports.io/football/teams/50.png',
          ),
          playedGames: 10,
          won: 8,
          draw: 0,
          lost: 2,
          points: 24,
          goalsFor: 26,
          goalsAgainst: 10,
          goalDifference: 16,
          form: 'WWLWW',
        ),
        Standing(
          position: 3,
          team: Team(
            id: 42,
            name: 'Arsenal',
            logo: 'https://media.api-sports.io/football/teams/42.png',
          ),
          playedGames: 10,
          won: 7,
          draw: 2,
          lost: 1,
          points: 23,
          goalsFor: 19,
          goalsAgainst: 9,
          goalDifference: 10,
          form: 'DWWDW',
        ),
        Standing(
          position: 4,
          team: Team(
            id: 49,
            name: 'Chelsea',
            logo: 'https://media.api-sports.io/football/teams/49.png',
          ),
          playedGames: 10,
          won: 6,
          draw: 2,
          lost: 2,
          points: 20,
          goalsFor: 20,
          goalsAgainst: 11,
          goalDifference: 9,
          form: 'WWDLW',
        ),
        Standing(
          position: 5,
          team: Team(
            id: 47,
            name: 'Tottenham',
            logo: 'https://media.api-sports.io/football/teams/47.png',
          ),
          playedGames: 10,
          won: 5,
          draw: 2,
          lost: 3,
          points: 17,
          goalsFor: 18,
          goalsAgainst: 15,
          goalDifference: 3,
          form: 'LWWLD',
        ),
        Standing(
          position: 6,
          team: Team(
            id: 33,
            name: 'Manchester United',
            logo: 'https://media.api-sports.io/football/teams/33.png',
          ),
          playedGames: 10,
          won: 5,
          draw: 1,
          lost: 4,
          points: 16,
          goalsFor: 13,
          goalsAgainst: 12,
          goalDifference: 1,
          form: 'WLWWL',
        ),
      ];
    }
    
    // La Liga standings
    if (competitionId == 2) {
      return [
        Standing(
          position: 1,
          team: Team(
            id: 541,
            name: 'Real Madrid',
            logo: 'https://media.api-sports.io/football/teams/541.png',
          ),
          playedGames: 10,
          won: 8,
          draw: 1,
          lost: 1,
          points: 25,
          goalsFor: 24,
          goalsAgainst: 7,
          goalDifference: 17,
          form: 'WWDWL',
        ),
        Standing(
          position: 2,
          team: Team(
            id: 529,
            name: 'Barcelona',
            logo: 'https://media.api-sports.io/football/teams/529.png',
          ),
          playedGames: 10,
          won: 7,
          draw: 2,
          lost: 1,
          points: 23,
          goalsFor: 27,
          goalsAgainst: 11,
          goalDifference: 16,
          form: 'DWWWW',
        ),
        Standing(
          position: 3,
          team: Team(
            id: 530,
            name: 'Atletico Madrid',
            logo: 'https://media.api-sports.io/football/teams/530.png',
          ),
          playedGames: 10,
          won: 6,
          draw: 3,
          lost: 1,
          points: 21,
          goalsFor: 18,
          goalsAgainst: 8,
          goalDifference: 10,
          form: 'WDWDW',
        ),
        Standing(
          position: 4,
          team: Team(
            id: 536,
            name: 'Sevilla',
            logo: 'https://media.api-sports.io/football/teams/536.png',
          ),
          playedGames: 10,
          won: 5,
          draw: 3,
          lost: 2,
          points: 18,
          goalsFor: 15,
          goalsAgainst: 10,
          goalDifference: 5,
          form: 'WDWLW',
        ),
        Standing(
          position: 5,
          team: Team(
            id: 548,
            name: 'Real Sociedad',
            logo: 'https://media.api-sports.io/football/teams/548.png',
          ),
          playedGames: 10,
          won: 5,
          draw: 2,
          lost: 3,
          points: 17,
          goalsFor: 14,
          goalsAgainst: 11,
          goalDifference: 3,
          form: 'LWWLD',
        ),
      ];
    }
    
    // Return empty list for other competitions
    return [];
  }
}