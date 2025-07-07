import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class GetTVShowWatchProgress implements UseCase<TVShowWatchProgress, int> {
  final TVShowRepository repository;

  GetTVShowWatchProgress(this.repository);

  @override
  Future<Either<AppError, TVShowWatchProgress>> call(int tvShowId) async {
    return await repository.getTVShowWatchProgress(tvShowId);
  }
}
