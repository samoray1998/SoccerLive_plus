import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/competition.dart';
import '../providers/competitions_provider.dart';
import 'competition_card.dart';

class CompetitionSelector extends StatefulWidget {
  final Function(Competition, bool) onCompetitionSelected;
  final List<Competition> initialSelectedCompetitions;

  const CompetitionSelector({
    Key? key,
    required this.onCompetitionSelected,
    required this.initialSelectedCompetitions,
  }) : super(key: key);

  @override
  State<CompetitionSelector> createState() => _CompetitionSelectorState();
}

class _CompetitionSelectorState extends State<CompetitionSelector> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<Competition> _filteredCompetitions = [];
  bool _isSearching = false;
  Set<int> _selectedCompetitionIds = {};
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_filterCompetitions);
    
    // Initialize selected competitions
    _selectedCompetitionIds = widget.initialSelectedCompetitions.map((c) => c.id).toSet();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.removeListener(_filterCompetitions);
    _searchController.dispose();
    super.dispose();
  }
  
  void _filterCompetitions() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _filteredCompetitions = [];
      });
      return;
    }
    
    setState(() {
      _isSearching = true;
    });
    
    final competitionsProvider = Provider.of<CompetitionsProvider>(context, listen: false);
    competitionsProvider.searchCompetitions(_searchController.text).then((competitions) {
      setState(() {
        _filteredCompetitions = competitions;
      });
    });
  }
  
  void _toggleCompetition(Competition competition) {
    final isSelected = _selectedCompetitionIds.contains(competition.id);
    
    setState(() {
      if (isSelected) {
        _selectedCompetitionIds.remove(competition.id);
      } else {
        _selectedCompetitionIds.add(competition.id);
      }
    });
    
    // Notify parent
    widget.onCompetitionSelected(competition, !isSelected);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search competitions',
              hintText: 'Premier League, La Liga, etc.',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        
        // Tabs
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Popular'),
            Tab(text: 'All'),
          ],
        ),
        
        // Tab content
        Expanded(
          child: _isSearching
              ? _buildSearchResults()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPopularCompetitions(),
                    _buildAllCompetitions(),
                  ],
                ),
        ),
      ],
    );
  }
  
  Widget _buildPopularCompetitions() {
    return Consumer<CompetitionsProvider>(
      builder: (context, competitionsProvider, child) {
        if (competitionsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (competitionsProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${competitionsProvider.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    competitionsProvider.loadCompetitions();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        
        final popularCompetitions = competitionsProvider.popularCompetitions;
        
        if (popularCompetitions.isEmpty) {
          return const Center(
            child: Text('No popular competitions available'),
          );
        }
        
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: popularCompetitions.length,
          itemBuilder: (context, index) {
            final competition = popularCompetitions[index];
            final isSelected = _selectedCompetitionIds.contains(competition.id);
            
            return CompetitionCard(
              competition: competition,
              isFavorite: isSelected,
              onTap: () => _toggleCompetition(competition),
              onFavoriteToggle: () => _toggleCompetition(competition),
            );
          },
        );
      },
    );
  }
  
  Widget _buildAllCompetitions() {
    return Consumer<CompetitionsProvider>(
      builder: (context, competitionsProvider, child) {
        if (competitionsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (competitionsProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${competitionsProvider.errorMessage}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    competitionsProvider.loadCompetitions();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        
        final allCompetitions = competitionsProvider.allCompetitions;
        
        if (allCompetitions.isEmpty) {
          return const Center(
            child: Text('No competitions available'),
          );
        }
        
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: allCompetitions.length,
          itemBuilder: (context, index) {
            final competition = allCompetitions[index];
            final isSelected = _selectedCompetitionIds.contains(competition.id);
            
            return CompetitionCard(
              competition: competition,
              isFavorite: isSelected,
              onTap: () => _toggleCompetition(competition),
              onFavoriteToggle: () => _toggleCompetition(competition),
            );
          },
        );
      },
    );
  }
  
  Widget _buildSearchResults() {
    if (_filteredCompetitions.isEmpty) {
      return const Center(
        child: Text('No competitions found. Try another search term.'),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredCompetitions.length,
      itemBuilder: (context, index) {
        final competition = _filteredCompetitions[index];
        final isSelected = _selectedCompetitionIds.contains(competition.id);
        
        return CompetitionCard(
          competition: competition,
          isFavorite: isSelected,
          onTap: () => _toggleCompetition(competition),
          onFavoriteToggle: () => _toggleCompetition(competition),
        );
      },
    );
  }
}
