import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_series_local_data_source.dart';
import 'package:core/data/datasources/tv_series_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/utils/http_ssl_pinning.dart';
import 'package:core/utils/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/domain/usecases/get_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist.dart';
import 'package:movies/domain/usecases/save_watchlist.dart';
import 'package:movies/presentation/bloc/detail_movie_bloc/detail_movie_bloc.dart';
import 'package:movies/presentation/bloc/now_playing_movie_bloc/now_playing_movie_bloc.dart';
import 'package:movies/presentation/bloc/popular_movie_bloc/popular_movie_bloc.dart';
import 'package:movies/presentation/bloc/recommendation_movie_bloc/recommendation_movie_bloc.dart';
import 'package:movies/presentation/bloc/top_rated_movie_bloc/top_rated_movie_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_movie_bloc/watchlist_movie_bloc.dart';
import 'package:movies/presentation/bloc/watchlist_status_movie_bloc/watchlist_status_movie_bloc.dart';
import 'package:search/bloc/movies/search_movie_bloc.dart';
import 'package:search/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:search/search.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/detail_tv_series_bloc/detail_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/now_playing_tv_series_bloc/now_playing_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/recommendation_tv_series_bloc/recommendation_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_status_tv_series_bloc/watchlist_status_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/watchlist_tv_series_bloc/watchlist_tv_series_bloc.dart';

final locator = GetIt.instance;

void init() {
  // BLOC Movie
  locator.registerFactory(() => NowPlayingMovieBloc(locator()));
  locator.registerFactory(() => PopularMovieBloc(locator()));
  locator.registerFactory(() => TopRatedMovieBloc(locator()));
  locator.registerFactory(() => DetailMovieBloc(locator()));
  locator.registerFactory(() => RecommendationMovieBloc(locator()));
  locator.registerFactory(() => WatchlistMovieBloc(locator()));
  locator.registerFactory(() => WatchlistStatusMovieBloc(
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
      ));
  locator.registerFactory(() => SearchMovieBloc(locator()));
  // BLOC Tv Series
  locator.registerFactory(() => NowPlayingTvSeriesBloc(locator()));
  locator.registerFactory(() => PopularTvSeriesBloc(locator()));
  locator.registerFactory(() => TopRatedTvSeriesBloc(locator()));
  locator.registerFactory(() => DetailTvSeriesBloc(locator()));
  locator.registerFactory(() => RecommendationTvSeriesBloc(locator()));
  locator.registerFactory(() => WatchlistTvSeriesBloc(locator()));
  locator.registerFactory(() => WatchlistStatusTvSeriesBloc(
        getWatchListStatusTvSeries: locator(),
        saveWatchlistTvSeries: locator(),
        removeWatchlistTvSeries: locator(),
      ));
  locator.registerFactory(() => SearchTvSeriesBloc(locator()));

  // use case movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // use case tv series
  locator.registerLazySingleton(() => GetNowPlayingTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTvSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
  locator.registerLazySingleton(() => DataConnectionChecker());
}
