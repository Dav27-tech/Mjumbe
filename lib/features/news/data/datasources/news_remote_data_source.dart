import 'package:mjumbe/features/news/data/models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    String category = 'general',
    String country = 'us',
    int page = 1,
    int pageSize = 20,
  });

  Future<List<ArticleModel>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  });
}
