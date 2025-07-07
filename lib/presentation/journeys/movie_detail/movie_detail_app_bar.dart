import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/domain/entities/movie_detail_entity.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/presentation/blocs/favorite/favorite_bloc.dart';

class MovieDetailAppBar extends StatelessWidget {

  final MovieDetailEntity movieDetailEntity;

    const MovieDetailAppBar({
    required Key key,
    required this.movieDetailEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: EdgeInsets.all(4),
          child: Icon(
              Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
              size: 22,
            ),
          ),
        ),
        BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            bool isFavorite = false;
            if (state is IsFavoriteMovie) {
              isFavorite = state.isMovieFavorite;
            }
              return GestureDetector(
                onTap: () => BlocProvider.of<FavoriteBloc>(context).add(
                  ToggleFavoriteMovieEvent(
                    MovieEntity.fromMovieDetailEntity(movieDetailEntity),
                  isFavorite,
                  ),
                ),
              child: AnimatedScale(
                scale: isFavorite ? 1.2 : 1.0,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                ),
                    ],
                  ),
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.redAccent : Colors.white,
                    size: 22,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
