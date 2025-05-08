import 'package:flutter/material.dart';
import '../models/standing.dart';

class StandingsTable extends StatelessWidget {
  final List<Standing> standings;
  
  const StandingsTable({
    Key? key,
    required this.standings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Table header
        Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              const SizedBox(width: 30, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              const Expanded(child: Text('Team', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 30, child: Text('P', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 30, child: Text('W', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 30, child: Text('D', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 30, child: Text('L', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 30, child: Text('GF', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 30, child: Text('GA', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 30, child: Text('GD', style: TextStyle(fontWeight: FontWeight.bold))),
              SizedBox(width: 30, child: Text('Pts', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        
        // Table rows
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: standings.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final standing = standings[index];
            
            // Determine background color based on position
            Color? rowColor;
            if (index < 4) {
              // Champions League spots
              rowColor = Colors.blue.withOpacity(0.05);
            } else if (index >= standings.length - 3) {
              // Relegation spots
              rowColor = Colors.red.withOpacity(0.05);
            }
            
            return Container(
              color: rowColor,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  // Position
                  SizedBox(
                    width: 30,
                    child: Text(
                      standing.position.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getPositionColor(standing.position, standings.length),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Team
                  Expanded(
                    child: Row(
                      children: [
                        // Team logo
                        Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 8),
                          child: Image.network(
                            standing.team.logo,
                            errorBuilder: (_, __, ___) => const Icon(Icons.sports_soccer, size: 20),
                          ),
                        ),
                        // Team name
                        Expanded(
                          child: Text(
                            standing.team.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Played
                  SizedBox(width: 30, child: Text(standing.playedGames.toString(), textAlign: TextAlign.center)),
                  
                  // Won
                  SizedBox(width: 30, child: Text(standing.won.toString(), textAlign: TextAlign.center)),
                  
                  // Draw
                  SizedBox(width: 30, child: Text(standing.draw.toString(), textAlign: TextAlign.center)),
                  
                  // Lost
                  SizedBox(width: 30, child: Text(standing.lost.toString(), textAlign: TextAlign.center)),
                  
                  // Goals For
                  SizedBox(width: 30, child: Text(standing.goalsFor.toString(), textAlign: TextAlign.center)),
                  
                  // Goals Against
                  SizedBox(width: 30, child: Text(standing.goalsAgainst.toString(), textAlign: TextAlign.center)),
                  
                  // Goal Difference
                  SizedBox(
                    width: 30,
                    child: Text(
                      standing.goalDifference > 0 ? '+${standing.goalDifference}' : standing.goalDifference.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: standing.goalDifference > 0
                            ? Colors.green
                            : standing.goalDifference < 0
                                ? Colors.red
                                : null,
                      ),
                    ),
                  ),
                  
                  // Points
                  SizedBox(
                    width: 30,
                    child: Text(
                      standing.points.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        // Legend
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Legend:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: Colors.blue.withOpacity(0.2),
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  const Text('UEFA Champions League'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: Colors.red.withOpacity(0.2),
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  const Text('Relegation'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Color? _getPositionColor(int position, int totalTeams) {
    if (position <= 4) {
      return Colors.blue;
    } else if (position > totalTeams - 3) {
      return Colors.red;
    }
    return null;
  }
}