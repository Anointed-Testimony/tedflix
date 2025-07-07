import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/domain/entities/episode_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_detail_entity.dart'
    as detail;
import 'package:tedflix_app/domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/usecase.dart';

class GetTVShowEpisodes
    extends UseCase<List<EpisodeEntity>, TVShowSeasonParams> {
  final TVShowRepository repository;

  GetTVShowEpisodes(this.repository);

  @override
  Future<Either<AppError, List<EpisodeEntity>>> call(
      TVShowSeasonParams params) async {
    final tvShowDetail = await repository.getTVShowDetail(params.tvShowId);
    return tvShowDetail.fold(
      (error) => Left(error),
      (tvShow) {
        final season = tvShow.seasons.firstWhere(
          (season) => season.seasonNumber == params.seasonNumber,
          orElse: () => throw Exception('Season not found'),
        );
        return Right(season.episodes);
      },
    );
  }
}

class TVShowSeasonParams extends Equatable {
  final int tvShowId;
  final int seasonNumber;

  const TVShowSeasonParams({
    required this.tvShowId,
    required this.seasonNumber,
  });

  @override
  List<Object> get props => [tvShowId, seasonNumber];
}
