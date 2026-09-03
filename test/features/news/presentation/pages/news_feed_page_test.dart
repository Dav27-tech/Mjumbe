import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_event.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_state.dart';
import 'package:mjumbe/features/news/presentation/pages/news_feed_page.dart';

class MockNewsBloc extends Mock implements NewsBloc {}

void main() {
  late MockNewsBloc mockNewsBloc;

  setUpAll(() {
    registerFallbackValue(const FetchTopHeadlinesEvent());
  });

  setUp(() {
    mockNewsBloc = MockNewsBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<NewsBloc>.value(
        value: mockNewsBloc,
        child: const NewsFeedPage(),
      ),
    );
  }

  testWidgets('should show loading indicator when state is NewsLoading', (tester) async {
    // arrange
    when(() => mockNewsBloc.state).thenReturn(NewsLoading());
    when(() => mockNewsBloc.stream).thenAnswer((_) => Stream.value(NewsLoading()));

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should show articles when state is NewsLoaded', (tester) async {
    // arrange
    final tArticles = [
      const ArticleEntity(id: '1', title: 'Article 1'),
      const ArticleEntity(id: '2', title: 'Article 2'),
    ];
    when(() => mockNewsBloc.state).thenReturn(NewsLoaded(articles: tArticles));
    when(() => mockNewsBloc.stream).thenAnswer((_) => Stream.value(NewsLoaded(articles: tArticles)));

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.text('Article 1'), findsOneWidget);
    expect(find.text('Article 2'), findsOneWidget);
  });

  testWidgets('should show error message when state is NewsError', (tester) async {
    // arrange
    const tMessage = 'Error message';
    when(() => mockNewsBloc.state).thenReturn(const NewsError(tMessage));
    when(() => mockNewsBloc.stream).thenAnswer((_) => Stream.value(const NewsError(tMessage)));

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.text(tMessage), findsOneWidget);
  });

  testWidgets('should submit search query when user searches', (tester) async {
    // arrange
    final tArticles = [
      const ArticleEntity(id: '1', title: 'Search result 1'),
    ];
    when(() => mockNewsBloc.state).thenReturn(NewsLoaded(articles: tArticles));
    when(() => mockNewsBloc.stream).thenAnswer((_) => Stream.value(NewsLoaded(articles: tArticles)));
    when(() => mockNewsBloc.add(any())).thenReturn(null);

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.enterText(find.byType(TextField), 'AI');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    // assert
    verify(() => mockNewsBloc.add(any(that: isA<SearchNewsEvent>()))).called(1);
  });

  testWidgets('should show empty state when no articles are available', (tester) async {
    // arrange
    when(() => mockNewsBloc.state).thenReturn(const NewsLoaded(articles: []));
    when(() => mockNewsBloc.stream).thenAnswer((_) => Stream.value(const NewsLoaded(articles: [])));

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.text('Aucun résultat disponible'), findsOneWidget);
  });
}
