import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/competition_model.dart';
import '../providers/competition_provider.dart';
import 'match_detail_screen.dart';

class TeamMatchesScreen extends StatefulWidget {
  final Team team;
  final int competitionId;

  const TeamMatchesScreen({
    Key? key,
    required this.team,
    required this.competitionId,
  }) : super(key: key);

  @override
  State<TeamMatchesScreen> createState() => _TeamMatchesScreenState();
}

class _TeamMatchesScreenState extends State<TeamMatchesScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Match> _matches = [];
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _isSubscribed = widget.team.isSubscribed;
    _loadTeamMatches();
  }

  Future<void> _loadTeamMatches() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // In a real implementation, we would filter matches by team ID
      // For this demo, we'll reuse the competition matches
      final competitionProvider = Provider.of<CompetitionProvider>(context, listen: false);
      final allMatches = await competitionProvider.getMatches(widget.competitionId);
      
      // Filter matches for this team
      final teamMatches = allMatches.where((match) => 
        match.homeTeam == widget.team.name || match.awayTeam == widget.team.name
      ).toList();
      
      setState(() {
        _matches = teamMatches;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSubscription() async {
    try {
      final competitionProvider = Provider.of<CompetitionProvider>(context, listen: false);
      await competitionProvider.toggleTeamSubscription(widget.team.id);
      
      setState(() {
        _isSubscribed = !_isSubscribed;
      });
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isSubscribed
                  ? 'You are now subscribed to ${widget.team.name} matches'
                  : 'You have unsubscribed from ${widget.team.name} matches',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Team header section
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Image.network(
                    widget.team.logo,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.sports_soccer, size: 32),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.team.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _toggleSubscription,
                  icon: Icon(
                    _isSubscribed
                        ? Icons.notifications_active
                        : Icons.notifications_none,
                  ),
                  label: Text(_isSubscribed ? 'Subscribed' : 'Subscribe'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSubscribed
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Upcoming matches label
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text(
                  'Upcoming Matches',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Matches list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: $_errorMessage',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadTeamMatches,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    : _matches.isEmpty
                        ? const Center(
                            child: Text('No upcoming matches found'),
                          )
                        : ListView.builder(
                            itemCount: _matches.length,
                            itemBuilder: (context, index) {
                              final match = _matches[index];
                              final bool isHomeTeam = match.homeTeam == widget.team.name;
                              
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MatchDetailScreen(
                                          matchId: match.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        // Match date
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${_formatDate(match.date)} ${match.time}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: match.status == 'FT' 
                                                    ? Colors.green 
                                                    : match.status == 'NS' 
                                                        ? Colors.grey[300] 
                                                        : Colors.orange,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                match.status == 'FT' 
                                                    ? 'Completed' 
                                                    : match.status == 'NS' 
                                                        ? 'Upcoming' 
                                                        : 'Live',
                                                style: TextStyle(
                                                  color: match.status == 'NS' ? Colors.black87 : Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        const SizedBox(height: 16),
                                        
                                        // Teams
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: Image.network(
                                                      match.homeTeamLogo,
                                                      width: 32,
                                                      height: 32,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Icon(Icons.sports_soccer, size: 24);
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      match.homeTeam,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: isHomeTeam ? Theme.of(context).colorScheme.primary : null,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              child: Text(
                                                match.score ?? 'vs',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      match.awayTeam,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: !isHomeTeam ? Theme.of(context).colorScheme.primary : null,
                                                      ),
                                                      textAlign: TextAlign.end,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(16),
                                                    child: Image.network(
                                                      match.awayTeamLogo,
                                                      width: 32,
                                                      height: 32,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return const Icon(Icons.sports_soccer, size: 24);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('E, MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}