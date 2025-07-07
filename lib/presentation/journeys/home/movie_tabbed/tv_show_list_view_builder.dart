import 'package:flutter/material.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/presentation/widgets/tv_show_card.dart';

class TVShowListViewBuilder extends StatelessWidget {
  final List<TVShowEntity> tvShows;

  const TVShowListViewBuilder({
    required Key key,
    required this.tvShows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h.toDouble()),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: tvShows.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 14.w.toDouble(),
          );
        },
        itemBuilder: (context, index) {
          final TVShowEntity tvShow = tvShows[index];
          return TVShowCard(
            key: Key('tv_show_card_${tvShow.id}'),
            tvShow: tvShow,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/tv_show_detail',
                arguments: tvShow.id,
              );
            },
          );
        },
      ),
    );
  }
}
