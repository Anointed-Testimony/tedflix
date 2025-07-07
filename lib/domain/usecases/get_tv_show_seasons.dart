import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/season_entity.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class GetTVShowSeasons extends UseCase<SeasonEntity, Map<String, dynamic>> {
  final TVShowRepository repository;

  GetTVShowSeasons(this.repository);

  @override
  Future<Either<AppError, SeasonEntity>> call(Map<String, dynamic> params) async {
    final tvShowId = params['tvShowId'] as int;
    final seasonNumber = params['seasonNumber'] as int;
    return await repository.getSeasonDetail(tvShowId, seasonNumber);
  }
}
