import 'package:flutter/material.dart';
import '../models/player_model.dart';

class MatchEventsTimeline extends StatelessWidget {
  final List<MatchEvent> events;
  final String homeTeam;
  final String awayTeam;
  
  const MatchEventsTimeline({
    Key? key,
    required this.events,
    required this.homeTeam,
    required this.awayTeam,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort events by minute
    final sortedEvents = [...events]..sort((a, b) => a.minute.compareTo(b.minute));
    
    if (sortedEvents.isEmpty) {
      return const Center(
        child: Text('No events yet'),
      );
    }
    
    return ListView.builder(
      itemCount: sortedEvents.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final event = sortedEvents[index];
        return _buildEventItem(event, context);
      },
    );
  }
  
  Widget _buildEventItem(MatchEvent event, BuildContext context) {
    // Determine icon based on event type
    IconData iconData;
    Color iconColor;
    String eventText;
    
    switch (event.type) {
      case 'goal':
        iconData = Icons.sports_soccer;
        iconColor = Colors.green;
        if (event.detail == 'Own Goal') {
          eventText = 'Own Goal';
        } else if (event.detail == 'Penalty') {
          eventText = 'Goal (Penalty)';
        } else {
          eventText = 'Goal';
        }
        break;
      case 'card':
        if (event.detail == 'Yellow Card') {
          iconData = Icons.square;
          iconColor = Colors.yellow;
          eventText = 'Yellow Card';
        } else {
          iconData = Icons.square;
          iconColor = Colors.red;
          eventText = 'Red Card';
        }
        break;
      case 'substitution':
        iconData = Icons.swap_horiz;
        iconColor = Colors.blue;
        eventText = 'Substitution';
        break;
      default:
        iconData = Icons.sports;
        iconColor = Colors.grey;
        eventText = event.type;
    }
    
    final isHomeTeam = event.team == homeTeam;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Minute indicator
          Container(
            width: 36,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${event.minute}\'',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Event icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 18,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Event details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event type and player
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                        text: eventText,
                        style: TextStyle(
                          color: iconColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: ' - '),
                      TextSpan(
                        text: event.player.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Team name
                Text(
                  event.team,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                
                // Assist if available
                if (event.type == 'goal' && event.assistedBy != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Assist: ${event.assistedBy!.name}',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Team indicator (left or right to show which team)
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: isHomeTeam ? Colors.blue : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}