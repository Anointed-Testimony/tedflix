import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:tedflix_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:tedflix_app/presentation/blocs/search_movie/search_movie_bloc.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_bloc.dart';
import 'package:tedflix_app/presentation/widgets/app_error_widget.dart';
import 'package:tedflix_app/presentation/journeys/home/movie_carousel/movie_carousel_widget.dart';
import 'package:tedflix_app/presentation/journeys/home/movie_tabbed/movie_tabbed_widget.dart';
import 'package:tedflix_app/presentation/journeys/drawer/navigation_drawer.dart'
    as custom_drawer;
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_screen.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:tedflix_app/presentation/journeys/search_movie/custom_search_movie_delegate.dart';
import 'package:tedflix_app/presentation/screens/season_detail_screen.dart';
import 'package:tedflix_app/presentation/screens/tv_show_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieCarouselBloc movieCarouselBloc;
  late MovieBackdropBloc movieBackdropBloc;
  late MovieTabbedBloc movieTabbedBloc;
  late SearchMovieBloc searchMovieBloc;
  late TVShowBloc tvShowBloc;
  bool _isInitialized = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeBlocs();
    // Load TV shows for trending section
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tvShowBloc.add(LoadTVShows());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initializeBlocs() {
    try {
      movieCarouselBloc = getItInstance<MovieCarouselBloc>();
      movieBackdropBloc = movieCarouselBloc.movieBackdropBloc;
      movieTabbedBloc = getItInstance<MovieTabbedBloc>();
      searchMovieBloc = getItInstance<SearchMovieBloc>();
      tvShowBloc = getItInstance<TVShowBloc>();
      movieCarouselBloc.add(CarouselLoadEvent(defaultIndex: 1));
      _isInitialized = true;
    } catch (e) {
      print('Initialization error: $e');
      _isInitialized = false;
    }
  }

  void _clearSearchState() {
    // Clear search state and reload original data
    searchMovieBloc.add(SearchTermChangedEvent(''));
    tvShowBloc.add(LoadTVShows());
    movieCarouselBloc.add(CarouselLoadEvent(defaultIndex: 1));
  }

  @override
  void dispose() {
    if (_isInitialized) {
      movieCarouselBloc.close();
      movieBackdropBloc.close();
      movieTabbedBloc.close();
      searchMovieBloc.close();
      tvShowBloc.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error initializing app'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _initializeBlocs();
                  });
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieCarouselBloc>.value(
          value: movieCarouselBloc,
        ),
        BlocProvider<MovieBackdropBloc>.value(
          value: movieBackdropBloc,
        ),
        BlocProvider<MovieTabbedBloc>.value(
          value: movieTabbedBloc,
        ),
        BlocProvider<SearchMovieBloc>.value(
          value: searchMovieBloc,
        ),
        BlocProvider<TVShowBloc>.value(
          value: tvShowBloc,
        ),
      ],
      child: Scaffold(
        key: _scaffoldKey,
        drawer: custom_drawer.NavigationDrawer(),
        backgroundColor: Colors.black,
        body: BlocBuilder<MovieCarouselBloc, MovieCarouselState>(
          bloc: movieCarouselBloc,
          builder: (context, state) {
            return BlocBuilder<TVShowBloc, TVShowState>(
              bloc: tvShowBloc,
              builder: (context, tvState) {
                if (state is MovieCarouselInitial || tvState is TVShowInitial) {
              return Center(child: CircularProgressIndicator());
                } else if (state is MovieCarouselLoaded && tvState is TVShowLoaded) {
                  final featured = state.movies.isNotEmpty ? state.movies[0] : null;
                  // Combine movies and TV shows for trending
                  final trendingItems = [
                    ...state.movies.map((m) => {'type': 'movie', 'item': m}),
                    ...tvState.tvShows.map((s) => {'type': 'series', 'item': s}),
                  ];
              return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar with profile and search
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    print('[DEBUG] Profile avatar tapped');
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: AssetImage('assets/pngs/icon.png'),
                                    radius: 20,
                                  ),
                                ),
                                Text(
                                  'TedFlix',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.search, color: Colors.white),
                                  onPressed: () async {
                                    await showSearch(
                                      context: context,
                                      delegate: CustomSearchDelegate(
                                        searchMovieBloc: searchMovieBloc,
                                        tvShowBloc: tvShowBloc,
                                      ),
                                    );
                                    // Clear search state when returning from search
                                    _clearSearchState();
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Movie and Series Carousel
                          MovieCarouselWidget(),
                          SizedBox(height: 32),
                          // Trending Now section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Trending Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            height: 180,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: trendingItems.length,
                              separatorBuilder: (context, index) => SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final trending = trendingItems[index];
                                if (trending['type'] == 'movie') {
                                  final movie = trending['item'] as dynamic;
                                  if (movie == null) return SizedBox.shrink();
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MovieDetailScreen(
                                            key: UniqueKey(),
                                            movieDetailArguments: MovieDetailArguments(movie.id),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            'https://image.tmdb.org/t/p/w342${movie.posterPath ?? ''}',
                                            width: 110,
                                            height: 150,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(
                                                width: 110,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: Colors.grey[900],
                                                ),
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded / 
                                                          loadingProgress.expectedTotalBytes!
                                                        : null,
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                width: 110,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: Colors.grey[900],
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.error_outline,
                                                    color: Colors.white54,
                                                    size: 24,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          width: 110,
                                          child: Text(
                                            movie.title ?? '',
                                            style: TextStyle(color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                final series = trending['item'] as dynamic;
                                if (series == null) return SizedBox.shrink();
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TVShowDetailScreen(
                                          tvShowId: series.id,
                                        ),
                                      ),
                                    );
                                  },
                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w342${series.posterPath ?? ''}',
                                          width: 110,
                                          height: 150,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              width: 110,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.grey[900],
                                              ),
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded / 
                                                        loadingProgress.expectedTotalBytes!
                                                      : null,
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 110,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.grey[900],
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.error_outline,
                                                  color: Colors.white54,
                                                  size: 24,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      SizedBox(
                                        width: 110,
                                        child: Text(
                                          series.name ?? '',
                                          style: TextStyle(color: Colors.white),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                ),
              );
            } else if (state is MovieCarouselError) {
              return AppErrorWidget(
                key: Key('error_widget'),
                onPressed: () => movieCarouselBloc.add(
                  CarouselLoadEvent(),
                ),
                errorType: state.errorType,
              );
            }
            return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
