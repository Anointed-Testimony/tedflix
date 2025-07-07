import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class DeleteFavoriteTVShow extends UseCase<void, int> {
  final TVShowRepository tvShowRepository;

  DeleteFavoriteTVShow(this.tvShowRepository);

  @override
  Future<Either<AppError, void>> call(int tvShowId) async {
    return await tvShowRepository.deleteFavoriteTVShow(tvShowId);
  }
} 