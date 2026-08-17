import 'package:mjumbe/core/error/failures.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';

abstract class NewsRepository {
  Future<({Failure? failure, List<ArticleEntity>? articles})> getTopHeadlines({
    String category = 'general',
    bool forceRefresh = false,
  });

  Future<({Failure? failure, List<ArticleEntity>? articles})> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  });

  Future<({Failure? failure, bool? isBookmarked})> toggleBookmark(
      ArticleEntity article,
      );

  Future<({Failure? failure, List<ArticleEntity>? articles})> getBookmarkedArticles();

  Future<bool> isBookmarked(String articleId);
}