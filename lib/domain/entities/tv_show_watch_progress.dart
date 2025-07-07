import 'package:equatable/equatable.dart';

class TVShowWatchProgress extends Equatable {
  final int tvShowId;
  final int seasonNumber;
  final int episodeNumber;
  final double progress;
  final DateTime lastWatchedAt;

  const TVShowWatchProgress({
    required this.tvShowId,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.progress,
    required this.lastWatchedAt,
  });

  @override
  List<Object> get props =>
      [tvShowId, seasonNumber, episodeNumber, progress, lastWatchedAt];
}
