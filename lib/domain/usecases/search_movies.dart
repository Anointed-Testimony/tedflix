import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/movie_search_params.dart';
import 'package:tedflix_app/domain/repositories/movie_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class SearchMovies extends Usecase<List<MovieEntity>, MovieSearchParams> {
  final MovieRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<AppError, List<MovieEntity>>> call(
      MovieSearchParams searchParams) async {
    return await repository.getSearchedMovies(searchParams.searchTerm);
  }
}
