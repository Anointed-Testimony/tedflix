import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class DeleteTVShowWatchProgress extends UseCase<void, int> {
  final TVShowRepository repository;

  DeleteTVShowWatchProgress(this.repository);

  @override
  Future<Either<AppError, void>> call(int tvShowId) async {
    return await repository.deleteTVShowWatchProgress(tvShowId);
  }
}
