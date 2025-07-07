import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/repositories/movie_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class GetFavoriteMovies extends UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;

  GetFavoriteMovies(this.repository);

  @override
  Future<Either<AppError, List<MovieEntity>>> call(NoParams noParams) async {
    return await repository.getFavoriteMovies();
  }
}
