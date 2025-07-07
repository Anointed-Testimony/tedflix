import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/domain/entities/cast_entity.dart';
import 'package:tedflix_app/presentation/blocs/cast_bloc.dart' as tv_cast;
import 'package:tedflix_app/core/constants/api_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CastWidget extends StatelessWidget {
  final int tvShowId;

  const CastWidget({
    Key? key,
    required this.tvShowId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<tv_cast.CastBloc, tv_cast.CastState>(
      builder: (context, state) {
        if (state is tv_cast.CastLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is tv_cast.CastLoaded) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.cast.length,
              itemBuilder: (context, index) {
                final cast = state.cast[index];
                return _buildCastCard(cast);
              },
            ),
          );
        } else if (state is tv_cast.CastError) {
          return Center(
            child: Text('Error: ${state.errorType}'),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCastCard(CastEntity cast) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: '${ApiConstants.BASE_IMAGE_URL}${cast.posterPath}',
                width: 120,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            cast.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (cast.character != null) ...[
            const SizedBox(height: 2),
            Text(
              cast.character!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
