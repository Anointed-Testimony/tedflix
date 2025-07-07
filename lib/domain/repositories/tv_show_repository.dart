import 'package:dartz/dartz.dart';
import 'package:tedflix_app/data/models/tv_show_detail_model.dart';
import 'package:tedflix_app/data/models/tv_show_model.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/domain/entities/cast_entity.dart';
import 'package:tedflix_app/data/tables/tv_show_watch_progress_table.dart';
import 'package:tedflix_app/domain/entities/tv_show_detail_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/entities/season_entity.dart';

abstract class TVShowRepository {
  // TV Show List Methods
  Future<Either<AppError, List<TVShowEntity>>> getPopularTVShows();
  Future<Either<AppError, List<TVShowEntity>>> getAiringToday();
  Future<Either<AppError, List<TVShowEntity>>> getOnTheAir();
  Future<Either<AppError, List<TVShowEntity>>> getTopRated();
  Future<Either<AppError, List<TVShowEntity>>> getSearchedTVShows(String query);

  // TV Show Detail Methods
  Future<Either<AppError, TVShowDetailEntity>> getTVShowDetail(int id);
  Future<Either<AppError, List<CastEntity>>> getTVShowCast(int tvShowId);
  Future<Either<AppError, SeasonEntity>> getSeasonDetail(
      int tvShowId, int seasonNumber);

  // Favorite Methods
  Future<Either<AppError, bool>> checkIfTVShowFavorite(int tvShowId);
  Future<Either<AppError, void>> deleteFavoriteTVShow(int tvShowId);
  Future<Either<AppError, List<TVShowEntity>>> getFavoriteTVShows();
  Future<Either<AppError, void>> saveTVShow(TVShowEntity tvShowEntity);

  // Watch Progress Methods
  Future<Either<AppError, void>> saveTVShowWatchProgress(
      TVShowWatchProgress progress);
  Future<Either<AppError, TVShowWatchProgress>> getTVShowWatchProgress(
      int tvShowId);
  Future<Either<AppError, List<TVShowWatchProgress>>>
      getAllTVShowWatchProgress();
  Future<Either<AppError, void>> deleteTVShowWatchProgress(int tvShowId);
}
