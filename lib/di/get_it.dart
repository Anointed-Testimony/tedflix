import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tedflix_app/data/data_sources/movie_local_data_source.dart';
import 'package:tedflix_app/data/data_sources/tv_show_local_data_source.dart';
import 'package:tedflix_app/data/data_sources/tv_show_remote_data_source.dart';
import 'package:tedflix_app/domain/usecases/check_if_movie_favorite.dart';
import 'package:tedflix_app/domain/usecases/delete_favorite_movie.dart';
import 'package:tedflix_app/domain/usecases/get_cast.dart';
import 'package:tedflix_app/domain/usecases/get_favorite_movies.dart';
import 'package:tedflix_app/domain/usecases/get_movie_detail.dart';
import 'package:tedflix_app/domain/usecases/save_movie.dart';
import 'package:tedflix_app/domain/usecases/search_movies.dart';
import 'package:tedflix_app/domain/usecases/get_popular_tv_shows.dart';
import 'package:tedflix_app/domain/usecases/get_tv_show_details.dart';
import 'package:tedflix_app/domain/usecases/get_tv_show_cast.dart';
import 'package:tedflix_app/domain/usecases/search_tv_shows.dart';
import 'package:tedflix_app/domain/usecases/get_tv_show_seasons.dart';
import 'package:tedflix_app/presentation/blocs/cast/cast_bloc.dart'
    as movie_cast;
import 'package:tedflix_app/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:tedflix_app/presentation/blocs/loading/loading_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:tedflix_app/presentation/blocs/search_movie/search_movie_bloc.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_bloc.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_detail_bloc.dart';
import 'package:tedflix_app/presentation/blocs/cast_bloc.dart' as tv_cast;
import 'package:tedflix_app/presentation/blocs/tv_show_watch_progress/tv_show_watch_progress_bloc.dart';
import 'package:tedflix_app/presentation/blocs/favorite_movie/favorite_movie_bloc.dart';
import 'package:tedflix_app/presentation/blocs/season_bloc.dart';

import '../data/core/api_client.dart';
import '../data/data_sources/movie_remote_data_source.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/usecases/get_coming_soon.dart';
import '../domain/usecases/get_playing_now.dart';
import '../domain/usecases/get_popular.dart';
import '../domain/usecases/get_trending.dart';
import '../data/repositories/tv_show_repository_impl.dart';
import '../domain/repositories/tv_show_repository.dart';
import 'package:tedflix_app/domain/usecases/save_tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/usecases/get_tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/usecases/get_all_tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/usecases/delete_tv_show_watch_progress.dart';
import 'package:tedflix_app/domain/usecases/get_airing_today.dart';
import 'package:tedflix_app/domain/usecases/get_on_the_air.dart';
import 'package:tedflix_app/presentation/blocs/favorite_tv_show/favorite_tv_show_bloc.dart';
import 'package:tedflix_app/domain/usecases/check_if_tv_show_favorite.dart';
import 'package:tedflix_app/domain/usecases/delete_favorite_tv_show.dart';
import 'package:tedflix_app/domain/usecases/get_favorite_tv_shows.dart';
import 'package:tedflix_app/domain/usecases/save_tv_show.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance
      .registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl());

  getItInstance
      .registerLazySingleton<GetTrending>(() => GetTrending(getItInstance()));
  getItInstance
      .registerLazySingleton<GetPopular>(() => GetPopular(getItInstance()));
  getItInstance.registerLazySingleton<GetPlayingNow>(
      () => GetPlayingNow(getItInstance()));
  getItInstance.registerLazySingleton<GetComingSoon>(
      () => GetComingSoon(getItInstance()));

  getItInstance
      .registerLazySingleton<SaveMovie>(() => SaveMovie(getItInstance()));

  getItInstance.registerLazySingleton<GetFavoriteMovies>(
      () => GetFavoriteMovies(getItInstance()));

  getItInstance.registerLazySingleton<DeleteFavoriteMovie>(
      () => DeleteFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<CheckIfFavoriteMovie>(
      () => CheckIfFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<GetMovieDetail>(
      () => GetMovieDetail(getItInstance()));

  getItInstance.registerLazySingleton<GetCast>(() => GetCast(getItInstance()));

  getItInstance
      .registerLazySingleton<SearchMovies>(() => SearchMovies(getItInstance()));

  getItInstance.registerLazySingleton<GetTVShowCast>(
      () => GetTVShowCast(getItInstance()));

  getItInstance.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(getItInstance(), getItInstance()));

  getItInstance.registerFactory(() => MovieBackdropBloc());

  getItInstance.registerFactory(
    () => MovieCarouselBloc(
      getTrending: getItInstance(),
      movieBackdropBloc: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => MovieTabbedBloc(
      getPopular: getItInstance(),
      getNowPlaying: getItInstance(),
      getComingSoon: getItInstance(),
      getPopularTVShows: getItInstance(),
      getAiringToday: getItInstance(),
      getOnTheAir: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: getItInstance(),
      castBloc: getItInstance<movie_cast.CastBloc>(),
      favoriteBloc: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => movie_cast.CastBloc(
      getCast: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => tv_cast.CastBloc(
      getTVShowCast: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => SearchMovieBloc(
      searchMovies: getItInstance(),
    ),
  );

  getItInstance.registerFactory(() => FavoriteBloc(
        saveMovie: getItInstance(),
        checkIfFavoriteMovie: getItInstance(),
        deleteFavoriteMovie: getItInstance(),
        getFavoriteMovies: getItInstance(),
      ));

  getItInstance.registerSingleton<LoadingBloc>(LoadingBloc());

  // TV Show Remote Data Source
  getItInstance.registerLazySingleton<TVShowRemoteDataSource>(
      () => TVShowRemoteDataSourceImpl(getItInstance()));

  // TV Show Local Data Source
  getItInstance.registerLazySingleton<TVShowLocalDataSource>(
      () => TVShowLocalDataSourceImpl());

  // TV Show Repository
  getItInstance.registerLazySingleton<TVShowRepository>(
      () => TVShowRepositoryImpl(getItInstance(), getItInstance()));

  // TV Show Use Cases
  getItInstance.registerLazySingleton(() => GetPopularTVShows(getItInstance()));
  getItInstance.registerLazySingleton(() => GetAiringToday(getItInstance()));
  getItInstance.registerLazySingleton(() => GetOnTheAir(getItInstance()));
  getItInstance.registerLazySingleton(() => GetTVShowDetails(getItInstance()));
  getItInstance.registerLazySingleton(() => SearchTVShows(getItInstance()));
  getItInstance.registerLazySingleton(() => GetTVShowSeasons(getItInstance()));
  getItInstance
      .registerLazySingleton(() => SaveTVShowWatchProgress(getItInstance()));
  getItInstance
      .registerLazySingleton(() => GetTVShowWatchProgress(getItInstance()));
  getItInstance
      .registerLazySingleton(() => GetAllTVShowWatchProgress(getItInstance()));
  getItInstance
      .registerLazySingleton(() => DeleteTVShowWatchProgress(getItInstance()));

  // TV Show BLoCs
  getItInstance.registerFactory(
    () => TVShowBloc(
      getPopularTVShows: getItInstance(),
      searchTVShows: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => TVShowDetailBloc(
      getTVShowDetails: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => TVShowWatchProgressBloc(
      saveWatchProgress: getItInstance(),
      getWatchProgress: getItInstance(),
      getAllWatchProgress: getItInstance(),
      deleteWatchProgress: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => SeasonBloc(
      getTVShowSeasons: getItInstance(),
    ),
  );

  // BLoCs
  getItInstance.registerFactory(
    () => FavoriteMovieBloc(
      getFavoriteMovies: getItInstance(),
    ),
  );

  getItInstance.registerLazySingleton<CheckIfTVShowFavorite>(
    () => CheckIfTVShowFavorite(getItInstance()),
  );
  getItInstance.registerLazySingleton<DeleteFavoriteTVShow>(
    () => DeleteFavoriteTVShow(getItInstance()),
  );
  getItInstance.registerLazySingleton<GetFavoriteTVShows>(
    () => GetFavoriteTVShows(getItInstance()),
  );
  getItInstance.registerLazySingleton<SaveTVShow>(
    () => SaveTVShow(getItInstance()),
  );
  getItInstance.registerFactory(
    () => FavoriteTVShowBloc(
      saveTVShow: getItInstance(),
      getFavoriteTVShows: getItInstance(),
      deleteFavoriteTVShow: getItInstance(),
      checkIfTVShowFavorite: getItInstance(),
    ),
  );

}
