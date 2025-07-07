import 'package:tedflix_app/domain/entities/tv_show_entity.dart';

class TVShowModel extends TVShowEntity {
  const TVShowModel({
    required int id,
    required String name,
    required String overview,
    required String posterPath,
    required String backdropPath,
    required String firstAirDate,
    required double voteAverage,
    required int voteCount,
    required List<int> genreIds,
    required String originalName,
    required String originalLanguage,
    required double popularity,
    required List<String> originCountry,
  }) : super(
          id: id,
          name: name,
          overview: overview,
          posterPath: posterPath,
          backdropPath: backdropPath,
          firstAirDate: firstAirDate,
          voteAverage: voteAverage,
          voteCount: voteCount,
          genreIds: genreIds,
          originalName: originalName,
          originalLanguage: originalLanguage,
          popularity: popularity,
          originCountry: originCountry,
        );

  factory TVShowModel.fromJson(Map<String, dynamic> json) {
    return TVShowModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String? ?? '',
      firstAirDate: json['first_air_date'] as String? ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originalName: json['original_name'] as String? ?? '',
      originalLanguage: json['original_language'] as String? ?? '',
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      originCountry: List<String>.from(json['origin_country'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'first_air_date': firstAirDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genre_ids': genreIds,
      'original_name': originalName,
      'original_language': originalLanguage,
      'popularity': popularity,
      'origin_country': originCountry,
    };
  }
}
