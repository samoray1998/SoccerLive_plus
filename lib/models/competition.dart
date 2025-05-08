import 'package:hive/hive.dart';

part 'competition.g.dart';

@HiveType(typeId: 1)
class Competition {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String country;
  
  @HiveField(3)
  final String logo;
  
  @HiveField(4)
  final String flag;
  
  @HiveField(5)
  final int? currentSeason;
  
  @HiveField(6)
  final bool isPopular;

  Competition({
    required this.id,
    required this.name,
    required this.country,
    required this.logo,
    required this.flag,
    this.currentSeason,
    this.isPopular = false,
  });

  factory Competition.fromJson(Map<String, dynamic> json) {
    return Competition(
      id: json['league']['id'],
      name: json['league']['name'],
      country: json['country']['name'],
      logo: json['league']['logo'] ?? '',
      flag: json['country']['flag'] ?? '',
      currentSeason: json['seasons']?.isNotEmpty == true ? json['seasons'][0]['year'] : null,
      isPopular: json['league']['is_popular'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'logo': logo,
      'flag': flag,
      'currentSeason': currentSeason,
      'isPopular': isPopular,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Competition && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
  
  Competition copyWith({
    int? id,
    String? name,
    String? country,
    String? logo,
    String? flag,
    int? currentSeason,
    bool? isPopular,
  }) {
    return Competition(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      logo: logo ?? this.logo,
      flag: flag ?? this.flag,
      currentSeason: currentSeason ?? this.currentSeason,
      isPopular: isPopular ?? this.isPopular,
    );
  }
}

// Note: To generate the Hive adapter code, run:
// flutter packages pub run build_runner build
// This will create the competition.g.dart file for Hive serialization
