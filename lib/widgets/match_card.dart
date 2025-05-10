import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/match.dart';
import '../screens/match_detail_screen.dart';

class MatchCard extends StatelessWidget {
  final SoccerMatch match;
  final VoidCallback? onTap;

  const MatchCard({
    Key? key,
    required this.match,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MatchDetailScreen(matchId: match.id),
                ),
              );
            },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Competition and time information
              Row(
                children: [
                  if (match.competitionLogo.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.network(
                        match.competitionLogo,
                        width: 20,
                        height: 20,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.sports_soccer, size: 20),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      match.competitionName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getMatchStatusText(match, l10n),
                    style: TextStyle(
                      color: _getStatusColor(match.status),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Teams and score
              Row(
                children: [
                  // Home Team
                  Expanded(
                    child: Row(
                      children: [
                        _buildTeamLogo(match.homeTeam.logo),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            match.homeTeam.name,
                            style: TextStyle(
                              fontWeight: match.homeTeam.winner == true
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Score
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: match.isLive
                          ? Colors.red.shade100
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        if (match.isLive) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          _getScoreText(match, l10n),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: match.isLive
                                ? Colors.red.shade900
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Away Team
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            match.awayTeam.name,
                            style: TextStyle(
                              fontWeight: match.awayTeam.winner == true
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildTeamLogo(match.awayTeam.logo),
                      ],
                    ),
                  ),
                ],
              ),

              if (match.stadium != null || match.referee != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      if (match.stadium != null) ...[
                        const Icon(Icons.stadium, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          match.stadium!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (match.stadium != null && match.referee != null)
                        const Text(' • ', style: TextStyle(color: Colors.grey)),
                      if (match.referee != null) ...[
                        const Icon(Icons.sports, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${l10n.referee}: ${match.referee}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamLogo(String logoUrl) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          logoUrl,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.sports_soccer, size: 20),
        ),
      ),
    );
  }

  String _getMatchStatusText(SoccerMatch match, AppLocalizations l10n) {
    if (match.isLive) {
      return '${match.elapsed ?? ''}\'';
    }

    if (match.status == MatchStatus.fullTime ||
        match.status == MatchStatus.afterExtraTime ||
        match.status == MatchStatus.penalty) {
      return l10n.fullTime;
    }

    if (match.status == MatchStatus.notStarted ||
        match.status == MatchStatus.toBeDefined) {
      return match.time;
    }

    // For other status values, return the capitalized status name
    final statusStr = match.status.toString().split('.').last;
    return statusStr.substring(0, 1).toUpperCase() + statusStr.substring(1);
  }

  String _getScoreText(SoccerMatch match, AppLocalizations l10n) {
    if (match.status == MatchStatus.notStarted ||
        match.status == MatchStatus.toBeDefined ||
        match.status == MatchStatus.postponed ||
        match.status == MatchStatus.cancelled) {
      return l10n.vs;
    }

    return '${match.homeGoals ?? 0}-${match.awayGoals ?? 0}';
  }

  Color _getStatusColor(MatchStatus status) {
    if (status == MatchStatus.firstHalf ||
        status == MatchStatus.secondHalf ||
        status == MatchStatus.extraTime ||
        status == MatchStatus.penalty ||
        status == MatchStatus.halfTime ||
        status == MatchStatus.breakTime) {
      return Colors.red;
    }

    if (status == MatchStatus.fullTime ||
        status == MatchStatus.afterExtraTime) {
      return Colors.green;
    }

    if (status == MatchStatus.cancelled ||
        status == MatchStatus.postponed ||
        status == MatchStatus.suspended ||
        status == MatchStatus.interrupted ||
        status == MatchStatus.abandoned) {
      return Colors.orange;
    }

    return Colors.grey;
  }
}
