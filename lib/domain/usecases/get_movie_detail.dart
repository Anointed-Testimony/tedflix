import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/movie_detail_entity.dart';
import 'package:tedflix_app/domain/entities/movie_params.dart';
import 'package:tedflix_app/domain/repositories/movie_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class GetMovieDetail extends UseCase<MovieDetailEntity, MovieParams> {
  final MovieRepository repository;

  GetMovieDetail(this.repository);

  @override
  Future<Either<AppError, MovieDetailEntity>> call(
      MovieParams movieParams) async {
    return await repository.getMovieDetail(movieParams.id);
  }
}
