// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';

part 'watchlist_status_movie_event.dart';
part 'watchlist_status_movie_state.dart';

class WatchlistStatusMovieBloc
    extends Bloc<WatchlistStatusMovieEvent, WatchlistStatusMovieState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  WatchlistStatusMovieBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const WatchlistStatusMovieState(
            isAddedToWatchlist: false, message: '')) {
    on<AddWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final id = movieDetail.id;

      final result = await saveWatchlist.execute(movieDetail);
      final status = await getWatchListStatus.execute(id);

      result.fold(
        (failure) {
          emit(WatchlistStatusMovieState(
            isAddedToWatchlist: status,
            message: failure.message,
          ));
        },
        (successMessage) {
          emit(WatchlistStatusMovieState(
            isAddedToWatchlist: status,
            message: successMessage,
          ));
        },
      );
    });

    on<RemoveFromWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final id = movieDetail.id;

      final result = await removeWatchlist.execute(movieDetail);
      final status = await getWatchListStatus.execute(id);

      result.fold(
        (failure) {
          emit(WatchlistStatusMovieState(
            isAddedToWatchlist: status,
            message: failure.message,
          ));
        },
        (successMessage) {
          emit(WatchlistStatusMovieState(
            isAddedToWatchlist: status,
            message: successMessage,
          ));
        },
      );
    });

    on<LoadWatchlistStatusMovie>((event, emit) async {
      final id = event.id;
      final status = await getWatchListStatus.execute(id);

      emit(WatchlistStatusMovieState(
        isAddedToWatchlist: status,
        message: '',
      ));
    });
  }
}
