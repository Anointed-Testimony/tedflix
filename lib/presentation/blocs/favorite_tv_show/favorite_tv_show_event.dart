part of 'favorite_tv_show_bloc.dart';

abstract class FavoriteTVShowEvent extends Equatable {
  const FavoriteTVShowEvent();

  @override
  List<Object> get props => [];
}

class ToggleFavoriteTVShowEvent extends FavoriteTVShowEvent {
  final TVShowEntity tvShowEntity;
  final bool isFavorite;

  const ToggleFavoriteTVShowEvent({
    required this.tvShowEntity,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [tvShowEntity, isFavorite];
}

class CheckIfFavoriteTVShowEvent extends FavoriteTVShowEvent {
  final int tvShowId;

  const CheckIfFavoriteTVShowEvent({required this.tvShowId});

  @override
  List<Object> get props => [tvShowId];
}

class LoadFavoriteTVShowsEvent extends FavoriteTVShowEvent {} 