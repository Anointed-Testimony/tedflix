import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/usecases/get_favorite_movies.dart';

// Events
abstract class FavoriteMovieEvent {}

class LoadFavoriteMovies extends FavoriteMovieEvent {}

// States
abstract class FavoriteMovieState {}

class FavoriteMovieInitial extends FavoriteMovieState {}

class FavoriteMovieLoading extends FavoriteMovieState {}

class FavoriteMovieLoaded extends FavoriteMovieState {
  final List<MovieEntity> movies;

  FavoriteMovieLoaded(this.movies);
}

class FavoriteMovieError extends FavoriteMovieState {
  final AppErrorType errorType;

  FavoriteMovieError(this.errorType);
}

// Bloc
class FavoriteMovieBloc extends Bloc<FavoriteMovieEvent, FavoriteMovieState> {
  final GetFavoriteMovies getFavoriteMovies;

  FavoriteMovieBloc({
    required this.getFavoriteMovies,
  }) : super(FavoriteMovieInitial()) {
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
  }

  Future<void> _onLoadFavoriteMovies(
    LoadFavoriteMovies event,
    Emitter<FavoriteMovieState> emit,
  ) async {
    emit(FavoriteMovieLoading());
    final result = await getFavoriteMovies(NoParams());
    result.fold(
      (error) => emit(FavoriteMovieError(error.appErrorType)),
      (movies) => emit(FavoriteMovieLoaded(movies)),
    );
  }
}
