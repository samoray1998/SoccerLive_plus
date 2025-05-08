import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/match.dart';
import '../providers/matches_provider.dart';
import '../providers/notifications_provider.dart';
import '../screens/match_detail_screen.dart';
import 'match_card.dart';

class MatchList extends StatelessWidget {
  final List<SoccerMatch> matches;
  
  const MatchList({
    Key? key,
    required this.matches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group matches by competition
    final groupedMatches = <int, List<SoccerMatch>>{};
    
    for (var match in matches) {
      if (!groupedMatches.containsKey(match.competitionId)) {
        groupedMatches[match.competitionId] = [];
      }
      groupedMatches[match.competitionId]!.add(match);
    }
    
    return ListView.builder(
      itemCount: groupedMatches.length,
      itemBuilder: (context, index) {
        final competitionId = groupedMatches.keys.elementAt(index);
        final competitionMatches = groupedMatches[competitionId]!;
        final firstMatch = competitionMatches.first;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      firstMatch.competitionLogo,
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.sports_soccer, size: 24),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      firstMatch.competitionName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Consumer<NotificationsProvider>(
                    builder: (context, notificationsProvider, child) {
                      final isSubscribed = notificationsProvider.isCompetitionSubscribed(
                        firstMatch.competitionId
                      );
                      
                      return IconButton(
                        icon: Icon(
                          isSubscribed ? Icons.notifications_active : Icons.notifications_none,
                          color: isSubscribed ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () {
                          notificationsProvider.toggleCompetitionSubscription(firstMatch.competitionId);
                        },
                        tooltip: isSubscribed ? 'Unsubscribe from updates' : 'Subscribe to updates',
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: competitionMatches.length,
              itemBuilder: (context, matchIndex) {
                final match = competitionMatches[matchIndex];
                return MatchCard(
                  match: match,
                  // No need to specify onTap here since we updated MatchCard to handle navigation
                  // when onTap is null
                );
              },
            ),
          ],
        );
      },
    );
  }
}