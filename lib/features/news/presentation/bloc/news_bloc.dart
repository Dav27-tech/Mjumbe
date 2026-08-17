import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mjumbe/features/news/domain/usecases/get_top_headlines.dart';
import 'package:mjumbe/features/news/domain/usecases/search_news.dart';
import 'package:mjumbe/features/news/domain/usecases/toggle_bookmark.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_event.dart';
import 'package:mjumbe/features/news/presentation/bloc/news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;
  final SearchNews searchNews;
  final ToggleBookmark toggleBookmark;

  NewsBloc({
    required this.getTopHeadlines,
    required this.searchNews,
    required this.toggleBookmark,
  }) : super(NewsInitial()) {
    on<FetchTopHeadlinesEvent>(_onFetchTopHeadlines);
    on<SearchNewsEvent>(_onSearchNews);
    on<ToggleBookmarkEvent>(_onToggleBookmark);
  }

  Future<void> _onFetchTopHeadlines(
      FetchTopHeadlinesEvent event,
      Emitter<NewsState> emit,
      ) async {
    emit(NewsLoading());

    final result = await getTopHeadlines(
      category: event.category,
      forceRefresh: event.forceRefresh,
    );

    if (result.articles != null) {
      emit(NewsLoaded(
        articles: result.articles!,
        activeCategory: event.category,
        infoMessage: result.failure?.message,
      ));
    } else {
      emit(NewsError(
        result.failure?.message ?? 'Erreur lors du chargement des actualités.',
      ));
    }
  }

  Future<void> _onSearchNews(
      SearchNewsEvent event,
      Emitter<NewsState> emit,
      ) async {
    if (event.query.trim().isEmpty) {
      add(const FetchTopHeadlinesEvent());
      return;
    }

    emit(NewsLoading());

    final result = await searchNews(event.query);

    if (result.articles != null) {
      emit(NewsLoaded(
        articles: result.articles!,
        activeCategory: 'search',
      ));
    } else {
      emit(NewsError(
        result.failure?.message ?? 'Aucun résultat pour cette recherche.',
      ));
    }
  }

  Future<void> _onToggleBookmark(
      ToggleBookmarkEvent event,
      Emitter<NewsState> emit,
      ) async {
    await toggleBookmark(event.article);
  }
}