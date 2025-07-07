import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class CheckIfTVShowFavorite extends UseCase<bool, int> {
  final TVShowRepository tvShowRepository;

  CheckIfTVShowFavorite(this.tvShowRepository);

  @override
  Future<Either<AppError, bool>> call(int tvShowId) async {
    return await tvShowRepository.checkIfTVShowFavorite(tvShowId);
  }
} 