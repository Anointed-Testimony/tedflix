import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/common/constants/translation_constants.dart';
import 'package:tedflix_app/common/extensions/string_extensions.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:tedflix_app/presentation/blocs/favorite/favorite_bloc.dart';

import 'favorite_movie_grid_view.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late FavoriteBloc _favoriteBloc;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = getItInstance<FavoriteBloc>();
    _favoriteBloc.add(LoadFavoriteMovieEvent());
  }

  @override
  void dispose() {
    _favoriteBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite Movies",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF141221).withOpacity(0.7),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocProvider.value(
        value: _favoriteBloc,
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteMoviesLoaded) {
              if (state.movies.isEmpty) {
                return Center(
                  child: Text(
                    "No Favorite Movie",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }
              return FavoriteMovieGridView(
                key: Key("favorite_movies"),
                movies: state.movies,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
