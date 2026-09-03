import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mjumbe/app/router/app_router.dart';
import 'package:mjumbe/core/error/failures.dart';
import 'package:mjumbe/features/auth/domain/entities/user_entity.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_event.dart';
import 'package:mjumbe/features/auth/presentation/bloc/auth_state.dart';
import 'package:mjumbe/features/auth/presentation/pages/login_page.dart';
import 'package:mjumbe/features/news/data/datasources/news_local_data_source.dart';
import 'package:mjumbe/features/news/data/models/article_model.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';
import 'package:mjumbe/features/news/domain/usecases/get_top_headlines.dart';
import 'package:mjumbe/features/news/domain/usecases/search_news.dart';
import 'package:mjumbe/features/news/domain/usecases/toggle_bookmark.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_bloc.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_event.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_state.dart';
import 'package:mjumbe/features/news/presentation/pages/article_detail_page.dart';
import 'package:mjumbe/features/news/presentation/pages/bookmarks_page.dart';
import 'package:mjumbe/features/news/presentation/pages/news_feed_page.dart';

class FakeAuthRepository implements AuthRepository {
  final StreamController<UserEntity?> _controller = StreamController.broadcast();
  UserEntity? _currentUser;

  FakeAuthRepository({UserEntity? currentUser}) : _currentUser = currentUser;

  void emitUser(UserEntity? user) {
    _currentUser = user;
    _controller.add(user);
  }

  @override
  Stream<UserEntity?> get userStream => _controller.stream;

  @override
  UserEntity? get currentUser => _currentUser;

  @override
  Future<({Failure? failure, UserEntity? user})> signUp({
    required String email,
    required String password,
  }) async {
    final user = UserEntity(uid: 'uid-1', email: email);
    emitUser(user);
    return (failure: null, user: user);
  }

  @override
  Future<({Failure? failure, UserEntity? user})> signIn({
    required String email,
    required String password,
  }) async {
    final user = UserEntity(uid: 'uid-1', email: email);
    emitUser(user);
    return (failure: null, user: user);
  }

  @override
  Future<({Failure? failure, void data})> signOut() async {
    emitUser(null);
    return (failure: null, data: null);
  }

  @override
  Future<String?> getOAuth2AccessToken({bool forceRefresh = false}) async => 'token';
}

class FakeNewsLocalDataSource implements NewsLocalDataSource {
  final List<ArticleModel> _bookmarks;

  FakeNewsLocalDataSource({List<ArticleModel> bookmarks = const []})
      : _bookmarks = List<ArticleModel>.from(bookmarks);

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {}

  @override
  Future<List<ArticleModel>> getCachedArticles() async => const [];

  @override
  Future<void> bookmarkArticle(ArticleModel article) async {
    if (!_bookmarks.any((item) => item.id == article.id)) {
      _bookmarks.add(article);
    }
  }

  @override
  Future<void> removeBookmark(String articleId) async {
    _bookmarks.removeWhere((item) => item.id == articleId);
  }

  @override
  Future<List<ArticleModel>> getBookmarkedArticles() async => List<ArticleModel>.from(_bookmarks);

  @override
  Future<bool> isBookmarked(String articleId) async => _bookmarks.any((item) => item.id == articleId);
}

class FakeNewsRepository implements NewsRepository {
  final FakeNewsLocalDataSource localDataSource;
  final List<ArticleEntity> articles;

  FakeNewsRepository({
    required this.localDataSource,
    required this.articles,
  });

  @override
  Future<({Failure? failure, List<ArticleEntity>? articles})> getTopHeadlines({
    String category = 'general',
    bool forceRefresh = false,
  }) async {
    return (failure: null, articles: articles);
  }

  @override
  Future<({Failure? failure, List<ArticleEntity>? articles})> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    return (failure: null, articles: articles.where((article) => article.title.toLowerCase().contains(query.toLowerCase())).toList());
  }

  @override
  Future<({Failure? failure, bool? isBookmarked})> toggleBookmark(ArticleEntity article) async {
    final model = ArticleModel.fromEntity(article);
    final exists = await localDataSource.isBookmarked(article.id);
    if (exists) {
      await localDataSource.removeBookmark(article.id);
      return (failure: null, isBookmarked: false);
    }
    await localDataSource.bookmarkArticle(model);
    return (failure: null, isBookmarked: true);
  }

  @override
  Future<({Failure? failure, List<ArticleEntity>? articles})> getBookmarkedArticles() async {
    final bookmarked = await localDataSource.getBookmarkedArticles();
    return (
      failure: null,
      articles: bookmarked
          .map(
            (item) => ArticleEntity(
              id: item.id,
              title: item.title,
              description: item.description,
              url: item.url,
              urlToImage: item.urlToImage,
              publishedAt: item.publishedAt,
              content: item.content,
              sourceName: item.sourceName,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<bool> isBookmarked(String articleId) async => await localDataSource.isBookmarked(articleId);
}

void main() {
  setUp(() {
    GetIt.instance.reset();
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('Launch -> Login -> Authentication -> Home', (tester) async {
    final authRepository = FakeAuthRepository();
    final authBloc = AuthBloc(authRepository: authRepository);
    authBloc.add(AuthStatusChangedEvent(null));

    final router = AppRouter(authBloc).router;

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'demo@luma.news');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('SE CONNECTER'));
    await tester.pump();

    authRepository.signIn(email: 'demo@luma.news', password: 'password123');
    await tester.pumpAndSettle();

    expect(find.text('LUMA NEWS'), findsOneWidget);
  });

  testWidgets('Launch -> Home -> Open article -> Add favorite -> Favorites -> Article visible', (tester) async {
    final article = const ArticleEntity(
      id: 'article-1',
      title: 'Article favori',
      description: 'Description du test',
      sourceName: 'Luma',
      urlToImage: 'https://example.com/image.jpg',
      url: 'https://example.com/article',
    );

    final localDataSource = FakeNewsLocalDataSource();
    final newsRepository = FakeNewsRepository(
      localDataSource: localDataSource,
      articles: [article],
    );

    final newsBloc = NewsBloc(
      getTopHeadlines: GetTopHeadlines(newsRepository),
      searchNews: SearchNews(newsRepository),
      toggleBookmark: ToggleBookmark(newsRepository),
    );

    GetIt.instance.registerSingleton<NewsLocalDataSource>(localDataSource);
    GetIt.instance.registerSingleton<ToggleBookmark>(ToggleBookmark(newsRepository));

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider<NewsBloc>.value(
            value: newsBloc,
            child: const NewsFeedPage(),
          ),
        ),
        GoRoute(
          path: '/article-detail',
          builder: (context, state) => BlocProvider<NewsBloc>.value(
            value: newsBloc,
            child: ArticleDetailPage(article: state.extra as ArticleEntity),
          ),
        ),
        GoRoute(
          path: '/bookmarks',
          builder: (context, state) => const BookmarksPage(),
        ),
      ],
    );

    newsBloc.add(FetchTopHeadlinesEvent());
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Article favori'), findsOneWidget);

    await tester.tap(find.text('Article favori'));
    await tester.pumpAndSettle();
    expect(find.byType(ArticleDetailPage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bookmark_border_rounded));
    await tester.pump();

    router.go('/bookmarks');
    await tester.pumpAndSettle();

    expect(find.text('Article favori'), findsOneWidget);
  });
}
