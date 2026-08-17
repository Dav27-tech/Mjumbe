import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';
import 'package:mjumbe/features/news/domain/usecases/toggle_bookmark.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late ToggleBookmark usecase;
  late MockNewsRepository mockNewsRepository;

  setUpAll(() {
    registerFallbackValue(const ArticleEntity(id: '0', title: 'fallback'));
  });

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    usecase = ToggleBookmark(mockNewsRepository);
  });

  const tArticle = ArticleEntity(id: '1', title: 'Test');

  test('should toggle bookmark in the repository', () async {
    // arrange
    when(() => mockNewsRepository.toggleBookmark(any()))
        .thenAnswer((_) async => (failure: null, isBookmarked: true));

    // act
    final result = await usecase(tArticle);

    // assert
    expect(result.isBookmarked, true);
    verify(() => mockNewsRepository.toggleBookmark(tArticle)).called(1);
    verifyNoMoreInteractions(mockNewsRepository);
  });
}
