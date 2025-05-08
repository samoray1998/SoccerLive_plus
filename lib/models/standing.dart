import 'package:json_annotation/json_annotation.dart';
import 'team.dart';

part 'standing.g.dart';

@JsonSerializable(explicitToJson: true)
class Standing {
  final int position;
  final Team team;
  final int playedGames;
  final int won;
  final int draw;
  final int lost;
  final int points;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final String form;

  Standing({
    required this.position,
    required this.team,
    required this.playedGames,
    required this.won,
    required this.draw,
    required this.lost,
    required this.points,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    this.form = '',
  });

  factory Standing.fromJson(Map<String, dynamic> json) => _$StandingFromJson(json);
  
  Map<String, dynamic> toJson() => _$StandingToJson(this);
}