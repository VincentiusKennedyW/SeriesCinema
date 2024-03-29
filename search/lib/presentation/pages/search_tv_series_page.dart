import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:search/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:tv_series/presentation/widgets/tv_series_card_list.dart';

class SearchTvSeriesPage extends StatelessWidget {
  const SearchTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchTvSeriesBloc>().add(OnQueryChanged(query));
              },
              decoration: const InputDecoration(
                hintText: 'Search name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchTvSeriesBloc, SearchTvSeriesState>(
                builder: (context, state) {
              if (state is SearchTvSeriesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SearchTvSeriesHasData) {
                final result = state.result;
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final tvSeries = result[index];
                      return TvSeriesCard(tvSeries);
                    },
                    itemCount: result.length,
                  ),
                );
              } else if (state is SearchTvSeriesEmpty) {
                return Expanded(
                  child: Center(
                    child: Text(
                      'Search Not Found',
                      style: kSubtitle,
                    ),
                  ),
                );
              } else if (state is SearchTvSeriesError) {
                return Expanded(
                  child: Center(
                    key: const Key('error_message'),
                    child: Text(state.message),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
