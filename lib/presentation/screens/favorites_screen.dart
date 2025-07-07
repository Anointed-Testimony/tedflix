import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_watch_progress/tv_show_watch_progress_bloc.dart';
import 'package:tedflix_app/presentation/widgets/app_error_widget.dart';
import 'package:tedflix_app/data/tables/tv_show_table.dart';
import 'package:tedflix_app/data/data_sources/tv_show_local_data_source.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoriteBloc _favoriteBloc;
  late TVShowWatchProgressBloc _tvShowWatchProgressBloc;
  late TVShowLocalDataSource _tvShowLocalDataSource;
  Map<int, String> _tvShowNames = {};

  @override
  void initState() {
    super.initState();
    _favoriteBloc = getItInstance<FavoriteBloc>();
    _tvShowWatchProgressBloc = getItInstance<TVShowWatchProgressBloc>();
    _tvShowLocalDataSource = getItInstance<TVShowLocalDataSource>();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favoriteBloc.add(LoadFavoriteMovieEvent());
    _tvShowWatchProgressBloc.add(GetAllWatchProgress());

    // Load TV show names
    final tvShows = await _tvShowLocalDataSource.getTVShows();
    _tvShowNames = {
      for (var tvShow in tvShows) tvShow.id: tvShow.name,
    };
    setState(() {});
  }

  @override
  void dispose() {
    _favoriteBloc.close();
    _tvShowWatchProgressBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Shows'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Movies Tab
            BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state is FavoriteMoviesError) {
                  return AppErrorWidget(
                    errorType: AppErrorType.api,
                    onPressed: _loadFavorites,
                  );
                } else if (state is FavoriteMoviesLoaded) {
                  if (state.movies.isEmpty) {
                    return const Center(
                      child: Text('No favorite movies yet'),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return ListTile(
                        title: Text(movie.title),
                        subtitle: Text(movie.releaseDate),
                        onTap: () {
                          // Navigate to movie detail
                        },
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
            // TV Shows Tab
            BlocBuilder<TVShowWatchProgressBloc, TVShowWatchProgressState>(
              builder: (context, state) {
                if (state is TVShowWatchProgressError) {
                  return AppErrorWidget(
                    errorType: state.errorType,
                    onPressed: _loadFavorites,
                  );
                } else if (state is TVShowWatchProgressListLoaded) {
                  if (state.progressList.isEmpty) {
                    return const Center(
                      child: Text('No favorite TV shows yet'),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.progressList.length,
                    itemBuilder: (context, index) {
                      final progress = state.progressList[index];
                      return ListTile(
                        title: Text(_tvShowNames[progress.tvShowId] ??
                            'Unknown TV Show'),
                        subtitle: Text(
                          'Season ${progress.seasonNumber}, Episode ${progress.episodeNumber}',
                        ),
                        onTap: () {
                          // Navigate to TV show detail
                        },
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
