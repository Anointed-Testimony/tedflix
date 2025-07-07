import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/di/get_it.dart';
import 'package:tedflix_app/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:tedflix_app/presentation/journeys/home/movie_tabbed/movie_tabbed_widget.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getItInstance<MovieTabbedBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movies'),
        ),
        body: MovieTabbedWidget(),
      ),
    );
  }
}
