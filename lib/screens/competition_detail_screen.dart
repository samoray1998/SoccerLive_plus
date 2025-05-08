import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/competition.dart';
import '../models/match.dart';
import '../providers/competitions_provider.dart';
import '../providers/matches_provider.dart';
import '../providers/standings_provider.dart';
import '../widgets/match_card.dart';
import '../widgets/standings_table.dart';
import 'match_detail_screen.dart';

class CompetitionDetailScreen extends StatefulWidget {
  final Competition competition;
  
  const CompetitionDetailScreen({
    Key? key,
    required this.competition,
  }) : super(key: key);

  @override
  State<CompetitionDetailScreen> createState() => _CompetitionDetailScreenState();
}

class _CompetitionDetailScreenState extends State<CompetitionDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    // Load standings data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final standingsProvider = Provider.of<StandingsProvider>(context, listen: false);
      standingsProvider.loadStandings(widget.competition.id);
    });
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // For now, use hardcoded strings until localization is fixed
    final competitionsProvider = Provider.of<CompetitionsProvider>(context);
    final isFavorite = competitionsProvider.isFavoriteCompetition(widget.competition.id);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.competition.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              competitionsProvider.toggleFavoriteCompetition(widget.competition.id);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Competition header with logo and info
          _buildCompetitionHeader(context),
          
          // Tab bar
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Standings', icon: Icon(Icons.format_list_numbered)),
              Tab(text: 'Matches', icon: Icon(Icons.sports_soccer)),
              Tab(text: 'Teams', icon: Icon(Icons.groups)),
            ],
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildStandingsTab(),
                _buildMatchesTab(),
                _buildTeamsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Highlight Competitions (middle tab)
        onTap: (index) {
          // Navigate back to main screen with the appropriate tab selected
          Navigator.of(context).pop();
          
          // Using a callback to notify the parent to switch tabs would be ideal
          // For now, we'll just navigate back to the main screen
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Today\'s Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Competitions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Subscriptions',
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompetitionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Competition logo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.competition.logo.isNotEmpty
                ? Image.network(
                    widget.competition.logo,
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
                  widget.competition.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (widget.competition.flag.isNotEmpty)
                      SizedBox(
                        width: 24,
                        height: 18,
                        child: Image.network(
                          widget.competition.flag,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    if (widget.competition.flag.isNotEmpty)
                      const SizedBox(width: 8),
                    Text(
                      widget.competition.country,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (widget.competition.currentSeason != null)
                  Text(
                    'Season: ${widget.competition.currentSeason}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStandingsTab() {
    return Consumer<StandingsProvider>(
      builder: (context, standingsProvider, child) {
        if (standingsProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (standingsProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${standingsProvider.errorMessage}',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    standingsProvider.loadStandings(widget.competition.id);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        final standings = standingsProvider.getStandingsByCompetitionId(widget.competition.id);

        if (standings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.table_chart, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No standings available',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Standings will be available soon.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: StandingsTable(standings: standings),
        );
      },
    );
  }
  
  Widget _buildMatchesTab() {
    return Consumer<MatchesProvider>(
      builder: (context, matchesProvider, child) {
        // Filter matches by competition
        final matches = matchesProvider.allMatches
            .where((match) => match.competitionId == widget.competition.id)
            .toList();
        
        if (matches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports_soccer, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No matches found',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for upcoming matches.',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }
        
        // Group matches by status (Live, Upcoming, Completed)
        final liveMatches = matches.where((m) => m.isLive).toList();
        final upcomingMatches = matches
            .where((m) => m.status == MatchStatus.notStarted)
            .toList();
        final completedMatches = matches
            .where((m) => m.status == MatchStatus.fullTime || 
                         m.status == MatchStatus.afterExtraTime || 
                         m.status == MatchStatus.penalty)
            .toList();
        
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            if (liveMatches.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'LIVE MATCHES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              ...liveMatches.map((match) => MatchCard(match: match)),
              const Divider(),
            ],
            
            if (upcomingMatches.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'UPCOMING MATCHES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...upcomingMatches.map((match) => MatchCard(match: match)),
              const Divider(),
            ],
            
            if (completedMatches.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'COMPLETED MATCHES',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...completedMatches.map((match) => MatchCard(match: match)),
            ],
          ],
        );
      },
    );
  }
  
  Widget _buildTeamsTab() {
    // In a real implementation, this would use a TeamsProvider to get real data
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.groups, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No teams available',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Team information will be available soon.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}