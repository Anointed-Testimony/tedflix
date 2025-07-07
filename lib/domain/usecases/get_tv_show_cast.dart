import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/cast_entity.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';

class GetTVShowCast {
  final TVShowRepository repository;

  GetTVShowCast(this.repository);

  Future<Either<AppError, List<CastEntity>>> call(int tvShowId) async {
    return await repository.getTVShowCast(tvShowId);
  }
}
