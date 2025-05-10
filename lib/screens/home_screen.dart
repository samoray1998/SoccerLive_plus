import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../providers/matches_provider.dart';
import '../providers/user_preferences_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/date_selector.dart';
import '../widgets/match_list.dart';
import 'competitions_screen.dart';
import 'match_detail_screen.dart';
import 'subscriptions_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Initialize providers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
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
        _currentIndex = _tabController.index;
      });
    }
  }

  Future<void> _initializeProviders() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId;

    if (userId != null) {
      // Load user preferences
      final prefsProvider =
          Provider.of<UserPreferencesProvider>(context, listen: false);
      await prefsProvider.loadUserPreferences(userId);

      // Load matches for today
      final matchesProvider =
          Provider.of<MatchesProvider>(context, listen: false);
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      matchesProvider.setSelectedDate(today);

      // Initialize notifications
      final notificationsProvider =
          Provider.of<NotificationsProvider>(context, listen: false);
      await notificationsProvider.initialize(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soccer Plus'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final matchesProvider =
                  Provider.of<MatchesProvider>(context, listen: false);
              matchesProvider.refreshMatches();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TodayMatchesTab(),
          //  CompetitionsScreen(),
          Scaffold(
            backgroundColor: Colors.red,
          ),
          //  SubscriptionsScreen(),
          Scaffold(
            backgroundColor: Colors.yellow,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _tabController.animateTo(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Matches',
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
}

class TodayMatchesTab extends StatelessWidget {
  const TodayMatchesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date selector
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: DateSelector(),
        ),

        // Live matches section
        Consumer<MatchesProvider>(
          builder: (context, matchesProvider, child) {
            final liveMatches = matchesProvider.liveMatches;

            if (liveMatches.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.live_tv, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Live Matches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: liveMatches.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 300,
                          child: Card(
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MatchDetailScreen(
                                        matchId: liveMatches[index].id),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: Text(
                                  '${liveMatches[index].elapsed ?? 0}\'',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        liveMatches[index].homeTeam.name,
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${liveMatches[index].homeGoals ?? 0} - ${liveMatches[index].awayGoals ?? 0}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        liveMatches[index].awayTeam.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  liveMatches[index].competitionName,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),

        // All matches for selected date
        Expanded(
          child: Consumer<MatchesProvider>(
            builder: (context, matchesProvider, child) {
              if (matchesProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (matchesProvider.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${matchesProvider.errorMessage}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          matchesProvider.refreshMatches();
                        },
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }

              final matches = matchesProvider.selectedDateMatches;

              if (matches.isEmpty) {
                return const Center(
                  child: Text('No matches found for this date'),
                );
              }

              return MatchList(matches: matches);
            },
          ),
        ),
      ],
    );
  }
}
