import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Soccer Plus';

  @override
  String get todayMatches => 'Today\'s Matches';

  @override
  String get competitions => 'Competitions';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get standings => 'Standings';

  @override
  String get matches => 'Matches';

  @override
  String get teams => 'Teams';

  @override
  String get searchCompetitions => 'Search competitions';

  @override
  String get noCompetitionsFound => 'No competitions found';

  @override
  String get favorites => 'Favorites only';

  @override
  String get upcomingMatches => 'Upcoming Matches';

  @override
  String get noMatchesFound => 'No matches found';

  @override
  String get matchDetails => 'Match Details';

  @override
  String get summary => 'Summary';

  @override
  String get lineups => 'Lineups';

  @override
  String get formation => 'Formation';

  @override
  String get timeline => 'Timeline';

  @override
  String get statistics => 'Statistics';

  @override
  String get possession => 'Possession';

  @override
  String get shots => 'Shots';

  @override
  String get shotsOnTarget => 'Shots on Target';

  @override
  String get corners => 'Corners';

  @override
  String get offsides => 'Offsides';

  @override
  String get fouls => 'Fouls';

  @override
  String get startingXI => 'Starting XI';

  @override
  String get substitutes => 'Substitutes';

  @override
  String get completed => 'Completed';

  @override
  String get live => 'Live';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get fullTime => 'Full Time';

  @override
  String get referee => 'Referee';

  @override
  String get noStandingsAvailable => 'No standings available';

  @override
  String get noTeamsAvailable => 'No teams available';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get subscribed => 'Subscribed';

  @override
  String subscriptionSuccess(Object team) {
    return 'You are now subscribed to $team matches';
  }

  @override
  String unsubscriptionSuccess(Object team) {
    return 'You have unsubscribed from $team matches';
  }

  @override
  String get tryAgain => 'Try Again';

  @override
  String get rank => 'Rank';

  @override
  String get team => 'Team';

  @override
  String get played => 'P';

  @override
  String get won => 'W';

  @override
  String get drawn => 'D';

  @override
  String get lost => 'L';

  @override
  String get goalDifference => 'GD';

  @override
  String get points => 'PTS';

  @override
  String get vs => 'vs';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get language => 'Language';
}
