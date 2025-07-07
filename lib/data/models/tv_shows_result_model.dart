import 'package:tedflix_app/data/models/tv_show_model.dart';

class TVShowsResultModel {
  final List<TVShowModel>? tvShows;

  TVShowsResultModel({this.tvShows});

  factory TVShowsResultModel.fromJson(Map<String, dynamic> json) {
    return TVShowsResultModel(
      tvShows: (json['results'] as List<dynamic>?)
          ?.map((v) => TVShowModel.fromJson(v as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': tvShows?.map((v) => v.toJson()).toList(),
    };
  }
}
