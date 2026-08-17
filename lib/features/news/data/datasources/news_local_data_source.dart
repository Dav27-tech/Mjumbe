import 'package:mjumbe/features/news/data/models/article_model.dart';

abstract class NewsLocalDataSource {
  /// Sauvegarde la liste d'articles récupérés depuis l'API dans le cache réseau
  Future<void> cacheArticles(List<ArticleModel> articles);

  /// Récupère la liste des derniers articles mis en cache
  Future<List<ArticleModel>> getCachedArticles();

  /// Enregistre un article dans les signets / favoris de l'utilisateur
  Future<void> bookmarkArticle(ArticleModel article);

  /// Supprime un article des signets
  Future<void> removeBookmark(String articleId);

  /// Récupère tous les articles sauvegardés en signets
  Future<List<ArticleModel>> getBookmarkedArticles();

  /// Vérifie si un article est déjà présent dans les signets
  Future<bool> isBookmarked(String articleId);
}