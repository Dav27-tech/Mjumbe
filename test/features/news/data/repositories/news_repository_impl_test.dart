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

  group('getTopHeadlines', () {
    const tCategory = 'general';
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

    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTopHeadlines(category: any(named: 'category')))
          .thenAnswer((_) async => tArticles);
      when(() => mockLocalDataSource.cacheArticles(any())).thenAnswer((_) async => {});

      // act
      await repository.getTopHeadlines(category: tCategory);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    test('should return remote data when the call to remote data source is successful', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTopHeadlines(category: tCategory))
          .thenAnswer((_) async => tArticles);
      when(() => mockLocalDataSource.cacheArticles(any())).thenAnswer((_) async => {});

      // act
      final result = await repository.getTopHeadlines(category: tCategory);

      // assert
      verify(() => mockRemoteDataSource.getTopHeadlines(category: tCategory));
      expect(result.articles, equals(tArticles));
      expect(result.failure, isNull);
    });

    test('should cache data locally when the call to remote data source is successful', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getTopHeadlines(category: tCategory))
          .thenAnswer((_) async => tArticles);
      when(() => mockLocalDataSource.cacheArticles(any())).thenAnswer((_) async => {});

      // act
      await repository.getTopHeadlines(category: tCategory);

      // assert
      verify(() => mockRemoteDataSource.getTopHeadlines(category: tCategory));
      verify(() => mockLocalDataSource.cacheArticles(tArticles));
    });

    test('should return cached data when the device is offline', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDataSource.getCachedArticles()).thenAnswer((_) async => tArticles);

      // act
      final result = await repository.getTopHeadlines(category: tCategory);

      // assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(() => mockLocalDataSource.getCachedArticles());
      expect(result.articles, equals(tArticles));
      expect(result.failure, isNotNull); // Should contain the offline/network message
    });
  });
}
