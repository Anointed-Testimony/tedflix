import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:tedflix_app/data/data_sources/movie_local_data_source.dart';
import 'package:tedflix_app/data/data_sources/movie_remote_data_source.dart';
import 'package:tedflix_app/data/models/cast_crew_result_data_model.dart';
import 'package:tedflix_app/data/models/movie_detail_model.dart';
import 'package:tedflix_app/data/models/movie_model.dart';
import 'package:tedflix_app/data/tables/movie_table.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/cast_entity.dart';
import 'package:tedflix_app/domain/entities/movie_detail_entity.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl extends MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  MovieRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<AppError, List<MovieModel>>> getTrending() async {
    try {
      final movies = await remoteDataSource.getTrending();
      return Right(movies);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.network));
    }
  }

  @override
  Future<Either<AppError, List<MovieEntity>>> getComingSoon() async {
    try {
      final movies = await remoteDataSource.getComingSoon();
      return Right(movies);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.network));
    }
  }

  @override
  Future<Either<AppError, List<MovieEntity>>> getPlayingNow() async {
    try {
      final movies = await remoteDataSource.getPlayingNow();
      return Right(movies);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.network));
    }
  }

  @override
  Future<Either<AppError, List<MovieEntity>>> getPopular() async {
    try {
      final movies = await remoteDataSource.getPopular();
      return Right(movies);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.network));
    }
  }

  @override
  Future<Either<AppError, MovieDetailModel>> getMovieDetail(int id) async {
    try {
      final movie = await remoteDataSource
          .getMovieDetail(id); // Ensure correct id is passed
      return Right(movie);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.network));
    }
  }

  @override
  Future<Either<AppError, List<CastModel>>> getCastCrew(int id) async {
    try {
      final castCrew =
          await remoteDataSource.getCastCrew(id); // Ensure correct id is passed
      return Right(castCrew);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.network));
    }
  }

  @override
  Future<Either<AppError, List<MovieModel>>> getSearchedMovies(
      String searchTerm) async {
    try {
      final movies = await remoteDataSource.getSearchedMovies(searchTerm);
      return Right(movies);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on Exception {
      return Left(AppError(AppErrorType.network));
    }
  }

  @override
  Future<Either<AppError, bool>> checkIfMovieFavorite(int movieId) async {
    try {
      final response = await localDataSource.checkIfMovieFavorite(movieId);
      return Right(response);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> deleteFavoriteMovie(int movieId) async {
    try {
      final response = await localDataSource.deleteMovie(movieId);
      return Right(response);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, List<MovieEntity>>> getFavoriteMovies() async {
    try {
      final response = await localDataSource.getMovies();
      return Right(response);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, void>> saveMovie(MovieEntity movieEntity) async {
    try {
      final table = MovieTable.fromMovieEntity(movieEntity);
      print(table);
      final response = await localDataSource
          .saveMovie(MovieTable.fromMovieEntity(movieEntity));
      return Right(response);
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }
}
