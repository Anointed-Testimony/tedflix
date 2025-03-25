import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/movie_search_params.dart';
import 'package:tedflix_app/domain/usecases/search_movies.dart';
import 'package:tedflix_app/presentation/blocs/loading/loading_bloc.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies searchMovies;

  SearchMovieBloc({
    required this.searchMovies,
  }) : super(SearchMovieInitial()) {
    on<SearchTermChangedEvent>(_onSearchTermChanged);
  }

  FutureOr<void> _onSearchTermChanged(
    SearchTermChangedEvent event,
    Emitter<SearchMovieState> emit,
  ) async {
    if (event.searchTerm.length > 2) {
      emit(SearchMovieLoading());
      final Either<AppError, List<MovieEntity>> response =
          await searchMovies(MovieSearchParams(searchTerm: event.searchTerm));

      // Add this to check the response
      response.fold(
        (l) => print("Error: $l"),  // Log error response
        (r) => print("Movies found: ${r.length}"),  // Log the movie count
      );

      emit(response.fold(
        (l) => SearchMovieError(l.appErrorType),
        (r) => SearchMovieLoaded(r),
      ));
    }
  }

}