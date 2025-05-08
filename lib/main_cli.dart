import 'dart:io';
import 'package:intl/intl.dart';

import 'models/match.dart';
import 'models/competition.dart';
import 'services/dummy_data_service.dart';

void main() {
  print('\n\n===== SOCCER PLUS CLI VERSION =====\n');
  print('This is a command-line interface to test the app\'s functionality');
  print('since we\'re experiencing web server configuration issues.\n');
  
  // Get today's date
  final today = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd').format(today);
  
  print('Today\'s Date: ${DateFormat.yMMMMEEEEd().format(today)}\n');
  
  // Get matches from dummy data service
  final allMatches = DummyDataService.getSampleMatches();
  
  // Filter to today's matches
  final todayMatches = allMatches.where((match) => match.date == formattedDate).toList();
  
  // Show live matches
  final liveMatches = todayMatches.where((match) => match.isLive).toList();
  if (liveMatches.isNotEmpty) {
    print('===== LIVE MATCHES =====');
    for (var match in liveMatches) {
      printMatch(match);
    }
    print('');
  }
  
  // Show all today's matches
  if (todayMatches.isNotEmpty) {
    print('===== TODAY\'S MATCHES =====');
    for (var match in todayMatches) {
      printMatch(match);
    }
  } else {
    print('No matches for today.');
  }
  
  // Show upcoming matches
  final upcomingMatches = allMatches.where((match) => 
    match.status == MatchStatus.notStarted && 
    match.date != formattedDate
  ).toList();
  
  if (upcomingMatches.isNotEmpty) {
    print('\n===== UPCOMING MATCHES =====');
    for (var match in upcomingMatches.take(3)) {
      printMatch(match);
    }
  }
  
  // Show completed matches
  final completedMatches = allMatches.where((match) => 
    match.status == MatchStatus.fullTime && 
    match.date != formattedDate
  ).toList();
  
  if (completedMatches.isNotEmpty) {
    print('\n===== COMPLETED MATCHES =====');
    for (var match in completedMatches.take(3)) {
      printMatch(match);
    }
  }
  
  // Show available competitions
  final competitions = DummyDataService.getSampleCompetitions();
  if (competitions.isNotEmpty) {
    print('\n===== COMPETITIONS =====');
    for (var competition in competitions) {
      printCompetition(competition);
    }
  }
  
  print('\n===== END OF CLI APP =====');
}

void printCompetition(Competition competition) {
  print('${competition.name} (${competition.country})');
  print('Season: ${competition.currentSeason}');
  print('Popular: ${competition.isPopular ? 'Yes' : 'No'}');
  print('----------');
}

void printMatch(SoccerMatch match) {
  final statusText = getStatusText(match);
  final scores = match.status == MatchStatus.notStarted ? 
    'vs' : 
    '${match.homeGoals ?? 0}-${match.awayGoals ?? 0}';
  
  print('${match.competitionName} | ${match.date} ${match.time}');
  print('${match.homeTeam.name} $scores ${match.awayTeam.name} | $statusText');
  if (match.stadium != null) {
    print('Stadium: ${match.stadium}');
  }
  print('----------');
}

String getStatusText(SoccerMatch match) {
  if (match.isLive) {
    return 'LIVE (${match.elapsed ?? ''}min)';
  }
  
  if (match.status == MatchStatus.fullTime || 
      match.status == MatchStatus.afterExtraTime ||
      match.status == MatchStatus.penalty) {
    return 'Full Time';
  }
  
  if (match.status == MatchStatus.notStarted || 
      match.status == MatchStatus.toBeDefined) {
    return 'Not Started';
  }
  
  // For other status values, return the capitalized status name
  final statusStr = match.status.toString().split('.').last;
  return statusStr.substring(0, 1).toUpperCase() + statusStr.substring(1);
}