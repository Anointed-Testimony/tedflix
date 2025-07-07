import 'package:tedflix_app/domain/entities/episode_entity.dart';

class EpisodeModel extends EpisodeEntity {
  const EpisodeModel({
    required super.id,
    required super.name,
    required super.overview,
    required super.airDate,
    required super.episodeNumber,
    required super.productionCode,
    required super.seasonNumber,
    required super.stillPath,
    required super.voteAverage,
    required super.voteCount,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      overview: json['overview'] as String? ?? '',
      airDate: json['air_date'] as String? ?? '',
      episodeNumber: json['episode_number'] as int? ?? 0,
      productionCode: json['production_code'] as String? ?? '',
      seasonNumber: json['season_number'] as int? ?? 0,
      stillPath: json['still_path'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'air_date': airDate,
      'episode_number': episodeNumber,
      'production_code': productionCode,
      'season_number': seasonNumber,
      'still_path': stillPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}
