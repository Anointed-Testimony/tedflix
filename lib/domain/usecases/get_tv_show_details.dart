import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/tv_show_detail_entity.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class GetTVShowDetails extends UseCase<TVShowDetailEntity, int> {
  final TVShowRepository repository;

  GetTVShowDetails(this.repository);

  @override
  Future<Either<AppError, TVShowDetailEntity>> call(int tvShowId) async {
    return await repository.getTVShowDetail(tvShowId);
  }
} 