import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';

part 'movie_backdrop_event.dart';
part 'movie_backdrop_state.dart';

class MovieBackdropBloc extends Bloc<MovieBackdropEvent, MovieBackdropState> {
  MovieBackdropBloc() : super(MovieBackdropInitial()) {
    // Register the event handler for MovieBackdropChangedEvent
    on<MovieBackdropChangedEvent>(_onMovieBackdropChangedEvent);
  }

  // Event handler method
  FutureOr<void> _onMovieBackdropChangedEvent(
    MovieBackdropChangedEvent event,
    Emitter<MovieBackdropState> emit,
  ) {
    try {
      print('Event received: $event'); // Log the event
      emit(MovieBackdropChanged(event.movie));
    } catch (error, stackTrace) {
      print('Error occurred in _onMovieBackdropChangedEvent: $error');
      print('Stack trace: $stackTrace');
    }
  }
}
