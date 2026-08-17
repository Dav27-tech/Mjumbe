import 'package:mjumbe/core/error/failures.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';

class SearchNews {
  final NewsRepository repository;

  SearchNews(this.repository);

  Future<({Failure? failure, List<ArticleEntity>? articles})> call(
      String query,
      ) {
    return repository.searchNews(query: query);
  }
}