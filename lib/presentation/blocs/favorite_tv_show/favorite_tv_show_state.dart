part of 'favorite_tv_show_bloc.dart';

abstract class FavoriteTVShowState extends Equatable {
  const FavoriteTVShowState();

  @override
  List<Object> get props => [];
}

class FavoriteTVShowInitial extends FavoriteTVShowState {}

class IsFavoriteTVShow extends FavoriteTVShowState {
  final bool isFavorite;

  const IsFavoriteTVShow(this.isFavorite);

  @override
  List<Object> get props => [isFavorite];
}

class FavoriteTVShowsLoaded extends FavoriteTVShowState {
  final List<TVShowEntity> tvShows;

  const FavoriteTVShowsLoaded(this.tvShows);

  @override
  List<Object> get props => [tvShows];
}

class FavoriteTVShowError extends FavoriteTVShowState {} 