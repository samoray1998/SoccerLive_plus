import 'package:flutter/material.dart';
import '../models/player_model.dart';

class FieldFormationWidget extends StatelessWidget {
  final TeamFormation formation;
  final String teamName;
  final Color teamColor;
  
  const FieldFormationWidget({
    Key? key,
    required this.formation,
    required this.teamName,
    required this.teamColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 420,
      decoration: BoxDecoration(
        color: Colors.green[800],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Field markings
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: SoccerFieldPainter(),
          ),
          
          // Formation name
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$teamName (${formation.formation})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Players
          ...formation.players.map((player) => _buildPlayerMarker(player)),
        ],
      ),
    );
  }
  
  Widget _buildPlayerMarker(FormationPlayer formationPlayer) {
    return Positioned(
      left: formationPlayer.x * 0.01 * double.infinity,
      top: formationPlayer.y * 0.01 * 420,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: teamColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            formationPlayer.player.number.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SoccerFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final width = size.width;
    final height = size.height;
    
    // Outer boundary
    canvas.drawRect(Rect.fromLTWH(10, 10, width - 20, height - 20), paint);
    
    // Center line
    canvas.drawLine(
      Offset(10, height / 2),
      Offset(width - 10, height / 2),
      paint,
    );
    
    // Center circle
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      30,
      paint,
    );
    
    // Center dot
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      2,
      Paint()..color = Colors.white,
    );
    
    // Goal areas
    // Top goal area
    canvas.drawRect(
      Rect.fromLTWH(width / 2 - 40, 10, 80, 20),
      paint,
    );
    
    // Top penalty area
    canvas.drawRect(
      Rect.fromLTWH(width / 2 - 70, 10, 140, 50),
      paint,
    );
    
    // Bottom goal area
    canvas.drawRect(
      Rect.fromLTWH(width / 2 - 40, height - 30, 80, 20),
      paint,
    );
    
    // Bottom penalty area
    canvas.drawRect(
      Rect.fromLTWH(width / 2 - 70, height - 60, 140, 50),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}