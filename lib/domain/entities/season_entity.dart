import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/episode_entity.dart';

class SeasonEntity extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String airDate;
  final int episodeCount;
  final String posterPath;
  final int seasonNumber;
  final List<EpisodeEntity> episodes;

  const SeasonEntity({
    required this.id,
    required this.name,
    required this.overview,
    required this.airDate,
    required this.episodeCount,
    required this.posterPath,
    required this.seasonNumber,
    required this.episodes,
  });

  @override
  List<Object> get props => [id];
}
 