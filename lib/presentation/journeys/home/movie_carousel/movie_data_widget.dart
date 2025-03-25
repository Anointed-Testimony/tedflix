import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/presentation/blocs/movie_backdrop/movie_backdrop_bloc.dart';

class MovieDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBackdropBloc, MovieBackdropState>(
      builder: (context, state) {
        // Debugging: Print the current state
        print('MovieDataWidget: Current state: $state');

        if (state is MovieBackdropChanged) {
          // Debugging: Print the movie title when state changes
          print('MovieDataWidget: Movie title updated to: ${state.movie.title}');
          
        return Text(
          state.movie.title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white, 
          ),
        );
      }

        // Debugging: Print a message when no valid state is found
        print('MovieDataWidget: No movie title available, returning empty widget.');
        return const SizedBox.shrink();
      },
    );
  }
}
