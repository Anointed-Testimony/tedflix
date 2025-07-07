import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tedflix_app/common/constants/route_constants.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/data/core/api_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/presentation/themes/theme_text.dart';
import 'package:tedflix_app/domain/entities/movie_entity.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_arguments.dart';
import 'package:tedflix_app/presentation/journeys/movie_detail/movie_detail_screen.dart';

class SearchMovieCard extends StatelessWidget {
  final MovieEntity movie;

  const SearchMovieCard({
    required Key key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              key: Key('moviedetail'),
              movieDetailArguments: MovieDetailArguments(movie.id),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      child: Padding(
          padding: EdgeInsets.all(12),
        child: Row(
          children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConstants.BASE_IMAGE_URL}${movie.posterPath}',
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey.withOpacity(0.3),
                      child: Icon(
                        Icons.movie,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey.withOpacity(0.3),
                      child: Icon(
                        Icons.error,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                ),
              ),
            ),
              SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                  ),
                    SizedBox(height: 8),
                  Text(
                    movie.overview ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                  ),
                ],
              ),
            ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.5),
                size: 16,
              ),
          ],
          ),
        ),
      ),
    );
  }
}
