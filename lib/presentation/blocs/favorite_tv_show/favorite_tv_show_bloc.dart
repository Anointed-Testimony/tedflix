import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/usecases/check_if_tv_show_favorite.dart';
import 'package:tedflix_app/domain/usecases/delete_favorite_tv_show.dart';
import 'package:tedflix_app/domain/usecases/get_favorite_tv_shows.dart';
import 'package:tedflix_app/domain/usecases/save_tv_show.dart';

part 'favorite_tv_show_event.dart';
part 'favorite_tv_show_state.dart';

class FavoriteTVShowBloc extends Bloc<FavoriteTVShowEvent, FavoriteTVShowState> {
  final SaveTVShow saveTVShow;
  final GetFavoriteTVShows getFavoriteTVShows;
  final DeleteFavoriteTVShow deleteFavoriteTVShow;
  final CheckIfTVShowFavorite checkIfTVShowFavorite;

  FavoriteTVShowBloc({
    required this.saveTVShow,
    required this.getFavoriteTVShows,
    required this.deleteFavoriteTVShow,
    required this.checkIfTVShowFavorite,
  }) : super(FavoriteTVShowInitial()) {
    on<ToggleFavoriteTVShowEvent>((event, emit) async {
      if (event.isFavorite) {
        await deleteFavoriteTVShow(event.tvShowEntity.id);
      } else {
        await saveTVShow(event.tvShowEntity);
      }
      final response = await checkIfTVShowFavorite(event.tvShowEntity.id);
      response.fold(
        (l) => emit(FavoriteTVShowError()),
        (r) => emit(IsFavoriteTVShow(r)),
      );
    });
    on<CheckIfFavoriteTVShowEvent>((event, emit) async {
      final response = await checkIfTVShowFavorite(event.tvShowId);
      response.fold(
        (l) => emit(FavoriteTVShowError()),
        (r) => emit(IsFavoriteTVShow(r)),
      );
    });
    on<LoadFavoriteTVShowsEvent>((event, emit) async {
      final response = await getFavoriteTVShows(NoParams());
      response.fold(
        (l) => emit(FavoriteTVShowError()),
        (r) => emit(FavoriteTVShowsLoaded(r)),
      );
    });
  }
} 