import 'package:tedflix_app/common/constants/translation_constants.dart';
import 'package:tedflix_app/domain/entities/movie_tab.dart';

import 'tab.dart';

class MovieTabbedConstants {
  static const List<MovieTab> movieTabs = [
    MovieTab(index: 0, title: 'Popular Movies'),
    MovieTab(index: 1, title: 'Now Playing'),
    MovieTab(index: 2, title: 'Coming Soon'),
    MovieTab(index: 3, title: 'Popular TV Shows'),
    MovieTab(index: 4, title: 'Airing Today'),
    MovieTab(index: 5, title: 'On The Air'),
  ];
}
