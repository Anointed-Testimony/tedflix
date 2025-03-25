import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/common/constants/size_constants.dart';
import 'package:tedflix_app/common/extensions/size_extensions.dart';
import 'package:tedflix_app/presentation/blocs/movie_tabbed/movie_tabbed_bloc.dart';
import 'package:tedflix_app/presentation/journeys/home/movie_tabbed/tab_title_widget.dart';
import 'package:tedflix_app/presentation/journeys/loading/loading_circle.dart';
import 'package:tedflix_app/presentation/widgets/app_error_widget.dart';

import 'movie_list_view_builder.dart';
import 'movie_tabbed_constants.dart';

class MovieTabbedWidget extends StatefulWidget {
  @override
  _MovieTabbedWidgetState createState() => _MovieTabbedWidgetState();
}

class _MovieTabbedWidgetState extends State<MovieTabbedWidget>
    with SingleTickerProviderStateMixin {
  MovieTabbedBloc get movieTabbedBloc => BlocProvider.of<MovieTabbedBloc>(context);

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    movieTabbedBloc.add(MovieTabChangedEvent(currentTabIndex: currentTabIndex));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieTabbedBloc, MovieTabbedState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: Sizes.dimen_4.h.toDouble()),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i = 0; i < MovieTabbedConstants.movieTabs.length; i++)
                    TabTitleWidget(
                      key: Key('TabTitle_$i'), // Use the index to make each key unique
                      title: MovieTabbedConstants.movieTabs[i].title,
                      onTap: () => _onTabTapped(i),
                      isSelected: MovieTabbedConstants.movieTabs[i].index == state.currentTabIndex,
                    ),
                ],
              ),
              if (state is MovieTabChanged)
                Expanded(
                  child: MovieListViewBuilder(
                    movies: state.movies,
                    key: Key('movie_list'), // Fixed Key string
                  ),
                ),
              if (state is MovieTabLoadError)
                AppErrorWidget(
                  errorType: state.errorType,
                  onPressed: () => movieTabbedBloc.add(MovieTabChangedEvent(
                    currentTabIndex: state.currentTabIndex,
                  )),
                ),
              if (state is MovieTabLoading) // Correctly nested
                Expanded(
                  child: Center(
                    child: LoadingCircle(
                      key: Key('circle'),
                      size: Sizes.dimen_100.w.toDouble(),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onTabTapped(int index) {
    movieTabbedBloc.add(MovieTabChangedEvent(currentTabIndex: index));
  }
}
