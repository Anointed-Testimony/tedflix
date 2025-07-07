import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../domain/entities/app_error.dart';
import '../../../domain/entities/movie_entity.dart';
import '../../../domain/entities/tv_show_entity.dart';
import '../../../domain/entities/no_params.dart';
import '../../../domain/usecases/get_coming_soon.dart';
import '../../../domain/usecases/get_playing_now.dart';
import '../../../domain/usecases/get_popular.dart';
import '../../../domain/usecases/get_popular_tv_shows.dart';
import '../../../domain/usecases/get_airing_today.dart';
import '../../../domain/usecases/get_on_the_air.dart';

part 'movie_tabbed_event.dart';
part 'movie_tabbed_state.dart';

class MovieTabbedBloc extends Bloc<MovieTabbedEvent, MovieTabbedState> {
  final GetPopular getPopular;
  final GetPlayingNow getNowPlaying;
  final GetComingSoon getComingSoon;
  final GetPopularTVShows getPopularTVShows;
  final GetAiringToday getAiringToday;
  final GetOnTheAir getOnTheAir;

  MovieTabbedBloc({
    required this.getPopular,
    required this.getNowPlaying,
    required this.getComingSoon,
    required this.getPopularTVShows,
    required this.getAiringToday,
    required this.getOnTheAir,
  }) : super(MovieTabbedInitial()) {
    // Registering event handlers
    on<MovieTabChangedEvent>(_onMovieTabChangedEvent);
  }

  // Event handler for MovieTabChangedEvent
  Future<void> _onMovieTabChangedEvent(
    MovieTabChangedEvent event,
    Emitter<MovieTabbedState> emit,
  ) async {
    debugPrint(
        'MovieTabbedBloc: Tab changed to index ${event.currentTabIndex}');
    emit(MovieTabLoading(currentTabIndex: event.currentTabIndex));

    try {
      switch (event.currentTabIndex) {
        case 0: // Popular Movies
          debugPrint('MovieTabbedBloc: Fetching popular movies');
          final moviesEither = await getPopular(NoParams());
          moviesEither.fold(
            (l) {
              debugPrint(
                  'MovieTabbedBloc: Error fetching popular movies - ${l.appErrorType}');
              emit(MovieTabLoadError(
                currentTabIndex: event.currentTabIndex,
                errorType: l.appErrorType,
              ));
            },
            (movies) {
              debugPrint(
                  'MovieTabbedBloc: Successfully fetched ${movies.length} popular movies');
              emit(MovieTabChanged(
                currentTabIndex: event.currentTabIndex,
                movies: movies,
                tvShows: const [],
              ));
            },
          );
          break;
        case 1: // Now Playing
          debugPrint('MovieTabbedBloc: Fetching now playing movies');
          final moviesEither = await getNowPlaying(NoParams());
          moviesEither.fold(
            (l) {
              debugPrint(
                  'MovieTabbedBloc: Error fetching now playing movies - ${l.appErrorType}');
              emit(MovieTabLoadError(
                currentTabIndex: event.currentTabIndex,
                errorType: l.appErrorType,
              ));
            },
            (movies) {
              debugPrint(
                  'MovieTabbedBloc: Successfully fetched ${movies.length} now playing movies');
              emit(MovieTabChanged(
                currentTabIndex: event.currentTabIndex,
                movies: movies,
                tvShows: const [],
              ));
            },
          );
          break;
        case 2: // Coming Soon
          debugPrint('MovieTabbedBloc: Fetching coming soon movies');
          final moviesEither = await getComingSoon(NoParams());
          moviesEither.fold(
            (l) {
              debugPrint(
                  'MovieTabbedBloc: Error fetching coming soon movies - ${l.appErrorType}');
              emit(MovieTabLoadError(
                currentTabIndex: event.currentTabIndex,
                errorType: l.appErrorType,
              ));
            },
            (movies) {
              debugPrint(
                  'MovieTabbedBloc: Successfully fetched ${movies.length} coming soon movies');
              emit(MovieTabChanged(
                currentTabIndex: event.currentTabIndex,
                movies: movies,
                tvShows: const [],
              ));
            },
          );
          break;
        case 3: // Popular TV Shows
          debugPrint('MovieTabbedBloc: Fetching popular TV shows');
          final tvShowsEither = await getPopularTVShows(NoParams());
          tvShowsEither.fold(
            (l) {
              debugPrint(
                  'MovieTabbedBloc: Error fetching popular TV shows - ${l.appErrorType}');
              emit(MovieTabLoadError(
                currentTabIndex: event.currentTabIndex,
                errorType: l.appErrorType,
              ));
            },
            (tvShows) {
              debugPrint(
                  'MovieTabbedBloc: Successfully fetched ${tvShows.length} popular TV shows');
              emit(MovieTabChanged(
                currentTabIndex: event.currentTabIndex,
                movies: const [],
                tvShows: tvShows,
              ));
            },
          );
          break;
        case 4: // Airing Today
          debugPrint('MovieTabbedBloc: Fetching airing today TV shows');
          final tvShowsEither = await getAiringToday(NoParams());
          tvShowsEither.fold(
            (l) {
              debugPrint(
                  'MovieTabbedBloc: Error fetching airing today TV shows - ${l.appErrorType}');
              emit(MovieTabLoadError(
                currentTabIndex: event.currentTabIndex,
                errorType: l.appErrorType,
              ));
            },
            (tvShows) {
              debugPrint(
                  'MovieTabbedBloc: Successfully fetched ${tvShows.length} airing today TV shows');
              emit(MovieTabChanged(
                currentTabIndex: event.currentTabIndex,
                movies: const [],
                tvShows: tvShows,
              ));
            },
          );
          break;
        case 5: // On The Air
          debugPrint('MovieTabbedBloc: Fetching on the air TV shows');
          final tvShowsEither = await getOnTheAir(NoParams());
          tvShowsEither.fold(
            (l) {
              debugPrint(
                  'MovieTabbedBloc: Error fetching on the air TV shows - ${l.appErrorType}');
              emit(MovieTabLoadError(
                currentTabIndex: event.currentTabIndex,
                errorType: l.appErrorType,
              ));
            },
            (tvShows) {
              debugPrint(
                  'MovieTabbedBloc: Successfully fetched ${tvShows.length} on the air TV shows');
              emit(MovieTabChanged(
                currentTabIndex: event.currentTabIndex,
                movies: const [],
                tvShows: tvShows,
              ));
            },
          );
          break;
        default:
          debugPrint(
              'MovieTabbedBloc: Invalid tab index ${event.currentTabIndex}');
          emit(MovieTabLoadError(
            currentTabIndex: event.currentTabIndex,
            errorType: AppErrorType.api,
          ));
      }
    } catch (e, stackTrace) {
      debugPrint('MovieTabbedBloc: Unexpected error occurred');
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      emit(MovieTabLoadError(
        currentTabIndex: event.currentTabIndex,
        errorType: AppErrorType.api,
      ));
    }
  }
}
