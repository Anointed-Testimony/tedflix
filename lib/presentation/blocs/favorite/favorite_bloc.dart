import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/movie_params.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/usecases/check_if_movie_favorite.dart';
import 'package:tedflix_app/domain/usecases/delete_favorite_movie.dart';
import 'package:tedflix_app/domain/usecases/get_favorite_movies.dart';
import 'package:tedflix_app/domain/usecases/save_movie.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final SaveMovie saveMovie;
  final GetFavoriteMovies getFavoriteMovies;
  final DeleteFavoriteMovie deleteFavoriteMovie;
  final CheckIfFavoriteMovie checkIfFavoriteMovie;

  FavoriteBloc({
    required this.saveMovie,
    required this.getFavoriteMovies,
    required this.deleteFavoriteMovie,
    required this.checkIfFavoriteMovie,
  }) : super(FavoriteInitial()) {
    // Event handler for ToggleFavoriteMovieEvent
    on<ToggleFavoriteMovieEvent>((event, emit) async {
      if (event.isFavorite) {
        await deleteFavoriteMovie(MovieParams(event.movieEntity.id));
      } else {
        await saveMovie(event.movieEntity);
      }

      final response =
          await checkIfFavoriteMovie(MovieParams(event.movieEntity.id));
      response.fold(
        (l) => emit(FavoriteMoviesError()),
        (r) => emit(IsFavoriteMovie(r)),
      );
    });

    // Event handler for LoadFavoriteMovieEvent
    on<LoadFavoriteMovieEvent>((event, emit) async {
      await _fetchLoadFavoriteMovies(emit);
    });

    // Event handler for DeleteFavoriteMovieEvent
    on<DeleteFavoriteMovieEvent>((event, emit) async {
      await deleteFavoriteMovie(MovieParams(event.movieId));
      await _fetchLoadFavoriteMovies(emit);
    });

    // Event handler for CheckIfFavoriteMovieEvent
    on<CheckIfFavoriteMovieEvent>((event, emit) async {
      final response = await checkIfFavoriteMovie(MovieParams(event.movieId));
      response.fold(
        (l) => emit(FavoriteMoviesError()),
        (r) => emit(IsFavoriteMovie(r)),
      );
    });
  }

  // Helper function for loading favorite movies
  Future<void> _fetchLoadFavoriteMovies(Emitter<FavoriteState> emit) async {
    final Either<AppError, List<MovieEntity>> response =
        await getFavoriteMovies(NoParams());

    response.fold(
      (l) => emit(FavoriteMoviesError()),
      (r) => emit(FavoriteMoviesLoaded(r)),
    );
  }
}
