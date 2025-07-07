import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:tedflix_app/presentation/blocs/cast/cast_bloc.dart';
import 'package:tedflix_app/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/big_poster.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/cast_widget.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/watch_page.dart';
import 'package:tedflix_app/presentation/widgets/banner_ad_widget.dart';
import 'package:tedflix_app/presentation/widgets/ad_watch_modal.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_app_bar.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieDetailArguments movieDetailArguments;

  const MovieDetailScreen({
    required Key key,
    required this.movieDetailArguments,
  })  : assert(movieDetailArguments != null, 'arguments must not be null'),
        super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late MovieDetailBloc _movieDetailBloc;
  late CastBloc _castBloc;
  late FavoriteBloc _favoriteBloc;
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;
  bool _adModalShown = false;

  @override
  void initState() {
    super.initState();
    _movieDetailBloc = getItInstance<MovieDetailBloc>();
    _castBloc = _movieDetailBloc.castBloc;
    _favoriteBloc = _movieDetailBloc.favoriteBloc;
    _movieDetailBloc.add(
      MovieDetailLoadEvent(
        widget.movieDetailArguments.movieId,
      ),
    );
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Demo rewarded ad unit
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (error) {
          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showRewardedAd(VoidCallback onRewarded) {
    if (_isRewardedAdReady && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadRewardedAd();
        },
      );
      _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
        onRewarded();
      });
      setState(() {
        _rewardedAd = null;
        _isRewardedAdReady = false;
      });
    } else {
      onRewarded(); // fallback if ad not ready
    }
  }

  @override
  void dispose() {
    _movieDetailBloc?.close();
    _favoriteBloc?.close();
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _movieDetailBloc),
          BlocProvider.value(value: _castBloc),
          BlocProvider.value(value: _favoriteBloc),
        ],
        child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is MovieDetailLoaded) {
              final movieDetail = state.movieDetailEntity;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Only show the ad modal after the detail page is built
                if (!_adModalShown) {
                  _adModalShown = true;
                  // Show the ad modal here if needed (e.g., for first time or after a timer)
                }
              });
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preview Image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movieDetail.backdropPath ?? movieDetail.posterPath}',
                            width: double.infinity,
                            height: 260,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 8,
                          right: 8,
                          child: MovieDetailAppBar(
                            key: Key('movie_detail_app_bar'),
                            movieDetailEntity: movieDetail,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and logo
                          Row(
                            children: [
                              Expanded(
                      child: Text(
                                  movieDetail.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                      ),
                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Enhanced Stats Section
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.15),
                                  Colors.white.withOpacity(0.08),
                                  Colors.white.withOpacity(0.03),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1.5,
                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Rating
                                _buildStatItem(
                                  icon: Icons.star_rounded,
                                  iconColor: Colors.amber,
                                  value: '${(movieDetail.voteAverage * 10).toStringAsFixed(0)}%',
                                  label: 'Rating',
                                  valueColor: Colors.amber,
                                ),
                                // Year
                                _buildStatItem(
                                  icon: Icons.calendar_today_rounded,
                                  iconColor: Colors.blue,
                                  value: '${movieDetail.releaseDate.split('-').first}',
                                  label: 'Year',
                                  valueColor: Colors.white,
                                ),
                                // Rating
                                _buildStatItem(
                                  icon: Icons.verified_rounded,
                                  iconColor: Colors.orange,
                                  value: 'R',
                                  label: 'Rating',
                                  valueColor: Colors.white,
                                ),
                                // Quality
                                _buildStatItem(
                                  icon: Icons.high_quality_rounded,
                                  iconColor: Colors.purple,
                                  value: 'HD',
                                  label: 'Quality',
                                  valueColor: Colors.white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          // Play button
                          SizedBox(
                            width: double.infinity,
                      child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () async {
                                try {
                                  final result = await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AdWatchModal(
                                      onAdCompleted: (watched) {
                                        // Use a post-frame callback to ensure safe navigation
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (mounted && Navigator.of(context).canPop()) {
                                            Navigator.of(context).pop(watched);
                                          }
                                        });
                                      },
                                    ),
                                  );
                                  
                                  if (mounted && result == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Reward completed!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    // Use a post-frame callback to ensure safe navigation
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                                            builder: (context) => WatchPage(tmdbId: movieDetail.id.toString(), adWatched: true),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                  // If cancelled (result == false), do nothing
                                } catch (e) {
                                  print('Error showing ad modal: $e');
                                }
                        },
                              child: Text('Play', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Prolog/Overview
                          Text('Prolog', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 8),
                          Text(
                            movieDetail.overview,
                            style: TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                          SizedBox(height: 20),
                          // Top Cast
                          Text('Top Cast', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 8),
                          CastWidget(),
                          SizedBox(height: 20),
                          BannerAdWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is MovieDetailError) {
              return Container();
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
