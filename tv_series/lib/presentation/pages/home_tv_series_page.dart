// ignore_for_file: library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing_tv_series_bloc/now_playing_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc/top_rated_tv_series_bloc.dart';

class HomeTvSeriesPage extends StatefulWidget {
  const HomeTvSeriesPage({super.key});

  @override
  _HomeTvSeriesPageState createState() => _HomeTvSeriesPageState();
}

class _HomeTvSeriesPageState extends State<HomeTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingTvSeriesBloc>().add(FetchNowPlayingTvSeries());
      context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeries());
      context.read<TopRatedTvSeriesBloc>().add(FetchTopRatedTvSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeading(
              title: 'Now Playing',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  NOW_PLAYING_TV_SERIES_ROUTE,
                );
              },
            ),
            BlocBuilder<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
              builder: (_, state) {
                if (state is NowPlayingTvSeriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NowPlayingTvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is NowPlayingTvSeriesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Failed'));
                }
              },
            ),
            _buildSubHeading(
              title: 'Popular',
              onTap: () =>
                  Navigator.pushNamed(context, POPULAR_TV_SERIES_ROUTE),
            ),
            BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
              builder: (_, state) {
                if (state is PopularTvSeriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PopularTvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is PopularTvSeriesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Failed'));
                }
              },
            ),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () =>
                  Navigator.pushNamed(context, TOP_RATED_TV_SERIES_ROUTE),
            ),
            BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
              builder: (_, state) {
                if (state is TopRatedTvSeriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TopRatedTvSeriesHasData) {
                  return TvSeriesList(state.result);
                } else if (state is TopRatedTvSeriesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Failed'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvSeriesList extends StatelessWidget {
  final List<TvSeries> tvSeriess;

  const TvSeriesList(this.tvSeriess, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvSeries = tvSeriess[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TV_SERIES_DETAIL_ROUTE,
                  arguments: tvSeries.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tvSeries.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeriess.length,
      ),
    );
  }
}
