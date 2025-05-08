import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/competition.dart';
import '../providers/competitions_provider.dart';

class CompetitionCard extends StatelessWidget {
  final Competition competition;
  final Function()? onTap;
  bool isFavorite;

  CompetitionCard({
    Key? key,
    required this.competition,
    this.isFavorite = false,
    this.onTap, required void Function() onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final competitionsProvider = Provider.of<CompetitionsProvider>(context);
    final isFavorite =
        competitionsProvider.isFavoriteCompetition(competition.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Competition logo
              Container(
                width: 50,
                height: 50,
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
              const SizedBox(width: 16),
              // Competition info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      competition.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (competition.flag.isNotEmpty)
                          SizedBox(
                            width: 20,
                            height: 15,
                            child: Image.network(
                              competition.flag,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        if (competition.flag.isNotEmpty)
                          const SizedBox(width: 4),
                        Text(
                          competition.country,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Favorite button
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  competitionsProvider
                      .toggleFavoriteCompetition(competition.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
