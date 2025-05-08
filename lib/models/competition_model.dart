class Competition {
  final int id;
  final String name;
  final String country;
  final String logo;
  final String? type;
  final int? seasonYear;
  final bool isFavorite;

  Competition({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    this.type,
    this.seasonYear,
    this.isFavorite = false,
  });

  Competition copyWith({
    int? id,
    String? name,
    String? country,
    String? logo,
    String? type,
    int? seasonYear,
    bool? isFavorite,
  }) {
    return Competition(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      logo: logo ?? this.logo,
      type: type ?? this.type,
      seasonYear: seasonYear ?? this.seasonYear,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class Standing {
  final int rank;
  final Team team;
  final int points;
  final int goalsDiff;
  final String form;
  final StandingStats stats;

  Standing({
    required this.rank,
    required this.team,
    required this.points,
    required this.goalsDiff,
    required this.form,
    required this.stats,
  });
}

class StandingStats {
  final int played;
  final int win;
  final int draw;
  final int lose;
  final int goalsFor;
  final int goalsAgainst;

  StandingStats({
    required this.played,
    required this.win,
    required this.draw,
    required this.lose,
    required this.goalsFor,
    required this.goalsAgainst,
  });
}

class Team {
  final int id;
  final String name;
  final String logo;
  final bool isSubscribed;

  Team({
    required this.id,
    required this.name,
    required this.logo,
    this.isSubscribed = false,
  });

  Team copyWith({
    int? id,
    String? name,
    String? logo,
    bool? isSubscribed,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }
}