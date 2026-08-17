import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mjumbe/core/network/api_client.dart';
import 'package:mjumbe/core/storage/hive_service.dart';
import 'package:mjumbe/core/utils/constants.dart';
import 'package:mjumbe/core/utils/network_info.dart';
import 'package:mjumbe/features/news/data/datasources/news_local_data_source.dart';
import 'package:mjumbe/features/news/data/datasources/news_local_data_source_impl.dart';
import 'package:mjumbe/features/news/data/datasources/news_remote_data_source.dart';
import 'package:mjumbe/features/news/data/datasources/news_remote_data_source_impl.dart';
import 'package:mjumbe/features/news/data/repositories/news_repository_impl.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';
import 'package:mjumbe/features/news/domain/usecases/get_top_headlines.dart';
import 'package:mjumbe/features/news/domain/usecases/search_news.dart';
import 'package:mjumbe/features/news/domain/usecases/toggle_bookmark.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';

import 'package:mjumbe/features/auth/domain/repositories/auth_repository.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mjumbe/app/router/app_router.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ---------------------------------------------------------------------------
  // 1. External & Core
  // ---------------------------------------------------------------------------
  await HiveService.init();

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<InternetConnectionChecker>(
        () => InternetConnectionChecker(),
  );

  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(sl<InternetConnectionChecker>()),
  );

  // Remplacez 'https://newsapi.org' par l'URL de votre API si vous utilisez un proxy/backend custom
  sl.registerLazySingleton<ApiClient>(
        () => ApiClient(
      baseUrl: 'https://newsapi.org',
      firebaseAuth: sl<FirebaseAuth>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // 2. Data Sources (News Feature)
  // ---------------------------------------------------------------------------
  // N'oubliez pas de renseigner votre clé API NewsAPI dans apiKey
  sl.registerLazySingleton<NewsRemoteDataSource>(
        () => NewsRemoteDataSourceImpl(
      dio: sl<ApiClient>().client,
      apiKey: AppConstants.newsApiKey,
    ),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
        () => NewsLocalDataSourceImpl(
      cachedArticlesBox: HiveService.cachedArticlesBox,
      bookmarkedArticlesBox: HiveService.bookmarkedArticlesBox,
    ),
  );

  // ---------------------------------------------------------------------------
  // 3. Repositories (News Feature)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<NewsRepository>(
        () => NewsRepositoryImpl(
      remoteDataSource: sl<NewsRemoteDataSource>(),
      localDataSource: sl<NewsLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // 4. Use Cases (News Feature)
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<GetTopHeadlines>(
        () => GetTopHeadlines(sl<NewsRepository>()),
  );
  sl.registerLazySingleton<SearchNews>(
        () => SearchNews(sl<NewsRepository>()),
  );
  sl.registerLazySingleton<ToggleBookmark>(
        () => ToggleBookmark(sl<NewsRepository>()),
  );

  // ---------------------------------------------------------------------------
  // 5. Blocs / State Management
  // ---------------------------------------------------------------------------
  sl.registerFactory<NewsBloc>(
     () => NewsBloc(
       getTopHeadlines: sl<GetTopHeadlines>(),
       searchNews: sl<SearchNews>(),
       toggleBookmark: sl<ToggleBookmark>(),
     ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(firebaseAuth: sl<FirebaseAuth>()),
  );

// Blocs
  sl.registerFactory<AuthBloc>(
        () => AuthBloc(authRepository: sl<AuthRepository>()),
  );

  // Router
  sl.registerLazySingleton<AppRouter>(
        () => AppRouter(sl<AuthBloc>()),
  );
}