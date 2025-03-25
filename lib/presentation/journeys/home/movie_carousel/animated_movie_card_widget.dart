import 'package:flutter/material.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/common/screenutil/screenutil.dart';
import 'movie_card_widget.dart';

class AnimatedMovieCardWidget extends StatelessWidget {
  final int index;
  final int movieId;
  final String posterPath;
  final PageController pageController;

  const AnimatedMovieCardWidget({
    required Key key,
    required this.index,
    required this.movieId,
    required this.posterPath,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double value = 1.0;

        if (pageController.position.haveDimensions && pageController.page != null) {
          final double page = pageController.page!;
          value = page - index;
          value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);

          // Debugging prints
          print('Page: $page, Index: $index, Value: $value');
        }

        double height = Curves.easeIn.transform(value) * ScreenUtil.screenHeight * 0.35;
        double width = Sizes.dimen_230.w.toDouble();

        // Debugging prints for height and width
        print('Height: $height, Width: $width');

        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: height,
            width: width,
            child: child,
          ),
        );
      },
      child: MovieCardWidget(
        key: Key('movie_card_${index}'), // Unique key per card
        movieId: movieId,
        posterPath: posterPath,
      ),
    );
  }
}
