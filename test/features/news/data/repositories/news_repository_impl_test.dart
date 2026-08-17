import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mjumbe/core/utils/network_info.dart';
import 'package:mjumbe/features/news/data/datasources/news_local_data_source.dart';
import 'package:mjumbe/features/news/data/datasources/news_remote_data_source.dart';
import 'package:mjumbe/features/news/data/models/article_model.dart';
import 'package:mjumbe/features/news/data/repositories/news_repository_impl.dart';

class MockRemoteDataSource extends Mock implements NewsRemoteDataSource {}
class MockLocalDataSource extends Mock implements NewsLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NewsRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(const ArticleModel(id: '0', title: 'fallback'));
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NewsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tArticleModel = ArticleModel(
    id: '1',
    title: 'Test Title',
    description: 'Test Description',
    url: 'url',
    urlToImage: 'image',
    publishedAt: 'date',
    sourceName: 'source',
  );
  final tArticles = [tArticleModel];

  group('getTopHeadlines', () {
    const tCategory = 'general';

    test('should return remote data when online', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTopHeadlines(category: any(named: 'category')))
          .thenAnswer((_) async => tArticles);
      when(() => mockLocalDataSource.cacheArticles(any())).thenAnswer((_) async => {});

      final result = await repository.getTopHeadlines(category: tCategory);

      expect(result.articles, tArticles);
    });

    test('should return cached data when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedArticles()).thenAnswer((_) async => tArticles);

      final result = await repository.getTopHeadlines(category: tCategory);

      expect(result.articles, tArticles);
      expect(result.failure, isNotNull);
    });
  });

  group('searchNews', () {
    const tQuery = 'flutter';

    test('should return remote data when successful', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.searchNews(query: tQuery))
          .thenAnswer((_) async => tArticles);

      final result = await repository.searchNews(query: tQuery);

      expect(result.articles, tArticles);
      verify(() => mockRemoteDataSource.searchNews(query: tQuery));
    });
  });

  group('toggleBookmark', () {
    test('should call local data source to bookmark', () async {
      when(() => mockLocalDataSource.isBookmarked(any())).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.bookmarkArticle(any())).thenAnswer((_) async => {});

      final result = await repository.toggleBookmark(tArticleModel);

      expect(result.isBookmarked, true);
      verify(() => mockLocalDataSource.bookmarkArticle(any()));
    });

    test('should call local data source to remove bookmark', () async {
      when(() => mockLocalDataSource.isBookmarked(any())).thenAnswer((_) async => true);
      when(() => mockLocalDataSource.removeBookmark(any())).thenAnswer((_) async => {});

      final result = await repository.toggleBookmark(tArticleModel);

      expect(result.isBookmarked, false);
      verify(() => mockLocalDataSource.removeBookmark(tArticleModel.id));
    });
  });
}
