import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';
import 'package:mjumbe/features/news/domain/usecases/get_top_headlines.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late GetTopHeadlines usecase;
  late MockNewsRepository mockNewsRepository;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    usecase = GetTopHeadlines(mockNewsRepository);
  });

  final tArticles = [const ArticleEntity(id: '1', title: 'Test')];

  test('should get top headlines from the repository', () async {
    // arrange
    when(() => mockNewsRepository.getTopHeadlines(
      category: any(named: 'category'),
      forceRefresh: any(named: 'forceRefresh'),
    )).thenAnswer((_) async => (failure: null, articles: tArticles));

    // act
    final result = await usecase(category: 'business');

    // assert
    expect(result.articles, tArticles);
    verify(() => mockNewsRepository.getTopHeadlines(category: 'business')).called(1);
    verifyNoMoreInteractions(mockNewsRepository);
  });
}
