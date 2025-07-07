import 'package:flutter/material.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/core/constants/api_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteTVShowCardWidget extends StatelessWidget {
  final TVShowEntity tvShow;

  const FavoriteTVShowCardWidget({
    required Key key,
    required this.tvShow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/tv_show_detail',
          arguments: tvShow.id,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.dimen_8.w.toDouble()),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.dimen_8.w.toDouble()),
          child: CachedNetworkImage(
            imageUrl: '${ApiConstants.BASE_IMAGE_URL}${tvShow.posterPath}',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[800],
              child: const Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
} 