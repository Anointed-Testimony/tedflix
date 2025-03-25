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
  }

  @override
  void dispose() {
    _movieDetailBloc?.close();
    _favoriteBloc?.close();
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
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BigPoster(
                      key: Key('value'),
                      movie: movieDetail,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.dimen_16.w.toDouble(),
                        vertical: Sizes.dimen_8.h.toDouble(),
                      ),
                      child: Text(
                        movieDetail.overview,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w.toDouble()),
                      child: Text(
                        "Cast",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    CastWidget(),
                    SizedBox(height: Sizes.dimen_16.h.toDouble()),
                    BannerAdWidget(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_16.w.toDouble()),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to another screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WatchPage(tmdbId: movieDetail.id.toString()),  // Pass the TMDb ID
                          ),
                        );

                        },
                        child: Text("Play Now"),
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
