import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/presentation/bloc/recommendation_movie_bloc/recommendation_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'recommendation_movies_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late RecommendationMovieBloc recommendationMovieBloc;
  late MockGetRecommendationMovie mockGetRecommendationMovie;

  setUp(() {
    mockGetRecommendationMovie = MockGetRecommendationMovie();
    recommendationMovieBloc =
        RecommendationMovieBloc(mockGetRecommendationMovie);
  });

  const tId = 1;
  final tMovieList = <Movie>[testMovieList[0]];

  test('initial state should be empty', () {
    expect(recommendationMovieBloc.state, RecommendationMovieEmpty());
  });

  blocTest<RecommendationMovieBloc, RecommendationMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetRecommendationMovie.execute(tId))
          .thenAnswer((_) async => Right(tMovieList));
      return recommendationMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationMovie(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      RecommendationMovieLoading(),
      RecommendationMovieHasData(tMovieList),
    ],
    verify: (bloc) => verify(mockGetRecommendationMovie.execute(tId)),
  );

  blocTest<RecommendationMovieBloc, RecommendationMovieState>(
    'Should emit [Loading, Empty] when data is empty',
    build: () {
      when(mockGetRecommendationMovie.execute(tId))
          .thenAnswer((_) async => const Right([]));
      return recommendationMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationMovie(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      RecommendationMovieLoading(),
      RecommendationMovieEmpty(),
    ],
    verify: (bloc) => verify(mockGetRecommendationMovie.execute(tId)),
  );

  blocTest<RecommendationMovieBloc, RecommendationMovieState>(
    'Should emit [Loading, Error] when get recommendations movies is unsuccessful',
    build: () {
      when(mockGetRecommendationMovie.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return recommendationMovieBloc;
    },
    act: (bloc) => bloc.add(const FetchRecommendationMovie(tId)),
    expect: () => [
      RecommendationMovieLoading(),
      const RecommendationMovieError('Server Failure'),
    ],
    verify: (bloc) => verify(mockGetRecommendationMovie.execute(tId)),
  );
}
