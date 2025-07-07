import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/entities/tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class GetAllTVShowWatchProgress
    extends UseCase<List<TVShowWatchProgress>, NoParams> {
  final TVShowRepository repository;

  GetAllTVShowWatchProgress(this.repository);

  @override
  Future<Either<AppError, List<TVShowWatchProgress>>> call(
      NoParams params) async {
    return await repository.getAllTVShowWatchProgress();
  }
}
