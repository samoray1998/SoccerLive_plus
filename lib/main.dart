import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'config/theme.dart';
import 'models/match.dart';
import 'providers/language_provider.dart';
import 'providers/matches_provider.dart';
import 'providers/competitions_provider.dart';
import 'providers/standings_provider.dart';
import 'screens/competitions_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/subscriptions_screen.dart';
import 'widgets/match_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => MatchesProvider()),
        ChangeNotifierProvider(create: (_) => CompetitionsProvider()),
        ChangeNotifierProvider(create: (_) => StandingsProvider()),
      ],
      child: const SoccerPlusApp(),
    ),
  );
}

class SoccerPlusApp extends StatelessWidget {
  const SoccerPlusApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return MaterialApp(
      title: 'Soccer Plus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
      
      // Localization settings
      locale: languageProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    
    // Initialize matches and competitions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchesProvider>(context, listen: false).initializeWithToday();
      Provider.of<CompetitionsProvider>(context, listen: false).loadCompetitions();
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
  
  @override
  Widget build(BuildContext context) {
    // Get the app localizations
    final l10n = AppLocalizations.of(context)!;
    
    // Determine text direction based on locale
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final matchesProvider = Provider.of<MatchesProvider>(context, listen: false);
              matchesProvider.refreshMatches();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TodayMatchesTab(),
          CompetitionsTab(),
          SubscriptionsTab(),
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.sports_soccer),
            label: l10n.todayMatches,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.emoji_events),
            label: l10n.competitions,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: l10n.subscriptions,
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
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // Date selector
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildDateSelector(context),
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.live_tv, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        l10n.live,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: liveMatches.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 300,
                        child: MatchCard(match: liveMatches[index]),
                      );
                    },
                  ),
                ),
                const Divider(),
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
                        child: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                );
              }
              
              final matches = matchesProvider.matches;
              
              if (matches.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sports_soccer, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noMatchesFound,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  return MatchCard(match: matches[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildDateSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final matchesProvider = Provider.of<MatchesProvider>(context);
    final selectedDate = matchesProvider.selectedDate != null
        ? DateTime.parse(matchesProvider.selectedDate!)
        : DateTime.now();
    
    final languageProvider = Provider.of<LanguageProvider>(context);
    final locale = languageProvider.locale.languageCode;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            final previousDay = selectedDate.subtract(const Duration(days: 1));
            final formattedDate = DateFormat('yyyy-MM-dd').format(previousDay);
            matchesProvider.setSelectedDate(formattedDate);
          },
        ),
        TextButton(
          onPressed: () async {
            final today = DateTime.now();
            final formattedDate = DateFormat('yyyy-MM-dd').format(today);
            matchesProvider.setSelectedDate(formattedDate);
          },
          child: Column(
            children: [
              Text(
                DateFormat.EEEE(locale).format(selectedDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                DateFormat.yMMMd(locale).format(selectedDate),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            final nextDay = selectedDate.add(const Duration(days: 1));
            final formattedDate = DateFormat('yyyy-MM-dd').format(nextDay);
            matchesProvider.setSelectedDate(formattedDate);
          },
        ),
      ],
    );
  }
}
