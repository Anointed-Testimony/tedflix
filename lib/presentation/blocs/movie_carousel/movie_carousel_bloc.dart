import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/usecases/get_trending.dart';
import 'package:tedflix_app/presentation/blocs/loading/loading_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';

part 'movie_carousel_event.dart';
part 'movie_carousel_state.dart';

class MovieCarouselBloc extends Bloc<MovieCarouselEvent, MovieCarouselState> {
  final GetTrending getTrending;
  final MovieBackdropBloc movieBackdropBloc;

  MovieCarouselBloc({
    required this.getTrending,
    required this.movieBackdropBloc,
  }) : super(MovieCarouselInitial()) {
    on<CarouselLoadEvent>(_onCarouselLoadEvent);
  }

  FutureOr<void> _onCarouselLoadEvent(
    CarouselLoadEvent event,
    Emitter<MovieCarouselState> emit,
  ) async {
    final moviesEither = await getTrending(NoParams());
    moviesEither.fold(
      (l) => emit(MovieCarouselError(errorType: l.appErrorType)),
      (movies) {
        movieBackdropBloc.add(MovieBackdropChangedEvent(movies[event.defaultIndex]));
        emit(MovieCarouselLoaded(
          movies: movies,
          defaultIndex: event.defaultIndex,
        ));
      },
    );
  }
}
