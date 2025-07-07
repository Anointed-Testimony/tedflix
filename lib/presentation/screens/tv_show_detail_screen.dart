import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/domain/entities/tv_show_detail_entity.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_detail_bloc.dart';
import 'package:tedflix_app/core/constants/api_constants.dart';
import 'package:tedflix_app/presentation/widgets/cast_widget.dart';
import 'package:tedflix_app/presentation/widgets/banner_ad_widget.dart';
import 'package:tedflix_app/presentation/widgets/app_error_widget.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tedflix_app/presentation/blocs/cast_bloc.dart' as tv_cast;
import 'package:tedflix_app/presentation/blocs/favorite_tv_show/favorite_tv_show_bloc.dart';
import 'package:tedflix_app/domain/entities/movie_params.dart';

class TVShowDetailScreen extends StatefulWidget {
  final int tvShowId;

  const TVShowDetailScreen({
    Key? key,
    required this.tvShowId,
  }) : super(key: key);

  @override
  State<TVShowDetailScreen> createState() => _TVShowDetailScreenState();
}

class _TVShowDetailScreenState extends State<TVShowDetailScreen> {
  late TVShowDetailBloc _tvShowDetailBloc;
  late tv_cast.CastBloc _castBloc;
  late FavoriteTVShowBloc _favoriteTVShowBloc;

  @override
  void initState() {
    super.initState();
    _tvShowDetailBloc = getItInstance<TVShowDetailBloc>();
    _castBloc = getItInstance<tv_cast.CastBloc>();
    _favoriteTVShowBloc = getItInstance<FavoriteTVShowBloc>();
    _tvShowDetailBloc.add(LoadTVShowDetail(widget.tvShowId));
    _castBloc.add(tv_cast.LoadCast(widget.tvShowId));
    _favoriteTVShowBloc.add(CheckIfFavoriteTVShowEvent(tvShowId: widget.tvShowId));
  }

  @override
  void dispose() {
    _tvShowDetailBloc.close();
    _castBloc.close();
    _favoriteTVShowBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _tvShowDetailBloc),
          BlocProvider.value(value: _castBloc),
          BlocProvider.value(value: _favoriteTVShowBloc),
        ],
        child: BlocBuilder<TVShowDetailBloc, TVShowDetailState>(
          builder: (context, state) {
            if (state is TVShowDetailLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (state is TVShowDetailLoaded) {
              return _buildTVShowDetail(state.tvShowDetail);
            } else if (state is TVShowDetailError) {
              return AppErrorWidget(
                errorType: state.errorType,
                onPressed: () {
                  _tvShowDetailBloc.add(LoadTVShowDetail(widget.tvShowId));
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildTVShowDetail(TVShowDetailEntity tvShowDetail) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    '${ApiConstants.BASE_IMAGE_URL}${tvShowDetail.backdropPath}',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 40,
                right: 8,
                child: BlocBuilder<FavoriteTVShowBloc, FavoriteTVShowState>(
                  builder: (context, state) {
                    bool isFavorite = false;
                    if (state is IsFavoriteTVShow) {
                      isFavorite = state.isFavorite;
                    }
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        _favoriteTVShowBloc.add(ToggleFavoriteTVShowEvent(
                          tvShowEntity: tvShowDetail.toTVShowEntity(),
                          isFavorite: isFavorite,
                        ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tvShowDetail.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  tvShowDetail.overview,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Seasons',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tvShowDetail.seasons.length,
                    itemBuilder: (context, index) {
                      final season = tvShowDetail.seasons[index];
                      if (season.seasonNumber == 0) return const SizedBox.shrink(); // Skip season 0
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/season_detail',
                            arguments: {
                              'tvShowId': tvShowDetail.id,
                              'seasonNumber': season.seasonNumber,
                            },
                          );
                        },
                        child: Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ApiConstants.BASE_IMAGE_URL}${season.posterPath}',
                                  height: 150,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Season ${season.seasonNumber}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cast',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                CastWidget(tvShowId: widget.tvShowId),
                const SizedBox(height: 16),
                BannerAdWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
