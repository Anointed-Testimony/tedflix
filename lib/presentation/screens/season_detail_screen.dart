import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/domain/entities/season_entity.dart';
import 'package:tedflix_app/presentation/blocs/season_bloc.dart';
import 'package:tedflix_app/core/constants/api_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tedflix_app/presentation/widgets/banner_ad_widget.dart';
import 'dart:async';
import 'package:tedflix_app/presentation/journeys/movie_detail/watch_page.dart';
import 'package:tedflix_app/presentation/widgets/ad_watch_modal.dart';

class SeasonDetailScreen extends StatefulWidget {
  final int tvShowId;
  final int seasonNumber;

  const SeasonDetailScreen({
    Key? key,
    required this.tvShowId,
    required this.seasonNumber,
  }) : super(key: key);

  @override
  State<SeasonDetailScreen> createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends State<SeasonDetailScreen> {
  InterstitialAd? _interstitialAd;
  Timer? _adTimer;
  RewardedAd? _rewardedAd;
  bool _isRewardedAdReady = false;

  @override
  void initState() {
    super.initState();
    context.read<SeasonBloc>().add(LoadSeason(
          tvShowId: widget.tvShowId,
          seasonNumber: widget.seasonNumber,
        ));

    // Initialize AdMob and load the first interstitial ad
    MobileAds.instance.initialize();
    _loadInterstitialAd();

    // Start a timer for showing ads periodically
    _startAdTimer();

    _loadRewardedAd();
  }

  // Load an interstitial ad
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-8360591759937694/2892815350',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            _interstitialAd = ad;
          });
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              print('Ad failed to show: $error');
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  // Show the interstitial ad if loaded
  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }

  // Start a timer to show ads periodically (every 5 minutes)
  void _startAdTimer() {
    _adTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      _showInterstitialAd();
    });
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
    _adTimer?.cancel();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _playEpisode(int episodeNumber) async {
    final url =
        'https://vidsrc.me/embed/tv?tmdb=${widget.tvShowId}&season=${widget.seasonNumber}&episode=$episodeNumber';
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AdWatchModal(
        onAdCompleted: (watched) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(watched);
            }
          });
        },
      ),
    );
    if (result == true) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WatchPage(
            tmdbId: widget.tvShowId.toString(),
            adWatched: true,
            customUrl: url,
          ),
      ),
    );
    }
    // If cancelled, do nothing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<SeasonBloc, SeasonState>(
        builder: (context, state) {
          if (state is SeasonLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          } else if (state is SeasonLoaded) {
            return _buildSeasonDetail(state.season);
          } else if (state is SeasonError) {
            return Center(
              child: Text(
                'Error: ${state.errorType}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSeasonDetail(SeasonEntity season) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: BannerAdWidget()),
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 200,
          pinned: true,
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            background: CachedNetworkImage(
              imageUrl: '${ApiConstants.BASE_IMAGE_URL}${season.posterPath}',
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  season.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Season ${season.seasonNumber}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Episodes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: season.episodes.length,
                  itemBuilder: (context, index) {
                    final episode = season.episodes[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl:
                                '${ApiConstants.BASE_IMAGE_URL}${episode.stillPath}',
                            width: 100,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          'Episode ${episode.episodeNumber}: ${episode.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          episode.overview,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle_outline,
                              color: Colors.white),
                          onPressed: () => _playEpisode(episode.episodeNumber),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EpisodePlayerPage extends StatefulWidget {
  final String url;
  const _EpisodePlayerPage({required this.url});

  @override
  State<_EpisodePlayerPage> createState() => _EpisodePlayerPageState();
}

class _EpisodePlayerPageState extends State<_EpisodePlayerPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Force landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final iframeUrl = widget.url;
    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #000;
            overflow: hidden;
            font-family: Arial, sans-serif;
        }
        .iframe-container {
            width: 100vw;
            height: 100vh;
            position: relative;
        }
        iframe {
            width: 100%;
            height: 100%;
            border: none;
            display: block;
        }
    </style>
</head>
<body>
    <div class="iframe-container">
        <iframe 
            src="$iframeUrl" 
            frameborder="0" 
            allowfullscreen
            allow="autoplay; fullscreen; picture-in-picture">
        </iframe>
    </div>
</body>
</html>
''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Only allow navigation to the original iframe URL
            if (request.url == iframeUrl) {
              return NavigationDecision.navigate;
            }
            // Block all other navigation attempts gracefully
            print('[DEBUG] Blocked redirect to: ' + request.url);
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadHtmlString(htmlContent);
  }

  @override
  void dispose() {
    // Reset orientation back to portrait when leaving the page
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WebViewWidget(controller: _controller),
    );
  }
}
