import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedflix_app/presentation/blocs/search_movie/search_movie_bloc.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_bloc.dart';
import 'package:tedflix_app/presentation/journeys/search_movie/custom_search_movie_delegate.dart';

import '../../common/constants/size_constants.dart';
import '../../common/extensions/size_extensions.dart';
import '../../common/screenutil/screenutil.dart';
import 'logo.dart';

class MovieAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil.statusBarHeight + Sizes.dimen_4.h.toDouble(),
        left: Sizes.dimen_16.w.toDouble(),
        right: Sizes.dimen_16.w.toDouble(),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: SvgPicture.asset(
              'assets/svgs/menu.svg',
              height: Sizes.dimen_12.h.toDouble(),
            ),
          ),
          Expanded(
            child: const Logo(
              height: Sizes.dimen_14,
            ),
          ),
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(
                  searchMovieBloc: BlocProvider.of<SearchMovieBloc>(context),
                  tvShowBloc: BlocProvider.of<TVShowBloc>(context),
                ),
              );
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: Sizes.dimen_12.h.toDouble(),
            ),
          ),
        ],
      ),
    );
  }
}
