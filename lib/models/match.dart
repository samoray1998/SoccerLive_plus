import 'package:hive/hive.dart';
import 'team.dart';

part 'match.g.dart';

@HiveType(typeId: 2)
class SoccerMatch {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String date;
  
  @HiveField(2)
  final String time;
  
  @HiveField(3)
  final int competitionId;
  
  @HiveField(4)
  final String competitionName;
  
  @HiveField(5)
  final String competitionLogo;
  
  @HiveField(6)
  final Team homeTeam;
  
  @HiveField(7)
  final Team awayTeam;
  
  @HiveField(8)
  final MatchStatus status;
  
  @HiveField(9)
  final String? stadium;
  
  @HiveField(10)
  final String? referee;
  
  @HiveField(11)
  final int? elapsed;
  
  @HiveField(12)
  final int? homeGoals;
  
  @HiveField(13)
  final int? awayGoals;
  
  @HiveField(14)
  final int? homeHalfTimeGoals;
  
  @HiveField(15)
  final int? awayHalfTimeGoals;
  
  @HiveField(16)
  final bool isSubscribed;

  SoccerMatch({
    required this.id,
    required this.date,
    required this.time,
    required this.competitionId,
    required this.competitionName,
    required this.competitionLogo,
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
    this.stadium,
    this.referee,
    this.elapsed,
    this.homeGoals,
    this.awayGoals,
    this.homeHalfTimeGoals,
    this.awayHalfTimeGoals,
    this.isSubscribed = false,
  });

  factory SoccerMatch.fromJson(Map<String, dynamic> json) {
    final fixture = json['fixture'];
    final league = json['league'];
    final teams = json['teams'];
    final goals = json['goals'];
    final score = json['score'];
    
    return SoccerMatch(
      id: fixture['id'],
      date: fixture['date'].toString().split('T')[0],
      time: fixture['date'].toString().split('T')[1].substring(0, 5),
      competitionId: league['id'],
      competitionName: league['name'],
      competitionLogo: league['logo'] ?? '',
      homeTeam: Team.fromJson(teams['home']),
      awayTeam: Team.fromJson(teams['away']),
      status: _mapStatusFromString(fixture['status']['short']),
      stadium: fixture['venue']?['name'],
      referee: fixture['referee'],
      elapsed: fixture['status']['elapsed'],
      homeGoals: goals['home'],
      awayGoals: goals['away'],
      homeHalfTimeGoals: score['halftime']?['home'],
      awayHalfTimeGoals: score['halftime']?['away'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'competitionId': competitionId,
      'competitionName': competitionName,
      'competitionLogo': competitionLogo,
      'homeTeam': homeTeam.toJson(),
      'awayTeam': awayTeam.toJson(),
      'status': status.toString().split('.').last,
      'stadium': stadium,
      'referee': referee,
      'elapsed': elapsed,
      'homeGoals': homeGoals,
      'awayGoals': awayGoals,
      'homeHalfTimeGoals': homeHalfTimeGoals,
      'awayHalfTimeGoals': awayHalfTimeGoals,
      'isSubscribed': isSubscribed,
    };
  }

  static MatchStatus _mapStatusFromString(String status) {
    switch (status) {
      case 'TBD':
        return MatchStatus.toBeDefined;
      case 'NS':
        return MatchStatus.notStarted;
      case '1H':
        return MatchStatus.firstHalf;
      case 'HT':
        return MatchStatus.halfTime;
      case '2H':
        return MatchStatus.secondHalf;
      case 'ET':
        return MatchStatus.extraTime;
      case 'P':
        return MatchStatus.penalty;
      case 'FT':
        return MatchStatus.fullTime;
      case 'AET':
        return MatchStatus.afterExtraTime;
      case 'PEN':
        return MatchStatus.penalty;
      case 'BT':
        return MatchStatus.breakTime;
      case 'SUSP':
        return MatchStatus.suspended;
      case 'INT':
        return MatchStatus.interrupted;
      case 'PST':
        return MatchStatus.postponed;
      case 'CANC':
        return MatchStatus.cancelled;
      case 'ABD':
        return MatchStatus.abandoned;
      case 'AWD':
        return MatchStatus.awarded;
      case 'WO':
        return MatchStatus.walkover;
      default:
        return MatchStatus.unknown;
    }
  }

  SoccerMatch copyWith({
    int? id,
    String? date,
    String? time,
    int? competitionId,
    String? competitionName,
    String? competitionLogo,
    Team? homeTeam,
    Team? awayTeam,
    MatchStatus? status,
    String? stadium,
    String? referee,
    int? elapsed,
    int? homeGoals,
    int? awayGoals,
    int? homeHalfTimeGoals,
    int? awayHalfTimeGoals,
    bool? isSubscribed,
  }) {
    return SoccerMatch(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      competitionId: competitionId ?? this.competitionId,
      competitionName: competitionName ?? this.competitionName,
      competitionLogo: competitionLogo ?? this.competitionLogo,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      status: status ?? this.status,
      stadium: stadium ?? this.stadium,
      referee: referee ?? this.referee,
      elapsed: elapsed ?? this.elapsed,
      homeGoals: homeGoals ?? this.homeGoals,
      awayGoals: awayGoals ?? this.awayGoals,
      homeHalfTimeGoals: homeHalfTimeGoals ?? this.homeHalfTimeGoals,
      awayHalfTimeGoals: awayHalfTimeGoals ?? this.awayHalfTimeGoals,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  bool get isLive {
    return status == MatchStatus.firstHalf || 
           status == MatchStatus.halfTime || 
           status == MatchStatus.secondHalf || 
           status == MatchStatus.extraTime || 
           status == MatchStatus.breakTime || 
           status == MatchStatus.penalty;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SoccerMatch && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@HiveType(typeId: 3)
enum MatchStatus {
  @HiveField(0)
  toBeDefined,
  
  @HiveField(1)
  notStarted,
  
  @HiveField(2)
  firstHalf,
  
  @HiveField(3)
  halfTime,
  
  @HiveField(4)
  secondHalf,
  
  @HiveField(5)
  extraTime,
  
  @HiveField(6)
  penalty,
  
  @HiveField(7)
  fullTime,
  
  @HiveField(8)
  afterExtraTime,
  
  @HiveField(9)
  breakTime,
  
  @HiveField(10)
  suspended,
  
  @HiveField(11)
  interrupted,
  
  @HiveField(12)
  postponed,
  
  @HiveField(13)
  cancelled,
  
  @HiveField(14)
  abandoned,
  
  @HiveField(15)
  awarded,
  
  @HiveField(16)
  walkover,
  
  @HiveField(17)
  unknown,
}

// Note: To generate the Hive adapter code, run:
// flutter packages pub run build_runner build
// This will create the match.g.dart file for Hive serialization
