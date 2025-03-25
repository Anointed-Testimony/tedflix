import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/movie_detail_entity.dart';
import 'package:tedflix_app/domain/entities/movie_params.dart';
import 'package:tedflix_app/domain/usecases/get_movie_detail.dart';
import 'package:tedflix_app/presentation/blocs/cast/cast_bloc.dart';
import 'package:tedflix_app/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:tedflix_app/presentation/blocs/loading/loading_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final CastBloc castBloc;
  final FavoriteBloc favoriteBloc;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.castBloc,
    required this.favoriteBloc,
  }) : super(MovieDetailInitial()) {
    on<MovieDetailLoadEvent>(_onMovieDetailLoadEvent);
  }

  Future<void> _onMovieDetailLoadEvent(
    MovieDetailLoadEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());

    final Either<AppError, MovieDetailEntity> eitherResponse =
        await getMovieDetail(MovieParams(event.movieId));

    eitherResponse.fold(
      (error) => emit(MovieDetailError()),
      (movieDetail) {
        emit(MovieDetailLoaded(movieDetail));
        favoriteBloc.add(CheckIfFavoriteMovieEvent(event.movieId));
        // Dispatch event to castBloc after movie details are loaded
        castBloc.add(LoadCastEvent(movieId: event.movieId));
      },
    );
  }
}