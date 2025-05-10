class Player {
  final int id;
  final String name;
  final String? photo;
  final String position;
  final int number;
  final String nationality;
  final Map<dynamic, dynamic> stats;

  Player({
    required this.id,
    required this.name,
    this.photo,
    required this.position,
    required this.number,
    required this.nationality,
    required this.stats,
  });
}

class MatchEvent {
  final String type; // 'goal', 'card', 'substitution'
  final int minute;
  final Player player;
  final Player? assistedBy;
  final String?
      detail; // 'Yellow Card', 'Red Card', 'Own Goal', 'Penalty', etc.
  final String team;

  MatchEvent({
    required this.type,
    required this.minute,
    required this.player,
    this.assistedBy,
    this.detail,
    required this.team,
  });
}

class TeamFormation {
  final String formation; // e.g., '4-3-3', '3-5-2'
  final List<FormationPlayer> players;

  TeamFormation({
    required this.formation,
    required this.players,
  });
}

class FormationPlayer {
  final Player player;
  final double x; // position on field (0-100%)
  final double y; // position on field (0-100%)

  FormationPlayer({
    required this.player,
    required this.x,
    required this.y,
  });
}

class MatchStatistics {
  final int possession;
  final int shots;
  final int shotsOnTarget;
  final int corners;
  final int offsides;
  final int fouls;

  MatchStatistics({
    required this.possession,
    required this.shots,
    required this.shotsOnTarget,
    required this.corners,
    required this.offsides,
    required this.fouls,
  });
}

class MatchLineup {
  final List<Player> startingXI;
  final List<Player> substitutes;
  final String formation;
  final TeamFormation teamFormation;

  MatchLineup({
    required this.startingXI,
    required this.substitutes,
    required this.formation,
    required this.teamFormation,
  });
}

class MatchDetails {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final int? homeGoals;
  final int? awayGoals;
  final String date;
  final String time;
  final String status;
  final String venue;
  final String referee;
  final List<MatchEvent> events;
  final MatchStatistics homeStats;
  final MatchStatistics awayStats;
  final MatchLineup homeLineup;
  final MatchLineup awayLineup;

  MatchDetails({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    this.homeGoals,
    this.awayGoals,
    required this.date,
    required this.time,
    required this.status,
    required this.venue,
    required this.referee,
    required this.events,
    required this.homeStats,
    required this.awayStats,
    required this.homeLineup,
    required this.awayLineup,
  });
}
