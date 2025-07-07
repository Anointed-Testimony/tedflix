import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/entities/movie_search_params.dart';
import 'package:tedflix_app/domain/usecases/get_popular_tv_shows.dart';
import 'package:tedflix_app/domain/usecases/search_tv_shows.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';

// Events
abstract class TVShowEvent extends Equatable {
  const TVShowEvent();

  @override
  List<Object> get props => [];
}

class LoadTVShows extends TVShowEvent {}

class SearchTVShowsEvent extends TVShowEvent {
  final String query;

  const SearchTVShowsEvent(this.query);

  @override
  List<Object> get props => [query];
}

// States
abstract class TVShowState extends Equatable {
  const TVShowState();

  @override
  List<Object> get props => [];
}

class TVShowInitial extends TVShowState {}

class TVShowLoading extends TVShowState {}

class TVShowLoaded extends TVShowState {
  final List<TVShowEntity> tvShows;

  const TVShowLoaded(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

class TVShowError extends TVShowState {
  final AppErrorType errorType;

  const TVShowError(this.errorType);

  @override
  List<Object> get props => [errorType];
}

// Bloc
class TVShowBloc extends Bloc<TVShowEvent, TVShowState> {
  final GetPopularTVShows getPopularTVShows;
  final SearchTVShows searchTVShows;

  TVShowBloc({
    required this.getPopularTVShows,
    required this.searchTVShows,
  }) : super(TVShowInitial()) {
    on<LoadTVShows>(_onLoadTVShows);
    on<SearchTVShowsEvent>(_onSearchTVShows);
  }

  Future<void> _onLoadTVShows(
    LoadTVShows event,
    Emitter<TVShowState> emit,
  ) async {
    emit(TVShowLoading());
    final result = await getPopularTVShows(NoParams());
    result.fold(
      (failure) => emit(TVShowError(failure.appErrorType)),
      (tvShows) => emit(TVShowLoaded(tvShows)),
    );
  }

  Future<void> _onSearchTVShows(
    SearchTVShowsEvent event,
    Emitter<TVShowState> emit,
  ) async {
    emit(TVShowLoading());
    final result = await searchTVShows(event.query);
    result.fold(
      (failure) => emit(TVShowError(failure.appErrorType)),
      (tvShows) => emit(TVShowLoaded(tvShows)),
    );
  }
}
