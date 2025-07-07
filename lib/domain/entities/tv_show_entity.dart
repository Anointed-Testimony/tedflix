import 'package:equatable/equatable.dart';

class TVShowEntity extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final String originalName;
  final String originalLanguage;
  final double popularity;
  final List<String> originCountry;

  const TVShowEntity({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.originalName,
    required this.originalLanguage,
    required this.popularity,
    required this.originCountry,
  });

  @override
  List<Object> get props => [id, name];

  @override
  bool get stringify => true;
}
