import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class SearchTVShows extends UseCase<List<TVShowEntity>, String> {
  final TVShowRepository repository;

  SearchTVShows(this.repository);

  @override
  Future<Either<AppError, List<TVShowEntity>>> call(String searchTerm) async {
    return await repository.getSearchedTVShows(searchTerm);
  }
}
