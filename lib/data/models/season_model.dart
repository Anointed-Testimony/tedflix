import 'package:tedflix_app/domain/entities/season_entity.dart';
import 'package:tedflix_app/domain/entities/episode_entity.dart';
import 'package:tedflix_app/data/models/episode_model.dart';

class SeasonModel extends SeasonEntity {
  const SeasonModel({
    required int id,
    required String name,
    required String overview,
    required String airDate,
    required int episodeCount,
    required String posterPath,
    required int seasonNumber,
    required List<EpisodeEntity> episodes,
  }) : super(
          id: id,
          name: name,
          overview: overview,
          airDate: airDate,
          episodeCount: episodeCount,
          posterPath: posterPath,
          seasonNumber: seasonNumber,
          episodes: episodes,
        );

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      overview: json['overview'] as String? ?? '',
      airDate: json['air_date'] as String? ?? '',
      episodeCount: json['episode_count'] as int? ?? 0,
      posterPath: json['poster_path'] as String? ?? '',
      seasonNumber: json['season_number'] as int? ?? 0,
      episodes: (json['episodes'] as List?)
              ?.map((episode) => EpisodeModel.fromJson(episode))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'air_date': airDate,
      'episode_count': episodeCount,
      'poster_path': posterPath,
      'season_number': seasonNumber,
      'episodes': episodes.map((episode) => (episode as EpisodeModel).toJson()).toList(),
    };
  }
}
