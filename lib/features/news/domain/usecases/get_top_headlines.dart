import 'package:mjumbe/core/error/failures.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';

class GetTopHeadlines {
  final NewsRepository repository;

  GetTopHeadlines(this.repository);

  Future<({Failure? failure, List<ArticleEntity>? articles})> call({
    String category = 'general',
    bool forceRefresh = false,
  }) {
    return repository.getTopHeadlines(
      category: category,
      forceRefresh: forceRefresh,
    );
  }
}