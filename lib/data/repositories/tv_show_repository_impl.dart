import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tedflix_app/data/data_sources/tv_show_local_data_source.dart';
import 'package:tedflix_app/data/data_sources/tv_show_remote_data_source.dart';
import 'package:tedflix_app/data/models/tv_show_detail_model.dart';
import 'package:tedflix_app/data/models/tv_show_model.dart';
import 'package:tedflix_app/data/tables/tv_show_table.dart';
import 'package:tedflix_app/data/tables/tv_show_watch_progress_table.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/domain/entities/cast_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_detail_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/entities/season_entity.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';

class TVShowRepositoryImpl implements TVShowRepository {
  final TVShowRemoteDataSource remoteDataSource;
  final TVShowLocalDataSource localDataSource;

  TVShowRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<AppError, List<TVShowEntity>>> getPopularTVShows() async {
    try {
      final tvShows = await remoteDataSource.getPopularTVShows();
      return Right(tvShows);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<TVShowEntity>>> getOnTheAir() async {
    try {
      final tvShows = await remoteDataSource.getOnTheAir();
      return Right(tvShows);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<TVShowEntity>>> getAiringToday() async {
    try {
      final tvShows = await remoteDataSource.getAiringToday();
      return Right(tvShows);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<TVShowEntity>>> getTopRated() async {
    try {
      final tvShows = await remoteDataSource.getTopRated();
      return Right(tvShows);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.network));
    }
  }

  @override
  Future<Either<AppError, TVShowDetailEntity>> getTVShowDetail(
      int tvShowId) async {
    try {
      final tvShowDetail = await remoteDataSource.getTVShowDetail(tvShowId);
      return Right(tvShowDetail);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, List<TVShowEntity>>> getSearchedTVShows(
      String searchTerm) async {
    try {
      final tvShows = await remoteDataSource.searchTVShows(searchTerm);
      return Right(tvShows);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, bool>> checkIfTVShowFavorite(int tvShowId) async {
    try {
      final response = await localDataSource.checkIfTVShowFavorite(tvShowId);
      return Right(response);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> deleteFavoriteTVShow(int tvShowId) async {
    try {
      final response = await localDataSource.deleteTVShow(tvShowId);
      return Right(response);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, List<TVShowEntity>>> getFavoriteTVShows() async {
    try {
      final response = await localDataSource.getTVShows();
      return Right(response);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveTVShow(TVShowEntity tvShowEntity) async {
    try {
      final table = TVShowTable.fromTVShowEntity(tvShowEntity);
      final response = await localDataSource.saveTVShow(table);
      return Right(response);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, List<CastEntity>>> getTVShowCast(int tvShowId) async {
    try {
      final cast = await remoteDataSource.getTVShowCast(tvShowId);
      return Right(cast);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, void>> saveTVShowWatchProgress(
      TVShowWatchProgress progress) async {
    try {
      final table = TVShowWatchProgressTable.fromEntity(progress);
      await localDataSource.saveWatchProgress(table);
      return const Right(null);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, TVShowWatchProgress>> getTVShowWatchProgress(
      int tvShowId) async {
    try {
      final progress = await localDataSource.getWatchProgress(tvShowId, 1, 1);
      if (progress == null) {
        return Left(AppError(AppErrorType.database));
      }
      return Right(progress.toEntity());
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, List<TVShowWatchProgress>>>
      getAllTVShowWatchProgress() async {
    try {
      final progress = await localDataSource.getAllWatchProgress();
      return Right(progress.map((p) => p.toEntity()).toList());
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> deleteTVShowWatchProgress(int tvShowId) async {
    try {
      await localDataSource.deleteWatchProgress(tvShowId, 1, 1);
      return const Right(null);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, SeasonEntity>> getSeasonDetail(
      int tvShowId, int seasonNumber) async {
    try {
      final seasonDetail =
          await remoteDataSource.getSeasonDetail(tvShowId, seasonNumber);
      return Right(seasonDetail);
    } on Exception {
      return const Left(AppError(AppErrorType.api));
    }
  }
}
