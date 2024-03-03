import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';
import 'package:movies/presentation/bloc/watchlist_status_movie_bloc/watchlist_status_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_status_movies_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late WatchlistStatusMovieBloc watchlistStatusMovieBloc;
  late MockGetWatchListStatusMovie mockGetWatchListStatusMovie;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetWatchListStatusMovie = MockGetWatchListStatusMovie();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    watchlistStatusMovieBloc = WatchlistStatusMovieBloc(
      getWatchListStatus: mockGetWatchListStatusMovie,
      saveWatchlist: mockSaveWatchlistMovie,
      removeWatchlist: mockRemoveWatchlistMovie,
    );
  });

  const tId = 1;

  group('Watchlist Status Movies', () {
    blocTest<WatchlistStatusMovieBloc, WatchlistStatusMovieState>(
      'Should emit [WatchlistStatusState] when get watchlist status true',
      build: () {
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatusMovie(tId)),
      expect: () => [
        const WatchlistStatusMovieState(isAddedToWatchlist: true, message: ''),
      ],
    );
  });

  group('Save Watchlist Movies', () {
    blocTest<WatchlistStatusMovieBloc, WatchlistStatusMovieState>(
      'Should emit [WatchlistStatusState] when data is saved',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        const WatchlistStatusMovieState(
          isAddedToWatchlist: true,
          message: 'Added to Watchlist',
        ),
      ],
      verify: (bloc) => [
        verify(mockSaveWatchlistMovie.execute(testMovieDetail)),
        verify(mockGetWatchListStatusMovie.execute(tId)),
      ],
    );

    blocTest<WatchlistStatusMovieBloc, WatchlistStatusMovieState>(
      'Should emit [WatchlistStatusState] when save data is unsuccessful',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail)).thenAnswer(
            (_) async =>
                const Left(DatabaseFailure('Failed Added to Watchlist')));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => false);
        return watchlistStatusMovieBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        const WatchlistStatusMovieState(
          isAddedToWatchlist: false,
          message: 'Failed Added to Watchlist',
        ),
      ],
      verify: (bloc) => [
        verify(mockSaveWatchlistMovie.execute(testMovieDetail)),
        verify(mockGetWatchListStatusMovie.execute(tId)),
      ],
    );
  });

  group('Remove Watchlist Movies', () {
    blocTest<WatchlistStatusMovieBloc, WatchlistStatusMovieState>(
      'Should emit [WatchlistStatusState] when data is removed',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => false);
        return watchlistStatusMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        const WatchlistStatusMovieState(
          isAddedToWatchlist: false,
          message: 'Removed from Watchlist',
        ),
      ],
      verify: (bloc) => [
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail)),
        verify(mockGetWatchListStatusMovie.execute(tId)),
      ],
    );

    blocTest<WatchlistStatusMovieBloc, WatchlistStatusMovieState>(
      'Should emit [WatchlistStatusState] when remove data is unsuccessful',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail)).thenAnswer(
            (_) async =>
                const Left(DatabaseFailure('Failed Removed from Watchlist')));
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistStatusMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        const WatchlistStatusMovieState(
          isAddedToWatchlist: true,
          message: 'Failed Removed from Watchlist',
        ),
      ],
      verify: (bloc) => [
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail)),
        verify(mockGetWatchListStatusMovie.execute(tId)),
      ],
    );
  });
}
