import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/domain/entities/app_error.dart';
import 'package:tedflix_app/presentation/blocs/movie_carousel/movie_carousel_bloc.dart';

class AppErrorWidget extends StatelessWidget {
  final AppErrorType errorType;
  final VoidCallback onPressed;

  const AppErrorWidget({
    Key? key,
    required this.errorType,
    required this.onPressed,
  }) : super(key: key);

  String _getErrorMessage() {
    switch (errorType) {
      case AppErrorType.api:
        return 'Something went wrong...';
      case AppErrorType.network:
        return 'Please check your network connection and press Retry button';
      case AppErrorType.database:
        return 'Database error occurred. Please try again.';
      case AppErrorType.tvShowNotFound:
        return 'TV Show not found. Please try again.';
      case AppErrorType.seasonNotFound:
        return 'Season not found. Please try again.';
      case AppErrorType.episodeNotFound:
        return 'Episode not found. Please try again.';
      case AppErrorType.watchProgressNotFound:
        return 'Watch progress not found. Please try again.';
      case AppErrorType.invalidWatchProgress:
        return 'Invalid watch progress. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Sizes.dimen_32.w.toDouble()),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getErrorMessage(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: onPressed,
                child: Text('Retry'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
