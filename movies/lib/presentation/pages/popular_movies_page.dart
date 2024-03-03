// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/presentation/bloc/popular_movie_bloc/popular_movie_bloc.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<PopularMovieBloc>().add(FetchPopularMovies()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movies'),
      ),
      body: BlocBuilder<PopularMovieBloc, PopularMovieState>(
        builder: (_, state) {
          if (state is PopularMoviesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PopularMoviesHasData) {
            return ListView.builder(
              itemBuilder: (_, index) {
                final movie = state.result[index];
                return MovieCard(movie);
              },
              itemCount: state.result.length,
            );
          } else if (state is PopularMoviesError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: Text('Empty data'),
            );
          }
        },
      ),
    );
  }
}
