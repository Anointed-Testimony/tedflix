import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/common/constants/translation_constants.dart';
import 'package:tedflix_app/common/extensions/string_extensions.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:tedflix_app/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:tedflix_app/presentation/blocs/favorite_tv_show/favorite_tv_show_bloc.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';

import 'favorite_movie_grid_view.dart';
import 'favorite_tv_show_grid_view.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late FavoriteBloc _favoriteBloc;
  late FavoriteTVShowBloc _favoriteTVShowBloc;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = getItInstance<FavoriteBloc>();
    _favoriteTVShowBloc = getItInstance<FavoriteTVShowBloc>();
    _favoriteBloc.add(LoadFavoriteMovieEvent());
    _favoriteTVShowBloc.add(LoadFavoriteTVShowsEvent());
  }

  @override
  void dispose() {
    _favoriteBloc?.close();
    _favoriteTVShowBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF141221).withOpacity(0.7),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _favoriteBloc),
          BlocProvider.value(value: _favoriteTVShowBloc),
        ],
        child: Column(
          children: [
            Expanded(
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, movieState) {
                  return BlocBuilder<FavoriteTVShowBloc, FavoriteTVShowState>(
                    builder: (context, tvShowState) {
                      List<MovieEntity> movies = [];
                      List<TVShowEntity> tvShows = [];

                      if (movieState is FavoriteMoviesLoaded) {
                        movies = movieState.movies;
                      }
                      if (tvShowState is FavoriteTVShowsLoaded) {
                        tvShows = tvShowState.tvShows;
                      }

                      if (movies.isEmpty && tvShows.isEmpty) {
                return Center(
                  child: Text(
                            "No Favorites",
                    textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                  ),
                );
              }

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (movies.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Movies",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              FavoriteMovieGridView(
                key: Key("favorite_movies"),
                                movies: movies,
                              ),
                              SizedBox(height: 20),
                            ],
                            if (tvShows.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "TV Shows",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              FavoriteTVShowGridView(
                                key: Key("favorite_tv_shows"),
                                tvShows: tvShows,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  );
          },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
