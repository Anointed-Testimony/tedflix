import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:tedflix_app/presentation/blocs/search_movie/search_movie_bloc.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_bloc.dart';
import 'package:tedflix_app/presentation/widgets/app_error_widget.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late SearchMovieBloc _searchMovieBloc;
  late TVShowBloc _tvShowBloc;
  final TextEditingController _searchController = TextEditingController();
  List<MovieEntity> _movies = [];
  List<TVShowEntity> _tvShows = [];
  late TabController _tabController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchMovieBloc = getItInstance<SearchMovieBloc>();
    _tvShowBloc = getItInstance<TVShowBloc>();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchMovieBloc.close();
    _tvShowBloc.close();
    _tabController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      print('Performing search for: $query'); // Debug log
      setState(() {
        _isSearching = true;
        _movies = [];
        _tvShows = [];
      });

      // Trigger both searches
      _searchMovieBloc.add(SearchTermChangedEvent(query));
      _tvShowBloc.add(SearchTVShowsEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search movies and TV shows...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: _performSearch,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _isSearching = false;
                _movies = [];
                _tvShows = [];
              });
            }
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Movies'),
            Tab(text: 'TV Shows'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _searchMovieBloc),
          BlocProvider.value(value: _tvShowBloc),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<SearchMovieBloc, SearchMovieState>(
              listener: (context, state) {
                print('Movie search state: $state'); // Debug log
                if (state is SearchMovieLoaded) {
                  setState(() {
                    _movies = state.movies;
                    _isSearching = false;
                  });
                }
              },
            ),
            BlocListener<TVShowBloc, TVShowState>(
              listener: (context, state) {
                print('TV Show search state: $state'); // Debug log
                if (state is TVShowLoaded) {
                  setState(() {
                    _tvShows = state.tvShows;
                    _isSearching = false;
                  });
                }
              },
            ),
          ],
          child: TabBarView(
            controller: _tabController,
            children: [
              // Movies Tab
              BlocBuilder<SearchMovieBloc, SearchMovieState>(
                builder: (context, state) {
                  if (state is SearchMovieError) {
                    return AppErrorWidget(
                      errorType: state.errorType,
                      onPressed: () => _performSearch(_searchController.text),
                    );
                  }

                  if (_isSearching) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (_movies.isEmpty) {
                    return const Center(
                      child: Text(
                        'No movies found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      final movie = _movies[index];
                      return ListTile(
                        title: Text(
                          movie.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/movie_detail',
                            arguments: movie.id,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              // TV Shows Tab
              BlocBuilder<TVShowBloc, TVShowState>(
                builder: (context, state) {
                  if (state is TVShowError) {
                    return AppErrorWidget(
                      errorType: state.errorType,
                      onPressed: () => _performSearch(_searchController.text),
                    );
                  }

                  if (_isSearching) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (_tvShows.isEmpty) {
                    return const Center(
                      child: Text(
                        'No TV shows found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: _tvShows.length,
                    itemBuilder: (context, index) {
                      final tvShow = _tvShows[index];
                      return ListTile(
                        title: Text(
                          tvShow.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/tv_show_detail',
                            arguments: tvShow.id,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchResult {
  final String title;
  final String type;
  final VoidCallback onTap;

  _SearchResult({
    required this.title,
    required this.type,
    required this.onTap,
  });
}
