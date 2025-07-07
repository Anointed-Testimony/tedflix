part of 'movie_tabbed_bloc.dart';

abstract class MovieTabbedState extends Equatable {
  final int currentTabIndex;

  const MovieTabbedState({required this.currentTabIndex});

  @override
  List<Object> get props => [currentTabIndex];
}

class MovieTabbedInitial extends MovieTabbedState {
  const MovieTabbedInitial() : super(currentTabIndex: 0);
}

class MovieTabLoading extends MovieTabbedState {
  const MovieTabLoading({required int currentTabIndex})
      : super(currentTabIndex: currentTabIndex);
}

class MovieTabChanged extends MovieTabbedState {
  final List<MovieEntity> movies;
  final List<TVShowEntity> tvShows;

  const MovieTabChanged({
    required int currentTabIndex,
    this.movies = const [],
    this.tvShows = const [],
  }) : super(currentTabIndex: currentTabIndex);

  @override
  List<Object> get props => [currentTabIndex, movies, tvShows];
}

class MovieTabLoadError extends MovieTabbedState {
  final AppErrorType errorType;

  const MovieTabLoadError({
    required int currentTabIndex,
    required this.errorType,
  }) : super(currentTabIndex: currentTabIndex);

  @override
  List<Object> get props => [currentTabIndex, errorType];
}
