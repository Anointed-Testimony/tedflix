import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class SaveTVShowWatchProgress extends UseCase<void, TVShowWatchProgress> {
  final TVShowRepository repository;

  SaveTVShowWatchProgress(this.repository);

  @override
  Future<Either<AppError, void>> call(TVShowWatchProgress params) async {
    return await repository.saveTVShowWatchProgress(params);
  }
}
