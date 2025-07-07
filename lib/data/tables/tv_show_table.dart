import 'package:hive/hive.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';

part 'tv_show_table.g.dart';

@HiveType(typeId: 1)
class TVShowTable extends TVShowEntity {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String posterPath;

  TVShowTable({
    required this.id,
    required this.name,
    required this.posterPath,
  }) : super(
          id: id,
          name: name,
          overview: '',
          posterPath: posterPath,
          backdropPath: '',
          firstAirDate: '',
          voteAverage: 0,
          voteCount: 0,
          genreIds: [],
          originalName: '',
          originalLanguage: '',
          popularity: 0,
          originCountry: [],
        );

  factory TVShowTable.fromTVShowEntity(TVShowEntity tvShowEntity) {
    return TVShowTable(
      id: tvShowEntity.id,
      name: tvShowEntity.name,
      posterPath: tvShowEntity.posterPath,
    );
  }
}
