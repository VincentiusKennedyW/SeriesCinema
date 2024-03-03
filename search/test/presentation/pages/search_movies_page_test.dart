import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/bloc/movies/search_movie_bloc.dart';
import 'package:search/presentation/pages/search_movies_page.dart';

import '../../dummy_data/dummy_movie_objects.dart';

class MockSearchMoviesBloc extends MockBloc<SearchMovieEvent, SearchMovieState>
    implements SearchMovieBloc {}

class FakeSearchMoviesEvent extends Fake implements SearchMovieEvent {}

class FakeSearchMoviesState extends Fake implements SearchMovieState {}

void main() {
  late MockSearchMoviesBloc mockSearchMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchMoviesEvent());
    registerFallbackValue(FakeSearchMoviesState());
  });

  setUp(() {
    mockSearchMoviesBloc = MockSearchMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMovieBloc>.value(
      value: mockSearchMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockSearchMoviesBloc.state).thenReturn(SearchMovieLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockSearchMoviesBloc.state)
        .thenReturn(SearchMovieHasData(testMovieList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockSearchMoviesBloc.state)
        .thenReturn(SearchMovieHasData(testMovieList));

    final formSearch = find.byType(TextField);
    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    await tester.enterText(formSearch, 'spiderman');
    await tester.pump();

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display Text when data is empty',
      (WidgetTester tester) async {
    when(() => mockSearchMoviesBloc.state).thenReturn(SearchMovieEmpty());

    final textErrorBarFinder = find.text('Search Not Found');

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockSearchMoviesBloc.state)
        .thenReturn(const SearchMovieError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

    expect(textFinder, findsOneWidget);
  });
}
