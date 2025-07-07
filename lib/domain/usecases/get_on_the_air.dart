import 'package:dartz/dartz.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/domain/entities/no_params.dart';
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class GetOnTheAir extends UseCase<List<TVShowEntity>, NoParams> {
  final TVShowRepository repository;

  GetOnTheAir(this.repository);

  @override
  Future<Either<AppError, List<TVShowEntity>>> call(NoParams params) async {
    return await repository.getOnTheAir();
  }
}
