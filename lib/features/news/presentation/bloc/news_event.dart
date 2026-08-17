import 'package:equatable/equatable.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopHeadlinesEvent extends NewsEvent {
  final String category;
  final bool forceRefresh;

  const FetchTopHeadlinesEvent({
    this.category = 'general',
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [category, forceRefresh];
}

class SearchNewsEvent extends NewsEvent {
  final String query;

  const SearchNewsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleBookmarkEvent extends NewsEvent {
  final ArticleEntity article;

  const ToggleBookmarkEvent(this.article);

  @override
  List<Object?> get props => [article];
}