import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/competition.dart';
import '../providers/competitions_provider.dart';
import '../widgets/competition_card.dart';
import 'competition_detail_screen.dart';

class CompetitionsTab extends StatelessWidget {
  const CompetitionsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Search and filter bar
        _buildSearchBar(context),
        
        // Competitions list
        Expanded(
          child: Consumer<CompetitionsProvider>(
            builder: (context, competitionsProvider, child) {
              if (competitionsProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (competitionsProvider.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${competitionsProvider.errorMessage}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          competitionsProvider.loadCompetitions();
                        },
                        child: const Text('Try Again'), // Temporary hardcoded string
                      ),
                    ],
                  ),
                );
              }
              
              final competitions = competitionsProvider.competitions;
              
              if (competitions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No competitions found', // Temporary hardcoded string
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: competitions.length,
                itemBuilder: (context, index) {
                  return CompetitionCard(
                    competition: competitions[index],
                    onTap: () => _navigateToCompetitionDetail(context, competitions[index]), onFavoriteToggle: () {  },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildSearchBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final competitionsProvider = Provider.of<CompetitionsProvider>(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Search field
          TextField(
            decoration: InputDecoration(
              hintText: 'Search competitions', // Using hardcoded string temporarily
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              competitionsProvider.setSearchQuery(value.isEmpty ? null : value);
            },
          ),
          
          const SizedBox(height: 12),
          
          // Filter toggle
          Row(
            children: [
              // Using a hardcoded string until localization is updated
              const Text(
                'Favorites only',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Switch(
                value: competitionsProvider.isFavoriteFilterEnabled,
                onChanged: (value) {
                  competitionsProvider.toggleFavoriteFilter(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _navigateToCompetitionDetail(BuildContext context, Competition competition) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompetitionDetailScreen(competition: competition),
      ),
    );
  }
}