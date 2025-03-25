import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/repositories/movie_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class SaveMovie extends Usecase<void, MovieEntity> {
  final MovieRepository movieRepository;

  SaveMovie(this.movieRepository);

  @override
  Future<Either<AppError, void>> call(MovieEntity params) async {
    return await movieRepository.saveMovie(params);
  }
}
