import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/constants/translation_constants.dart';
import 'package:tedflix_app/common/extensions/string_extensions.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/presentation/blocs/search_movie/search_movie_bloc.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_bloc.dart';
import 'package:tedflix_app/presentation/journeys/search_movie/search_movie_card.dart';
import 'package:tedflix_app/presentation/themes/theme_color.dart';
import 'package:tedflix_app/presentation/themes/theme_text.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/presentation/widgets/app_error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tedflix_app/data/core/api_constants.dart';

class CustomSearchDelegate extends SearchDelegate {
  final SearchMovieBloc searchMovieBloc;
  final TVShowBloc tvShowBloc;
  static const String _searchHistoryBoxName = 'search_history';
  static const String _searchHistoryKey = 'history';

  CustomSearchDelegate({
    required this.searchMovieBloc,
    required this.tvShowBloc,
  });

  Future<List<String>> _getSearchHistory() async {
    try {
      final box = await Hive.openBox(_searchHistoryBoxName);
      final history = box.get(_searchHistoryKey, defaultValue: <String>[]) as List<dynamic>;
      return history.cast<String>();
    } catch (e) {
      print('Error loading search history: $e');
      return [];
    }
  }

  Future<void> _saveSearchHistory(String query) async {
    try {
      if (query.trim().isNotEmpty) {
        final box = await Hive.openBox(_searchHistoryBoxName);
        List<String> history = List<String>.from(
          box.get(_searchHistoryKey, defaultValue: <String>[]) ?? []
        );
        
        // Remove if already exists and add to beginning
        history.remove(query.trim());
        history.insert(0, query.trim());
        
        // Keep only last 10 searches
        if (history.length > 10) {
          history = history.take(10).toList();
        }
        
        await box.put(_searchHistoryKey, history);
        print('Search history saved: $history');
      }
    } catch (e) {
      print('Error saving search history: $e');
    }
  }

  Future<void> _clearSearchHistory() async {
    try {
      final box = await Hive.openBox(_searchHistoryBoxName);
      await box.put(_searchHistoryKey, <String>[]);
      print('Search history cleared');
    } catch (e) {
      print('Error clearing search history: $e');
    }
  }

  void _clearSearchState() {
    // Clear search state when search is closed
    searchMovieBloc.add(SearchTermChangedEvent(''));
    tvShowBloc.add(LoadTVShows());
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF0F0F23),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        filled: true,
        fillColor: Color(0xFF1A1A2E).withOpacity(0.8),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: AppColor.royalBlue.withOpacity(0.3),
        selectionHandleColor: Colors.white,
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
        titleLarge: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: query.isEmpty 
              ? LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.2),
                    Colors.grey.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    AppColor.royalBlue.withOpacity(0.4),
                    AppColor.royalBlue.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: query.isEmpty 
                ? Colors.grey.withOpacity(0.3) 
                : AppColor.royalBlue.withOpacity(0.6),
            width: 1.5,
          ),
          boxShadow: query.isEmpty ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ] : [
            BoxShadow(
              color: AppColor.royalBlue.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: query.isEmpty ? null : () => query = '',
            child: Container(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.clear,
                color: query.isEmpty ? Colors.grey : Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            _clearSearchState();
            close(context, null);
          },
          child: Container(
            padding: EdgeInsets.all(12),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      _saveSearchHistory(query);
      searchMovieBloc.add(SearchTermChangedEvent(query));
      tvShowBloc.add(SearchTVShowsEvent(query));
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A2E),
          ],
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Modern Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: TabBar(
                tabs: [
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Movies',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.tv, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'TV Shows',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicator: BoxDecoration(
                  color: AppColor.royalBlue,
                  borderRadius: BorderRadius.circular(25),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  // Movies Tab
                  _buildMoviesTab(),
                  // TV Shows Tab
                  _buildTVShowsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesTab() {
    return BlocBuilder<SearchMovieBloc, SearchMovieState>(
      bloc: searchMovieBloc,
      builder: (context, state) {
        if (state is SearchMovieError) {
          return _buildErrorWidget(
            'Search Error',
            'Failed to search movies',
            () => searchMovieBloc.add(SearchTermChangedEvent(query)),
          );
        } else if (state is SearchMovieLoaded) {
          final movies = state.movies;
          if (movies.isEmpty) {
            return _buildEmptyState(
              Icons.search_off,
              'No Movies Found',
              'Try searching with different keywords',
            );
          }
          return _buildMoviesList(movies);
        } else {
          return _buildLoadingState('Searching movies...');
        }
      },
    );
  }

  Widget _buildTVShowsTab() {
    return BlocBuilder<TVShowBloc, TVShowState>(
      bloc: tvShowBloc,
      builder: (context, state) {
        if (state is TVShowError) {
          return _buildErrorWidget(
            'Search Error',
            'Failed to search TV shows',
            () => tvShowBloc.add(SearchTVShowsEvent(query)),
          );
        } else if (state is TVShowLoaded) {
          final tvShows = state.tvShows;
          if (tvShows.isEmpty) {
            return _buildEmptyState(
              Icons.tv_off,
              'No TV Shows Found',
              'Try searching with different keywords',
            );
          }
          return _buildTVShowsList(tvShows);
        } else {
          return _buildLoadingState('Searching TV shows...');
        }
      },
    );
  }

  Widget _buildMoviesList(List movies) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) => SearchMovieCard(
        key: Key('search_card_$index'),
        movie: movies[index],
      ),
      itemCount: movies.length,
    );
  }

  Widget _buildTVShowsList(List tvShows) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) {
        final tvShow = tvShows[index];
        return _buildTVShowCard(context, tvShow);
      },
      itemCount: tvShows.length,
    );
  }

  Widget _buildTVShowCard(BuildContext context, dynamic tvShow) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/tv_show_detail',
              arguments: tvShow.id,
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Poster
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: '${ApiConstants.BASE_IMAGE_URL}${tvShow.posterPath}',
                      width: 90,
                      height: 135,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 90,
                        height: 135,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.tv,
                          color: Colors.white.withOpacity(0.5),
                          size: 32,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 90,
                        height: 135,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.error,
                          color: Colors.white.withOpacity(0.5),
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tvShow.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        tvShow.overview ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              size: 48,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColor.royalBlue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: CircularProgressIndicator(
              color: AppColor.royalBlue,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String title, String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.royalBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F0F23),
            Color(0xFF1A1A2E),
          ],
        ),
      ),
      child: FutureBuilder<List<String>>(
        future: _getSearchHistory(),
        builder: (context, snapshot) {
          final searchHistory = snapshot.data ?? [];
          
          return Column(
            children: [
              // Search History Section
              if (searchHistory.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.white70,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Recent Searches',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              await _clearSearchHistory();
                              query = '';
                              showResults(context);
                            },
                            icon: Icon(Icons.clear_all, size: 16),
                            label: Text('Clear All'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: searchHistory.map((searchTerm) {
                          return GestureDetector(
                            onTap: () {
                              query = searchTerm;
                              showResults(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    searchTerm,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              
              // Default search suggestions
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.search,
                          size: 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Search for movies and TV shows",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Type to start searching...",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void close(BuildContext context, result) {
    _clearSearchState();
    super.close(context, result);
  }
}
