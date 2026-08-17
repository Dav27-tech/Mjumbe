import 'package:hive/hive.dart';
import 'package:mjumbe/core/error/exceptions.dart';
import 'package:mjumbe/features/news/data/datasources/news_local_data_source.dart';
import 'package:mjumbe/features/news/data/models/article_model.dart';

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Box<ArticleModel> cachedArticlesBox;
  final Box<ArticleModel> bookmarkedArticlesBox;

  NewsLocalDataSourceImpl({
    required this.cachedArticlesBox,
    required this.bookmarkedArticlesBox,
  });

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    try {
      // Réinitialise le cache réseau local et écrit les derniers articles
      await cachedArticlesBox.clear();
      final Map<String, ArticleModel> articlesMap = {
        for (var article in articles) article.id: article
      };
      await cachedArticlesBox.putAll(articlesMap);
    } catch (e) {
      throw CacheException(
        message: 'Erreur lors de la mise en cache des articles: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    try {
      return cachedArticlesBox.values.toList();
    } catch (e) {
      throw CacheException(
        message: 'Erreur lors de la lecture du cache local: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> bookmarkArticle(ArticleModel article) async {
    try {
      await bookmarkedArticlesBox.put(article.id, article);
    } catch (e) {
      throw CacheException(
        message: 'Erreur lors de la sauvegarde du signet: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> removeBookmark(String articleId) async {
    try {
      await bookmarkedArticlesBox.delete(articleId);
    } catch (e) {
      throw CacheException(
        message: 'Erreur lors de la suppression du signet: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<ArticleModel>> getBookmarkedArticles() async {
    try {
      return bookmarkedArticlesBox.values.toList();
    } catch (e) {
      throw CacheException(
        message: 'Erreur lors de la récupération des signets: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isBookmarked(String articleId) async {
    try {
      return bookmarkedArticlesBox.containsKey(articleId);
    } catch (e) {
      return false;
    }
  }
}