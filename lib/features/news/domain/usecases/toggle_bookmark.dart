import 'package:mjumbe/core/error/failures.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';

class ToggleBookmark {
  final NewsRepository repository;

  ToggleBookmark(this.repository);

  Future<({Failure? failure, bool? isBookmarked})> call(
      ArticleEntity article,
      ) {
    return repository.toggleBookmark(article);
  }
}