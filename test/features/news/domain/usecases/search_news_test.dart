import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';
import 'package:mjumbe/features/news/domain/usecases/search_news.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late SearchNews usecase;
  late MockNewsRepository mockNewsRepository;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    usecase = SearchNews(mockNewsRepository);
  });

  const tQuery = 'flutter';
  final tArticles = [const ArticleEntity(id: '1', title: 'Test')];

  test('should get searched news from the repository', () async {
    // arrange
    when(() => mockNewsRepository.searchNews(query: any(named: 'query')))
        .thenAnswer((_) async => (failure: null, articles: tArticles));

    // act
    final result = await usecase(tQuery);

    // assert
    expect(result.articles, tArticles);
    verify(() => mockNewsRepository.searchNews(query: tQuery)).called(1);
    verifyNoMoreInteractions(mockNewsRepository);
  });
}
