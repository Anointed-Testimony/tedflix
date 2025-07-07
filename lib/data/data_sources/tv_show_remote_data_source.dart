import 'dart:convert';
import 'package:http/http.dart';
import 'package:tedflix_app/core/constants/api_constants.dart';
import 'package:tedflix_app/data/core/api_client.dart';
import 'package:tedflix_app/data/models/cast_crew_result_data_model.dart';
import 'package:tedflix_app/data/models/tv_show_detail_model.dart';
import 'package:tedflix_app/data/models/tv_show_model.dart';
import 'package:tedflix_app/data/models/tv_shows_result_model.dart';
import 'package:tedflix_app/data/models/season_model.dart';
import 'package:tedflix_app/domain/entities/season_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_detail_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/domain/entities/cast_entity.dart';

abstract class TVShowRemoteDataSource {
  Future<List<TVShowEntity>> getPopularTVShows();
  Future<List<TVShowEntity>> getAiringToday();
  Future<List<TVShowEntity>> getOnTheAir();
  Future<List<TVShowEntity>> getTopRated();
  Future<TVShowDetailEntity> getTVShowDetail(int tvShowId);
  Future<SeasonEntity> getSeasonDetail(int tvShowId, int seasonNumber);
  Future<List<TVShowEntity>> searchTVShows(String searchTerm);
  Future<List<CastEntity>> getTVShowCast(int tvShowId);
}

class TVShowRemoteDataSourceImpl implements TVShowRemoteDataSource {
  final ApiClient _client;

  TVShowRemoteDataSourceImpl(this._client);

  @override
  Future<List<TVShowEntity>> getPopularTVShows() async {
    final response = await _client.get('tv/popular');
    return _parseTVShowList(response);
  }

  @override
  Future<List<TVShowEntity>> getAiringToday() async {
    final response = await _client.get('tv/airing_today');
    return _parseTVShowList(response);
  }

  @override
  Future<List<TVShowEntity>> getOnTheAir() async {
    final response = await _client.get('tv/on_the_air');
    return _parseTVShowList(response);
  }

  @override
  Future<List<TVShowEntity>> getTopRated() async {
    final response = await _client.get('tv/top_rated');
    return _parseTVShowList(response);
  }

  @override
  Future<TVShowDetailEntity> getTVShowDetail(int tvShowId) async {
    final response = await _client.get('tv/$tvShowId');
    final json = jsonDecode(response.body);
    return TVShowDetailModel.fromJson(json);
  }

  @override
  Future<SeasonEntity> getSeasonDetail(int tvShowId, int seasonNumber) async {
    final response = await _client.get('tv/$tvShowId/season/$seasonNumber');
    final json = jsonDecode(response.body);
    return SeasonModel.fromJson(json);
  }

  @override
  Future<List<TVShowEntity>> searchTVShows(String searchTerm) async {
    final response = await _client.get(
      'search/tv',
      params: {
        'query': searchTerm,
      },
    );
    return _parseTVShowList(response);
  }

  @override
  Future<List<CastEntity>> getTVShowCast(int tvShowId) async {
    final response = await _client.get('tv/$tvShowId/credits');
    final json = jsonDecode(response.body);
    final castResult = CastCrewResultModel.fromJson(json);
    return castResult.cast;
  }

  List<TVShowEntity> _parseTVShowList(Response response) {
    final json = jsonDecode(response.body);
    final results = json['results'] as List;
    return results.map((tvShow) => TVShowModel.fromJson(tvShow)).toList();
  }
}
