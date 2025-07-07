import 'dart:convert'; // Import for json.decode
import 'package:http/http.dart';
import 'package:tedflix_app/data/core/api_client.dart';
import 'package:tedflix_app/data/core/api_constants.dart';
import 'package:tedflix_app/data/models/cast_crew_result_data_model.dart';
import 'package:tedflix_app/data/models/movie_detail_model.dart';
import 'package:tedflix_app/data/models/movie_model.dart';
import 'package:tedflix_app/data/models/movies_result_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getTrending();
  Future<List<MovieModel>> getPopular();
  Future<List<MovieModel>> getPlayingNow();
  Future<List<MovieModel>> getComingSoon();
  Future<List<MovieModel>> getSearchedMovies(String searchTerm);
  Future<MovieDetailModel> getMovieDetail(int id);
  Future<List<CastModel>> getCastCrew(int id);
}

class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  final ApiClient _client;

  MovieRemoteDataSourceImpl(this._client);

  @override
  Future<List<MovieModel>> getTrending() async {
    final response = await _client.get('trending/movie/day', params: {});
    final json = jsonDecode(response.body);
    final movies = MoviesResultModel.fromJson(json).movies ?? [];
    print(movies);
    return movies;
  }

  @override
  Future<List<MovieModel>> getPopular() async {
    final response = await _client.get('movie/popular', params: {});
    final json = jsonDecode(response.body);
    final movies = MoviesResultModel.fromJson(json).movies ?? [];
    print(movies);
    return movies;
  }

  @override
  Future<List<MovieModel>> getComingSoon() async {
    final response = await _client.get('movie/upcoming', params: {});
    final json = jsonDecode(response.body);
    final movies = MoviesResultModel.fromJson(json).movies ?? [];
    print(movies);
    return movies;
  }

  @override
  Future<List<MovieModel>> getPlayingNow() async {
    final response = await _client.get('movie/now_playing', params: {});
    final json = jsonDecode(response.body);
    final movies = MoviesResultModel.fromJson(json).movies ?? [];
    print(movies);
    return movies;
  }

  @override
  Future<MovieDetailModel> getMovieDetail(int id) async {
    final response = await _client.get('movie/$id', params: {});
    final json = jsonDecode(response.body);
    final movie = MovieDetailModel.fromJson(json);
    print(movie);
    return movie;
  }

  @override
  Future<List<CastModel>> getCastCrew(int id) async {
    final response = await _client.get('movie/$id/credits', params: {});
    final json = jsonDecode(response.body);
    final cast = CastCrewResultModel.fromJson(json).cast ?? [];
    print(cast);
    return cast;
  }

  @override
  Future<List<MovieModel>> getSearchedMovies(String searchTerm) async {
    final response = await _client.get(
      'search/movie',
      params: {
        'query': searchTerm,
      },
    );
    final json = jsonDecode(response.body);
    final movies = MoviesResultModel.fromJson(json).movies ?? [];
    print(movies);
    return movies;
  }
}
