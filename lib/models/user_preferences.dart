import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 5)
class UserPreferences {
  @HiveField(0)
  final List<int> favoriteCompetitions;
  
  @HiveField(1)
  final List<int> subscribedMatches;

  @HiveField(4)  // Changed from 2 to 4 to maintain order (see note below)
  final List<int> subscribedCompetitions;
  
  @HiveField(2)
  final NotificationSettings notificationSettings;
  
  @HiveField(3)
  final String? lastViewedDate;

  UserPreferences({
    required this.favoriteCompetitions,
    required this.subscribedMatches,
    required this.subscribedCompetitions,
    required this.notificationSettings,
    this.lastViewedDate,
  });

  factory UserPreferences.empty() {
    return UserPreferences(
      favoriteCompetitions: [],
      subscribedMatches: [],
      subscribedCompetitions: [],
      notificationSettings: NotificationSettings(),
      lastViewedDate: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteCompetitions': favoriteCompetitions,
      'subscribedMatches': subscribedMatches,
      'subscribedCompetitions': subscribedCompetitions,
      'notificationSettings': notificationSettings.toJson(),
      'lastViewedDate': lastViewedDate,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      favoriteCompetitions: List<int>.from(json['favoriteCompetitions'] ?? []),
      subscribedMatches: List<int>.from(json['subscribedMatches'] ?? []),
      subscribedCompetitions: List<int>.from(json['subscribedCompetitions'] ?? []),
      notificationSettings: NotificationSettings.fromJson(json['notificationSettings'] ?? {}),
      lastViewedDate: json['lastViewedDate'],
    );
  }

  UserPreferences copyWith({
    List<int>? favoriteCompetitions,
    List<int>? subscribedMatches,
    List<int>? subscribedCompetitions,
    NotificationSettings? notificationSettings,
    String? lastViewedDate,
  }) {
    return UserPreferences(
      favoriteCompetitions: favoriteCompetitions ?? this.favoriteCompetitions,
      subscribedMatches: subscribedMatches ?? this.subscribedMatches,
      subscribedCompetitions: subscribedCompetitions ?? this.subscribedCompetitions,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      lastViewedDate: lastViewedDate ?? this.lastViewedDate,
    );
  }

  bool hasCompetitionFavorited(int competitionId) {
    return favoriteCompetitions.contains(competitionId);
  }

  bool hasMatchSubscribed(int matchId) {
    return subscribedMatches.contains(matchId);
  }

  bool hasCompetitionSubscribed(int competitionId) {
    return subscribedCompetitions.contains(competitionId);
  }
}

@HiveType(typeId: 6)
class NotificationSettings {
  @HiveField(0)
  final bool goalNotifications;
  
  @HiveField(1)
  final bool redCardNotifications;
  
  @HiveField(2)
  final bool matchStartNotifications;
  
  @HiveField(3)
  final bool halfTimeNotifications;
  
  @HiveField(4)
  final bool fullTimeNotifications;

  @HiveField(5)
  final bool competitionUpdateNotifications;

  NotificationSettings({
    this.goalNotifications = true,
    this.redCardNotifications = true,
    this.matchStartNotifications = true,
    this.halfTimeNotifications = false,
    this.fullTimeNotifications = true,
    this.competitionUpdateNotifications = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'goalNotifications': goalNotifications,
      'redCardNotifications': redCardNotifications,
      'matchStartNotifications': matchStartNotifications,
      'halfTimeNotifications': halfTimeNotifications,
      'fullTimeNotifications': fullTimeNotifications,
      'competitionUpdateNotifications': competitionUpdateNotifications,
    };
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      goalNotifications: json['goalNotifications'] ?? true,
      redCardNotifications: json['redCardNotifications'] ?? true,
      matchStartNotifications: json['matchStartNotifications'] ?? true,
      halfTimeNotifications: json['halfTimeNotifications'] ?? false,
      fullTimeNotifications: json['fullTimeNotifications'] ?? true,
      competitionUpdateNotifications: json['competitionUpdateNotifications'] ?? true,
    );
  }

  NotificationSettings copyWith({
    bool? goalNotifications,
    bool? redCardNotifications,
    bool? matchStartNotifications,
    bool? halfTimeNotifications,
    bool? fullTimeNotifications,
    bool? competitionUpdateNotifications,
  }) {
    return NotificationSettings(
      goalNotifications: goalNotifications ?? this.goalNotifications,
      redCardNotifications: redCardNotifications ?? this.redCardNotifications,
      matchStartNotifications: matchStartNotifications ?? this.matchStartNotifications,
      halfTimeNotifications: halfTimeNotifications ?? this.halfTimeNotifications,
      fullTimeNotifications: fullTimeNotifications ?? this.fullTimeNotifications,
      competitionUpdateNotifications: competitionUpdateNotifications ?? this.competitionUpdateNotifications,
    );
  }
}

// Important Notes:
// 1. After making these changes, you'll need to:
//    - Delete your app's data or increment the Hive typeIds
//    - Run: flutter packages pub run build_runner build
// 2. The HiveField numbers were adjusted to:
//    - Keep existing fields with their original numbers
//    - Add new fields with sequential numbers
// 3. If you have existing user data, you'll need migration logic