import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/competitions_provider.dart';
import 'competition_detail_screen.dart';

class SubscriptionsTab extends StatelessWidget {
  const SubscriptionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using hard-coded strings until localization is regenerated
    
    return Consumer<CompetitionsProvider>(
      builder: (context, competitionsProvider, child) {
        final favoriteCompetitions = competitionsProvider.favoriteCompetitions;
        
        if (competitionsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (favoriteCompetitions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_off, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No subscriptions yet',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Star competitions to receive notifications',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Switch to competitions tab
                    final tabController = DefaultTabController.of(context);
                    if (tabController != null) {
                      tabController.animateTo(1); // Index 1 is competitions tab
                    }
                  },
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('View Competitions'),
                ),
              ],
            ),
          );
        }
        
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Your Subscriptions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // List of favorite competitions
            ...favoriteCompetitions.map((competition) {
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: competition.logo.isNotEmpty
                      ? Image.network(
                          competition.logo,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.emoji_events, color: Colors.grey),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(Icons.emoji_events, color: Colors.grey),
                        ),
                ),
                title: Text(competition.name),
                subtitle: Text(competition.country),
                trailing: IconButton(
                  icon: const Icon(Icons.star, color: Colors.amber),
                  onPressed: () {
                    competitionsProvider.toggleFavoriteCompetition(competition.id);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompetitionDetailScreen(competition: competition),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }
}