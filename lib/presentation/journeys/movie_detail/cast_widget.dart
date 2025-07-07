import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/data/core/api_constants.dart';
import 'package:tedflix_app/presentation/blocs/cast/cast_bloc.dart';
import 'package:tedflix_app/presentation/themes/theme_text.dart';

class CastWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CastBloc, CastState>(
      builder: (context, state) {
        if (state is CastLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CastError) {
          return Center(
            child: Text('Error loading cast data'),
          );
        } else if (state is CastLoaded) {
          if (state.casts.isEmpty) {
            return Center(
              child: Text('No cast data available'),
            );
          }

          return SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.casts.length > 10 ? 10 : state.casts.length,
              separatorBuilder: (context, index) => SizedBox(width: 16),
              itemBuilder: (context, index) {
                final castEntity = state.casts[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                      ),
                        ],
                        border: Border.all(color: Colors.white24, width: 2),
                      ),
                      child: ClipOval(
                        child: castEntity.posterPath != null && castEntity.posterPath.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: '${ApiConstants.BASE_IMAGE_URL}${castEntity.posterPath}',
                                fit: BoxFit.cover,
                                width: 64,
                                height: 64,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                errorWidget: (context, url, error) => Icon(Icons.person, size: 40, color: Colors.white38),
                              )
                            : Icon(Icons.person, size: 40, color: Colors.white38),
                              ),
                            ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: 72,
                          child: Text(
                            castEntity.name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                          ),
                    SizedBox(
                      width: 72,
                          child: Text(
                            castEntity.character,
                        textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                      ],
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
