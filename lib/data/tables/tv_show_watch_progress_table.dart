import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:tedflix_app/domain/entities/tv_show_watch_progress.dart';

part 'tv_show_watch_progress_table.g.dart';

@HiveType(typeId: 2)
class TVShowWatchProgressTable extends Equatable {
  @HiveField(0)
  final int tvShowId;

  @HiveField(1)
  final int seasonNumber;

  @HiveField(2)
  final int episodeNumber;

  @HiveField(3)
  final double progress; // 0.0 to 1.0

  @HiveField(4)
  final DateTime lastWatchedAt;

  const TVShowWatchProgressTable({
    required this.tvShowId,
    required this.seasonNumber,
    required this.episodeNumber,
    required this.progress,
    required this.lastWatchedAt,
  });

  factory TVShowWatchProgressTable.fromEntity(TVShowWatchProgress entity) {
    return TVShowWatchProgressTable(
      tvShowId: entity.tvShowId,
      seasonNumber: entity.seasonNumber,
      episodeNumber: entity.episodeNumber,
      progress: entity.progress,
      lastWatchedAt: entity.lastWatchedAt,
    );
  }

  TVShowWatchProgress toEntity() {
    return TVShowWatchProgress(
      tvShowId: tvShowId,
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      progress: progress,
      lastWatchedAt: lastWatchedAt,
    );
  }

  @override
  List<Object> get props =>
      [tvShowId, seasonNumber, episodeNumber, progress, lastWatchedAt];
}
