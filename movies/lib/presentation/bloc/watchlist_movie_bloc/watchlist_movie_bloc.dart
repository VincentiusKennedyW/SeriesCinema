import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;
  WatchlistMovieBloc(this.getWatchlistMovies) : super(WatchlistMoviesEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMoviesLoading());

      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(WatchlistMoviesError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(WatchlistMoviesEmpty());
          } else {
            emit(WatchlistMoviesHasData(data));
          }
        },
      );
    });
  }
}
