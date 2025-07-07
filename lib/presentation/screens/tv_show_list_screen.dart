import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tedflix_app/domain/entities/tv_show_entity.dart';
import 'package:tedflix_app/presentation/blocs/tv_show_bloc.dart';
import 'package:tedflix_app/presentation/widgets/tv_show_card.dart';
import 'package:tedflix_app/presentation/widgets/banner_ad_widget.dart';
import 'package:tedflix_app/presentation/widgets/app_error_widget.dart';
import 'package:tedflix_app/di/get_it.dart';

class TVShowListScreen extends StatefulWidget {
  const TVShowListScreen({Key? key}) : super(key: key);

  @override
  State<TVShowListScreen> createState() => _TVShowListScreenState();
}

class _TVShowListScreenState extends State<TVShowListScreen> {
  late TVShowBloc _tvShowBloc;

  @override
  void initState() {
    super.initState();
    _tvShowBloc = getItInstance<TVShowBloc>();
    _tvShowBloc.add(LoadTVShows());
  }

  @override
  void dispose() {
    _tvShowBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TV Shows'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _tvShowBloc,
        child: BlocBuilder<TVShowBloc, TVShowState>(
          builder: (context, state) {
            if (state is TVShowLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TVShowLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: _buildTVShowGrid(state.tvShows),
                  ),
                  BannerAdWidget(),
                ],
              );
            } else if (state is TVShowError) {
              return AppErrorWidget(
                errorType: state.errorType,
                onPressed: () {
                  _tvShowBloc.add(LoadTVShows());
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildTVShowGrid(List<TVShowEntity> tvShows) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: tvShows.length,
      itemBuilder: (context, index) {
        final tvShow = tvShows[index];
        return TVShowCard(
          tvShow: tvShow,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/tv_show_detail',
              arguments: tvShow.id,
            );
          },
        );
      },
    );
  }
}
