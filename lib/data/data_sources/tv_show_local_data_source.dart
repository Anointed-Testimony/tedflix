import 'package:hive/hive.dart';
import 'package:tedflix_app/data/tables/tv_show_table.dart';
import 'package:tedflix_app/data/tables/tv_show_watch_progress_table.dart';

abstract class TVShowLocalDataSource {
  Future<void> saveTVShow(TVShowTable tvShowTable);
  Future<List<TVShowTable>> getTVShows();
  Future<void> deleteTVShow(int tvShowId);
  Future<bool> checkIfTVShowFavorite(int tvShowId);
  Future<void> saveWatchProgress(TVShowWatchProgressTable progress);
  Future<TVShowWatchProgressTable?> getWatchProgress(
      int tvShowId, int seasonNumber, int episodeNumber);
  Future<List<TVShowWatchProgressTable>> getAllWatchProgress();
  Future<void> deleteWatchProgress(
      int tvShowId, int seasonNumber, int episodeNumber);
}

class TVShowLocalDataSourceImpl extends TVShowLocalDataSource {
  @override
  Future<bool> checkIfTVShowFavorite(int tvShowId) async {
    final tvShowBox = await Hive.openBox('tvShowBox');
    return tvShowBox.containsKey(tvShowId);
  }

  @override
  Future<void> deleteTVShow(int tvShowId) async {
    final tvShowBox = await Hive.openBox('tvShowBox');
    await tvShowBox.delete(tvShowId);
  }

  @override
  Future<List<TVShowTable>> getTVShows() async {
    final tvShowBox = await Hive.openBox('tvShowBox');
    final tvShowIds = tvShowBox.keys;
    List<TVShowTable> tvShows = [];
    tvShowIds.forEach((tvShowId) {
      tvShows.add(tvShowBox.get(tvShowId));
    });
    return tvShows;
  }

  @override
  Future<void> saveTVShow(TVShowTable tvShowTable) async {
    final tvShowBox = await Hive.openBox('tvShowBox');
    await tvShowBox.put(tvShowTable.id, tvShowTable);
  }

  @override
  Future<void> saveWatchProgress(TVShowWatchProgressTable progress) async {
    final progressBox = await Hive.openBox('tvShowWatchProgressBox');
    final key =
        '${progress.tvShowId}_${progress.seasonNumber}_${progress.episodeNumber}';
    await progressBox.put(key, progress);
  }

  @override
  Future<TVShowWatchProgressTable?> getWatchProgress(
      int tvShowId, int seasonNumber, int episodeNumber) async {
    final progressBox = await Hive.openBox('tvShowWatchProgressBox');
    final key = '${tvShowId}_${seasonNumber}_${episodeNumber}';
    return progressBox.get(key);
  }

  @override
  Future<List<TVShowWatchProgressTable>> getAllWatchProgress() async {
    final progressBox = await Hive.openBox('tvShowWatchProgressBox');
    final keys = progressBox.keys;
    List<TVShowWatchProgressTable> progress = [];
    keys.forEach((key) {
      progress.add(progressBox.get(key));
    });
    return progress;
  }

  @override
  Future<void> deleteWatchProgress(
      int tvShowId, int seasonNumber, int episodeNumber) async {
    final progressBox = await Hive.openBox('tvShowWatchProgressBox');
    final key = '${tvShowId}_${seasonNumber}_${episodeNumber}';
    await progressBox.delete(key);
  }
}
 