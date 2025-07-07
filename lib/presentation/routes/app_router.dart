import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/presentation/screens/tv_show_list_screen.dart';
import 'package:tedflix_app/presentation/screens/tv_show_detail_screen.dart';
import 'package:tedflix_app/presentation/screens/season_detail_screen.dart';
import 'package:tedflix_app/presentation/blocs/cast_bloc.dart';
import 'package:tedflix_app/presentation/blocs/season_bloc.dart';
import 'package:tedflix_app/di/get_it.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/tv_shows':
        return MaterialPageRoute(builder: (_) => const TVShowListScreen());
      case '/tv_show_detail':
        final tvShowId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getItInstance<CastBloc>(),
            child: TVShowDetailScreen(tvShowId: tvShowId),
          ),
        );
      case '/season_detail':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getItInstance<SeasonBloc>(),
            child: SeasonDetailScreen(
              tvShowId: args['tvShowId'],
              seasonNumber: args['seasonNumber'],
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
