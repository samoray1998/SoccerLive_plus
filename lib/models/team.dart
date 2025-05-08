import 'package:hive/hive.dart';

part 'team.g.dart';

@HiveType(typeId: 4)
class Team {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String logo;
  
  @HiveField(3)
  final bool? winner;

  Team({
    required this.id,
    required this.name,
    required this.logo,
    this.winner,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      logo: json['logo'] ?? '',
      winner: json['winner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'winner': winner,
    };
  }

  Team copyWith({
    int? id,
    String? name,
    String? logo,
    bool? winner,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      winner: winner ?? this.winner,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Team && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Note: To generate the Hive adapter code, run:
// flutter packages pub run build_runner build
// This will create the team.g.dart file for Hive serialization
