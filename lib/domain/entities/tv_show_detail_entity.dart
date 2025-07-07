import 'package:equatable/equatable.dart';
import 'package:tedflix_app/domain/entities/episode_entity.dart';
import 'package:tedflix_app/domain/entities/season_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';

class TVShowDetailEntity extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  final String backdropPath;
  final String posterPath;
  final List<String> createdBy;
  final List<int> episodeRunTime;
  final List<String> genres;
  final String homepage;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final String lastEpisodeToAir;
  final String nextEpisodeToAir;
  final List<String> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final double popularity;
  final List<String> productionCompanies;
  final List<String> productionCountries;
  final List<SeasonEntity> seasons;
  final String status;
  final String type;

  const TVShowDetailEntity({
    required this.id,
    required this.name,
    required this.overview,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.backdropPath,
    required this.posterPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.genres,
    required this.homepage,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.popularity,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.status,
    required this.type,
  });

  @override
  List<Object> get props => [id];

  TVShowEntity toTVShowEntity() {
    return TVShowEntity(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      backdropPath: backdropPath,
      firstAirDate: firstAirDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: [], // Not available in detail entity
      originalName: originalName,
      originalLanguage: originalLanguage,
      popularity: popularity,
      originCountry: originCountry,
    );
  }
}
 