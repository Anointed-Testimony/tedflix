import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:tedflix_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:tedflix_app/presentation/blocs/search_movie/search_movie_bloc.dart';
import 'package:tedflix_app/presentation/widgets/app_error_widget.dart';
import 'package:tedflix_app/presentation/journeys/home/movie_carousel/movie_carousel_widget.dart';
import 'package:tedflix_app/presentation/journeys/home/movie_tabbed/movie_tabbed_widget.dart';
import 'package:tedflix_app/presentation/journeys/drawer/navigation_drawer.dart'
    as custom_drawer; // Use prefix

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieCarouselBloc movieCarouselBloc;
  late MovieBackdropBloc movieBackdropBloc;
  late MovieTabbedBloc movieTabbedBloc;
  late SearchMovieBloc searchMovieBloc;

  @override
  void initState() {
    super.initState();
    try {
      movieCarouselBloc = getItInstance<MovieCarouselBloc>();
      movieBackdropBloc = movieCarouselBloc.movieBackdropBloc;
      movieTabbedBloc = getItInstance<MovieTabbedBloc>();
      searchMovieBloc = getItInstance<SearchMovieBloc>();
      movieCarouselBloc.add(CarouselLoadEvent(defaultIndex: 1));
    } catch (e) {
      print('Initialization error: $e');
    }
  }

  @override
  void dispose() {
    movieCarouselBloc.close();
    movieBackdropBloc.close();
    movieTabbedBloc.close(); // Ensure this is not null
    searchMovieBloc.close(); // Ensure this is not null
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      ],
      child: Scaffold(
        drawer: custom_drawer.NavigationDrawer(), // Use the prefixed name
        body: BlocBuilder<MovieCarouselBloc, MovieCarouselState>(
          bloc: movieCarouselBloc,
          builder: (context, state) {
            if (state is MovieCarouselInitial) {
              print('MovieCarouselBloc: Initial state');
              return Center(
                  child:
                      CircularProgressIndicator()); // Loader while data is being fetched
            } else if (state is MovieCarouselLoaded) {
              print(
                  'MovieCarouselBloc: Loaded state with movies: ${state.movies}');
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FractionallySizedBox(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.6,
                    child: MovieCarouselWidget(
                      key: Key('movie_carousel_widget'),
                      movies: state.movies,
                      defaultIndex: state.defaultIndex,
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0.4,
                    child: MovieTabbedWidget(),
                  ),
                ],
              );
            } else if (state is MovieCarouselError) {
              print('MovieCarouselBloc: Error state');
              return AppErrorWidget(
                key: Key('value'),
                onPressed: () => movieCarouselBloc.add(
                  CarouselLoadEvent(),
                ),
                errorType: state.errorType,
              );
            }
            print('MovieCarouselBloc: Unknown state');
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}