import 'package:flutter/material.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';

import 'favorite_tv_show_card_widget.dart';

class FavoriteTVShowGridView extends StatelessWidget {
  final List<TVShowEntity> tvShows;

  const FavoriteTVShowGridView({
    required Key key,
    required this.tvShows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_8.w.toDouble()),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: tvShows.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: Sizes.dimen_16.w.toDouble(),
        ),
        itemBuilder: (context, index) {
          return FavoriteTVShowCardWidget(
            key: Key('favorite_tv_show_card'),
            tvShow: tvShows[index],
          );
        },
      ),
    );
  }
} 