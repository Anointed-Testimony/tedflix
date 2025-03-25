import 'package:flutter/material.dart';
import 'package:tedflix_app/common/constants/route_constants.dart';
import 'package:tedflix_app/presentation/journeys/home/home_screen.dart';
import 'package:tedflix_app/presentation/journeys/loading/loading_screen.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_screen.dart';
import 'package:tedflix_app/presentation/journeys/favorite/favorite_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => LoadingScreen(
          key: Key('loading'),
          screen: HomeScreen()
        ), // Or any other screen

        RouteList.home: (context) => HomeScreen(),
        RouteList.movieDetail: (context) {
          final args = setting.arguments;
          if (args is MovieDetailArguments) {
            return MovieDetailScreen(
              key: Key('movie_detail'),
              movieDetailArguments: args,
            );
          } else {
            // Handle the error or return a default widget
            return ErrorScreen(); // Replace with your error handling widget
          }
        },

        RouteList.favorite: (context) => FavoriteScreen(),
      };
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(child: Text('An error occurred.')),
    );
  }
}
