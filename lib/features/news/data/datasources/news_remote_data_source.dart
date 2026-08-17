import 'package:mjumbe/features/news/data/models/article_model.dart';

abstract class NewsRemoteDataSource {
  /// Récupère les actualités à la une (Top Headlines).
  /// Lever une [ServerException] en cas d'erreur API ou de code HTTP != 200.
  Future<List<ArticleModel>> getTopHeadlines({
    String category = 'general',
    String country = 'us',
    int page = 1,
    int pageSize = 20,
  });

  /// Recherche des articles par mot-clé (Everything).
  Future<List<ArticleModel>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  });
}