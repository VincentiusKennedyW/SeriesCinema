// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';

part 'popular_movie_event.dart';
part 'popular_movie_state.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies getPopularMovies;
  PopularMovieBloc(this.getPopularMovies) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMoviesLoading());

      final result = await getPopularMovies.execute();

      result.fold(
        (failure) => emit(PopularMoviesError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(PopularMoviesEmpty());
          } else {
            emit(PopularMoviesHasData(data));
          }
        },
      );
    });
  }
}
