import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_bloc.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_screen.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:tedflix_app/presentation/screens/tv_show_detail_screen.dart';

class MovieCarouselWidget extends StatefulWidget {
  @override
  _MovieCarouselWidgetState createState() => _MovieCarouselWidgetState();
}

class _MovieCarouselWidgetState extends State<MovieCarouselWidget> {
  late PageController _pageController;
  int _currentPage = 0;
  List<dynamic> _carouselItems = [];
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(Duration(seconds: 7), (timer) {
      if (_carouselItems.isNotEmpty) {
        _currentPage = (_currentPage + 1) % _carouselItems.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCarouselBloc, MovieCarouselState>(
      builder: (context, movieState) {
        return BlocBuilder<TVShowBloc, TVShowState>(
          builder: (context, tvState) {
            if (movieState is MovieCarouselLoaded && tvState is TVShowLoaded) {
              // Alternate between movies and series
              final movies = movieState.movies.take(3).toList();
              final series = tvState.tvShows.take(3).toList();
              
              _carouselItems = [];
              for (int i = 0; i < 3; i++) {
                if (i < movies.length) {
                  _carouselItems.add({'type': 'movie', 'item': movies[i]});
                }
                if (i < series.length) {
                  _carouselItems.add({'type': 'series', 'item': series[i]});
                }
              }

              if (_carouselItems.isEmpty) {
                return SizedBox.shrink();
              }

              return Container(
                height: 400,
                child: Column(
                  children: [
                    // Carousel
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: _carouselItems.length,
                        itemBuilder: (context, index) {
                          final item = _carouselItems[index];
                          return _buildCarouselItem(item, index);
                        },
                      ),
                    ),
                    // Page indicators
                    Container(
                      height: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _carouselItems.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index 
                                  ? Colors.white 
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            }
            return Container(
              height: 400,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCarouselItem(Map<String, dynamic> item, int index) {
    final type = item['type'] as String;
    final data = item['item'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          if (type == 'movie') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(
                  key: UniqueKey(),
                  movieDetailArguments: MovieDetailArguments(data.id),
                ),
              ),
            );
          } else if (type == 'series') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TVShowDetailScreen(tvShowId: data.id),
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://image.tmdb.org/t/p/original${data.backdropPath ?? data.posterPath}',
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[900],
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / 
                              loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[900],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white54,
                            size: 48,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Failed to load image',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Gradient overlay
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  type == 'movie' ? data.title : data.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 8,
                        color: Colors.black,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Action buttons
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: Icon(Icons.play_arrow),
                    label: Text('Play'),
                    onPressed: () {
                      if (type == 'movie') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                              key: UniqueKey(),
                              movieDetailArguments: MovieDetailArguments(data.id),
                            ),
                          ),
                        );
                      } else if (type == 'series') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TVShowDetailScreen(tvShowId: data.id),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Details'),
                    onPressed: () {
                      if (type == 'movie') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(
                              key: UniqueKey(),
                              movieDetailArguments: MovieDetailArguments(data.id),
                            ),
                          ),
                        );
                      } else if (type == 'series') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TVShowDetailScreen(tvShowId: data.id),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
