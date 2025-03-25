import 'package:tedflix_app/domain/entities/cast_entity.dart';

class CastCrewResultModel {
  final int id;
  final List<CastModel> cast;
  final List<Crew> crew;

  CastCrewResultModel({
    required this.id,
    required this.cast,
    required this.crew,
  });

  factory CastCrewResultModel.fromJson(Map<String, dynamic> json) {
    return CastCrewResultModel(
      id: json['id'] as int,
      cast: (json['cast'] as List<dynamic>?)
              ?.map((item) => CastModel.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
      crew: (json['crew'] as List<dynamic>?)
              ?.map((item) => Crew.fromJson(item as Map<String, dynamic>))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cast': cast.map((v) => v.toJson()).toList(),
      'crew': crew.map((v) => v.toJson()).toList(),
    };
  }
}

class CastModel extends CastEntity {
  final int castId;
  final String character;
  final String creditId;
  final int gender;
  final int id;
  final String name;
  final int order;
  final String profilePath;

  CastModel({
    required this.castId,
    required this.character,
    required this.creditId,
    required this.gender,
    required this.id,
    required this.name,
    required this.order,
    required this.profilePath,
  }) : super(
        creditId: creditId,
        name: name,
        posterPath: profilePath,
        character: character,
      );

  factory CastModel.fromJson(Map<String, dynamic> json) {

    print(json);
    return CastModel(
      castId: json['cast_id'] as int? ?? 0,
      character: json['character'] as String? ?? '',
      creditId: json['credit_id'] as String? ?? '',
      gender: json['gender'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      profilePath: json['profile_path'] as String? ?? '',
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'cast_id': castId,
      'character': character,
      'credit_id': creditId,
      'gender': gender,
      'id': id,
      'name': name,
      'order': order,
      'profile_path': profilePath,
    };
  }
}

class Crew {
  final String creditId;
  final String department;
  final int gender;
  final int id;
  final String job;
  final String name;
  final String profilePath;

  Crew({
    required this.creditId,
    required this.department,
    required this.gender,
    required this.id,
    required this.job,
    required this.name,
    required this.profilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      creditId: json['credit_id'] as String? ?? '',
      department: json['department'] as String? ?? '',
      gender: json['gender'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      job: json['job'] as String? ?? '',
      name: json['name'] as String? ?? '',
      profilePath: json['profile_path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'credit_id': creditId,
      'department': department,
      'gender': gender,
      'id': id,
      'job': job,
      'name': name,
      'profile_path': profilePath,
    };
  }
}
