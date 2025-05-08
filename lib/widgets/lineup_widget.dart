import 'package:flutter/material.dart';
import '../models/player_model.dart';

class LineupWidget extends StatelessWidget {
  final MatchLineup lineup;
  final String teamName;
  final String teamLogo;
  
  const LineupWidget({
    Key? key,
    required this.lineup,
    required this.teamName,
    required this.teamLogo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Team header
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              child: Image.network(
                teamLogo,
                errorBuilder: (_, __, ___) => const Icon(Icons.sports_soccer),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  teamName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Formation: ${lineup.formation}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Starting XI
        const Text(
          'Starting XI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...lineup.startingXI.map((player) => _buildPlayerRow(player)),
        
        const SizedBox(height: 16),
        
        // Substitutes
        const Text(
          'Substitutes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...lineup.substitutes.map((player) => _buildPlayerRow(player)),
      ],
    );
  }
  
  Widget _buildPlayerRow(Player player) {
    // Map position codes to readable position names
    final Map<String, String> positionNames = {
      'G': 'Goalkeeper',
      'D': 'Defender',
      'M': 'Midfielder',
      'F': 'Forward',
      'GK': 'Goalkeeper',
      'DF': 'Defender',
      'MF': 'Midfielder',
      'FW': 'Forward',
    };
    
    String positionName = positionNames[player.position] ?? player.position;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Player number
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                player.number.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Player details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  positionName,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Player nationality
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              player.nationality,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}