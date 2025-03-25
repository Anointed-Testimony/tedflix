import 'package:tedflix_app/domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  final String backdropPath;
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String mediaType;
  final bool adult;
  final String originalLanguage;
  final List<int> genreIds;
  final double popularity;
  final String releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;

  MovieModel({
    required this.backdropPath,
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.adult,
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  }) : super(
          id: id,
          title: title,
          overview: overview,
          posterPath: posterPath,
          releaseDate: releaseDate,
          voteAverage: voteAverage,
          backdropPath: backdropPath,
        );

factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      backdropPath: json['backdrop_path'] as String? ?? '', // Provide default empty string
      id: json['id'] as int? ?? 0, // Provide default value
      title: json['title'] as String? ?? '', // Provide default empty string
      originalTitle: json['original_title'] as String? ?? '', // Provide default empty string
      overview: json['overview'] as String? ?? '', // Provide default empty string
      posterPath: json['poster_path'] as String? ?? '', // Provide default empty string
      mediaType: json['media_type'] as String? ?? '', // Provide default empty string
      adult: json['adult'] as bool? ?? false, // Provide default value
      originalLanguage: json['original_language'] as String? ?? '', // Provide default empty string
      genreIds: List<int>.from(json['genre_ids'] ?? []), // Provide default empty list
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0, // Provide default value
      releaseDate: json['release_date'] as String? ?? '', // Provide default empty string
      video: json['video'] as bool? ?? false, // Provide default value
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0, // Provide default value
      voteCount: json['vote_count'] as int? ?? 0, // Provide default value
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backdrop_path'] = backdropPath;
    data['id'] = id;
    data['title'] = title;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['media_type'] = mediaType;
    data['adult'] = adult;
    data['original_language'] = originalLanguage;
    data['genre_ids'] = genreIds;
    data['popularity'] = popularity;
    data['release_date'] = releaseDate;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}
