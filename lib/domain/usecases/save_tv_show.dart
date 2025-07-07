import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class SaveTVShow extends UseCase<void, TVShowEntity> {
  final TVShowRepository tvShowRepository;

  SaveTVShow(this.tvShowRepository);

  @override
  Future<Either<AppError, void>> call(TVShowEntity params) async {
    return await tvShowRepository.saveTVShow(params);
  }
} 