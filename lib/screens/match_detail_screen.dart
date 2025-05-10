import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../models/match.dart';
import '../models/player_model.dart';
import '../providers/matches_provider.dart';
import '../services/dummy_data_service.dart';
import '../widgets/field_formation_widget.dart';
import '../widgets/lineup_widget.dart';
import '../widgets/match_events_timeline.dart';

class MatchDetailScreen extends StatefulWidget {
  final int matchId;

  const MatchDetailScreen({
    Key? key,
    required this.matchId,
  }) : super(key: key);

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  SoccerMatch? _match;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Get match data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final matchesProvider =
          Provider.of<MatchesProvider>(context, listen: false);
      setState(() {
        _match = matchesProvider.getMatchById(widget.matchId as int);
      });
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
    if (_match == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Match Details'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Match header with teams and score
          _buildMatchHeader(),

          // Tab bar
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Summary', icon: Icon(Icons.sports_soccer)),
              Tab(text: 'Lineups', icon: Icon(Icons.people)),
              Tab(text: 'Statistics', icon: Icon(Icons.bar_chart)),
            ],
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildLineupsTab(),
                _buildStatsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Highlight Today's Matches (first tab)
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

  Widget _buildMatchHeader() {
    final match = _match!;

    // Status text
    String statusText = '';
    Color statusColor = Colors.black;

    if (match.isLive) {
      statusText = 'LIVE';
      if (match.elapsed != null) {
        statusText += ' ${match.elapsed}\'';
      }
      statusColor = Colors.red;
    } else if (match.status == MatchStatus.fullTime ||
        match.status == MatchStatus.afterExtraTime ||
        match.status == MatchStatus.penalty) {
      statusText = 'Full Time';
      statusColor = Colors.green[700]!;
    } else if (match.status == MatchStatus.notStarted) {
      statusText = '${match.date} ${match.time}';
      statusColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          // Competition and date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                match.competitionName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Text(
                match.date,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Teams and score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home team
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
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
                      child: match.homeTeam.logo.isNotEmpty
                          ? Image.network(
                              match.homeTeam.logo,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.sports_soccer,
                                      color: Colors.grey),
                                );
                              },
                            )
                          : const Center(
                              child:
                                  Icon(Icons.sports_soccer, color: Colors.grey),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.homeTeam.name,
                      style: TextStyle(
                        fontWeight: match.homeTeam.winner == true
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Score
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                child: Column(
                  children: [
                    // Score
                    Text(
                      match.status == MatchStatus.notStarted
                          ? 'vs'
                          : '${match.homeGoals ?? 0} - ${match.awayGoals ?? 0}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Status
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Away team
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
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
                      child: match.awayTeam.logo.isNotEmpty
                          ? Image.network(
                              match.awayTeam.logo,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(Icons.sports_soccer,
                                      color: Colors.grey),
                                );
                              },
                            )
                          : const Center(
                              child:
                                  Icon(Icons.sports_soccer, color: Colors.grey),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.awayTeam.name,
                      style: TextStyle(
                        fontWeight: match.awayTeam.winner == true
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Venue info
          if (match.stadium != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stadium, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(
                  match.stadium!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),

          // Referee info
          if (match.referee != null) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sports, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Referee: ${match.referee!}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    final matchId = widget.matchId;
    final matchData = DummyDataService.getMatchDetails(matchId as int);

    if (matchData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_soccer, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Match summary will be available soon',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back during or after the match for timeline events',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Parse events data
    final List<dynamic> eventsData = matchData['summary']['events'];
    final List<MatchEvent> events = eventsData.map((eventData) {
      return MatchEvent(
        type: eventData['type'],
        minute: eventData['minute'],
        player: Player(
          id: eventData['player']['id'],
          name: eventData['player']['name'],
          photo: eventData['player']['photo'],
          position: eventData['player']['position'],
          number: eventData['player']['number'],
          nationality: eventData['player']['nationality'],
          stats: eventData['player']['stats'],
        ),
        assistedBy: eventData['assistedBy'] != null
            ? Player(
                id: eventData['assistedBy']['id'],
                name: eventData['assistedBy']['name'],
                photo: eventData['assistedBy']['photo'],
                position: eventData['assistedBy']['position'],
                number: eventData['assistedBy']['number'],
                nationality: eventData['assistedBy']['nationality'],
                stats: eventData['assistedBy']['stats'],
              )
            : null,
        detail: eventData['detail'],
        team: eventData['team'],
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Timeline',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MatchEventsTimeline(
            events: events,
            homeTeam: _match!.homeTeam.name,
            awayTeam: _match!.awayTeam.name,
          ),
        ],
      ),
    );
  }

  Widget _buildLineupsTab() {
    final matchId = widget.matchId;
    final matchData = DummyDataService.getMatchDetails(matchId as int);

    if (matchData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Team lineups will be available soon',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back closer to the match start time',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Parse lineups data
    final Map<String, dynamic> homeLineupData = matchData['lineups']['home'];
    final Map<String, dynamic> awayLineupData = matchData['lineups']['away'];

    // Home team players
    final List<dynamic> homeStartingXIData = homeLineupData['startingXI'];
    final List<dynamic> homeSubsData = homeLineupData['substitutes'];
    final List<dynamic> homeFormationPositionsData =
        homeLineupData['formation_positions'];

    final List<Player> homeStartingXI = homeStartingXIData
        .map((playerData) => Player(
              id: playerData['id'],
              name: playerData['name'],
              photo: playerData['photo'],
              position: playerData['position'],
              number: playerData['number'],
              nationality: playerData['nationality'],
              stats: playerData['stats'],
            ))
        .toList();

    final List<Player> homeSubs = homeSubsData
        .map((playerData) => Player(
              id: playerData['id'],
              name: playerData['name'],
              photo: playerData['photo'],
              position: playerData['position'],
              number: playerData['number'],
              nationality: playerData['nationality'],
              stats: playerData['stats'],
            ))
        .toList();

    // Away team players
    final List<dynamic> awayStartingXIData = awayLineupData['startingXI'];
    final List<dynamic> awaySubsData = awayLineupData['substitutes'];
    final List<dynamic> awayFormationPositionsData =
        awayLineupData['formation_positions'];

    final List<Player> awayStartingXI = awayStartingXIData
        .map((playerData) => Player(
              id: playerData['id'],
              name: playerData['name'],
              photo: playerData['photo'],
              position: playerData['position'],
              number: playerData['number'],
              nationality: playerData['nationality'],
              stats: playerData['stats'],
            ))
        .toList();

    final List<Player> awaySubs = awaySubsData
        .map((playerData) => Player(
              id: playerData['id'],
              name: playerData['name'],
              photo: playerData['photo'],
              position: playerData['position'],
              number: playerData['number'],
              nationality: playerData['nationality'],
              stats: playerData['stats'],
            ))
        .toList();

    // Create formation players
    final List<FormationPlayer> homeFormationPlayers =
        homeFormationPositionsData.map((posData) {
      final playerId = posData['player_id'];
      final Player player = homeStartingXI.firstWhere((p) => p.id == playerId);
      return FormationPlayer(
        player: player,
        x: posData['x'].toDouble(),
        y: posData['y'].toDouble(),
      );
    }).toList();

    final List<FormationPlayer> awayFormationPlayers =
        awayFormationPositionsData.map((posData) {
      final playerId = posData['player_id'];
      final Player player = awayStartingXI.firstWhere((p) => p.id == playerId);
      return FormationPlayer(
        player: player,
        x: posData['x'].toDouble(),
        y: posData['y'].toDouble(),
      );
    }).toList();

    // Create team formations
    final TeamFormation homeTeamFormation = TeamFormation(
      formation: homeLineupData['formation'],
      players: homeFormationPlayers,
    );

    final TeamFormation awayTeamFormation = TeamFormation(
      formation: awayLineupData['formation'],
      players: awayFormationPlayers,
    );

    // Create lineups
    final MatchLineup homeLineup = MatchLineup(
      startingXI: homeStartingXI,
      substitutes: homeSubs,
      formation: homeLineupData['formation'],
      teamFormation: homeTeamFormation,
    );

    final MatchLineup awayLineup = MatchLineup(
      startingXI: awayStartingXI,
      substitutes: awaySubs,
      formation: awayLineupData['formation'],
      teamFormation: awayTeamFormation,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Home team formation
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Formations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          FieldFormationWidget(
            formation: homeTeamFormation,
            teamName: _match!.homeTeam.name,
            teamColor: Colors.blue,
          ),

          const SizedBox(height: 16),

          FieldFormationWidget(
            formation: awayTeamFormation,
            teamName: _match!.awayTeam.name,
            teamColor: Colors.red,
          ),

          const Divider(height: 32),

          // Home team lineup
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Lineups',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          LineupWidget(
            lineup: homeLineup,
            teamName: _match!.homeTeam.name,
            teamLogo: _match!.homeTeam.logo,
          ),

          const SizedBox(height: 24),

          LineupWidget(
            lineup: awayLineup,
            teamName: _match!.awayTeam.name,
            teamLogo: _match!.awayTeam.logo,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    final matchId = widget.matchId;
    final matchData = DummyDataService.getMatchDetails(matchId as int);

    if (matchData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Match statistics will be available soon',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back during or after the match for detailed stats',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Parse statistics data
    final Map<String, dynamic> homeStatsData = matchData['statistics']['home'];
    final Map<String, dynamic> awayStatsData = matchData['statistics']['away'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Match Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Teams
          Row(
            children: [
              Expanded(
                child: Text(
                  _match!.homeTeam.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Expanded(
                child: Text(
                  'Stats',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  _match!.awayTeam.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Possession
          _buildStatRow(
            'Possession',
            '${homeStatsData['possession']}%',
            '${awayStatsData['possession']}%',
            homeStatsData['possession'],
            awayStatsData['possession'],
          ),

          const SizedBox(height: 16),

          // Shots
          _buildStatRow(
            'Shots',
            '${homeStatsData['shots']}',
            '${awayStatsData['shots']}',
            homeStatsData['shots'],
            awayStatsData['shots'],
          ),

          const SizedBox(height: 16),

          // Shots on target
          _buildStatRow(
            'Shots on Target',
            '${homeStatsData['shotsOnTarget']}',
            '${awayStatsData['shotsOnTarget']}',
            homeStatsData['shotsOnTarget'],
            awayStatsData['shotsOnTarget'],
          ),

          const SizedBox(height: 16),

          // Corners
          _buildStatRow(
            'Corners',
            '${homeStatsData['corners']}',
            '${awayStatsData['corners']}',
            homeStatsData['corners'],
            awayStatsData['corners'],
          ),

          const SizedBox(height: 16),

          // Offsides
          _buildStatRow(
            'Offsides',
            '${homeStatsData['offsides']}',
            '${awayStatsData['offsides']}',
            homeStatsData['offsides'],
            awayStatsData['offsides'],
          ),

          const SizedBox(height: 16),

          // Fouls
          _buildStatRow(
            'Fouls',
            '${homeStatsData['fouls']}',
            '${awayStatsData['fouls']}',
            homeStatsData['fouls'],
            awayStatsData['fouls'],
            invertColors: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String homeValue, String awayValue,
      num homeNum, num awayNum,
      {bool invertColors = false}) {
    // Calculate percentages
    final total = homeNum + awayNum;
    final homePercent = total > 0 ? homeNum / total * 100 : 50.0;
    final awayPercent = total > 0 ? awayNum / total * 100 : 50.0;

    // Colors
    final homeColor = invertColors ? Colors.red.shade600 : Colors.blue.shade600;
    final awayColor = invertColors ? Colors.blue.shade600 : Colors.red.shade600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(height: 4),

        // Values row
        Row(
          children: [
            Expanded(
              child: Text(
                homeValue,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: homeColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Expanded(
              child: Text(
                awayValue,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: awayColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Bar visualization
        SizedBox(
          height: 10,
          child: Row(
            children: [
              Expanded(
                flex: homePercent.round(),
                child: Container(
                  decoration: BoxDecoration(
                    color: homeColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: awayPercent.round(),
                child: Container(
                  decoration: BoxDecoration(
                    color: awayColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
