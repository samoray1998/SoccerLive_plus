import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soccer_plus/models/user_preferences.dart';

import '../models/competition.dart';
import '../providers/auth_provider.dart';
import '../providers/competitions_provider.dart';
import '../providers/user_preferences_provider.dart';
import '../widgets/competition_selector.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Competition> _selectedCompetitions = [];

  @override
  void initState() {
    super.initState();

    // Load competitions when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final competitionsProvider =
          Provider.of<CompetitionsProvider>(context, listen: false);
      competitionsProvider.loadCompetitions();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() async {
    if (_selectedCompetitions.isEmpty) {
      // Show warning to select at least one competition
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one competition to follow'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId;

    if (userId != null) {
      final prefsProvider =
          Provider.of<UserPreferencesProvider>(context, listen: false);

      // Save selected competitions
      final competitionIds = _selectedCompetitions.map((c) => c.id).toList();
      await prefsProvider.saveUserPreferences(
        userId,
        prefsProvider.userPreferences?.copyWith(
              favoriteCompetitions: competitionIds,
            ) ??
            UserPreferences(
              favoriteCompetitions: competitionIds,
              subscribedMatches: [],
              notificationSettings: NotificationSettings(),
              subscribedCompetitions: [],
            ),
      );

      // Navigate to home screen
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  void _onCompetitionSelected(Competition competition, bool selected) {
    setState(() {
      if (selected) {
        if (!_selectedCompetitions.contains(competition)) {
          _selectedCompetitions.add(competition);
        }
      } else {
        _selectedCompetitions.removeWhere((c) => c.id == competition.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    'Step ${_currentPage + 1} of 2',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / 2,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // Welcome page
                  _buildWelcomePage(),

                  // Competition selection page
                  _buildCompetitionSelectionPage(),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button (hidden on first page)
                  _currentPage > 0
                      ? TextButton(
                          onPressed: _previousPage,
                          child: const Text('Back'),
                        )
                      : const SizedBox(width: 80),

                  // Next/Finish button
                  ElevatedButton(
                    onPressed:
                        _currentPage < 1 ? _nextPage : _completeOnboarding,
                    child: Text(_currentPage < 1 ? 'Next' : 'Get Started'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_soccer,
            size: 80,
            color: Colors.green,
          ),
          const SizedBox(height: 20),
          const Text(
            'Welcome to Soccer Plus',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your ultimate companion for live soccer scores, matches, and notifications',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          const Text(
            'Get started by selecting your favorite competitions to follow',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionSelectionPage() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Select your favorite competitions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        Expanded(
          child: CompetitionSelector(
            onCompetitionSelected: _onCompetitionSelected,
            initialSelectedCompetitions: _selectedCompetitions,
          ),
        ),

        // Selected competitions counter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Selected: ${_selectedCompetitions.length} competitions',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
