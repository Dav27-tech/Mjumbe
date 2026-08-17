import 'package:mjumbe/core/error/exceptions.dart';
import 'package:mjumbe/core/error/failures.dart';
import 'package:mjumbe/core/utils/network_info.dart';
import 'package:mjumbe/features/news/data/datasources/news_local_data_source.dart';
import 'package:mjumbe/features/news/data/datasources/news_remote_data_source.dart';
import 'package:mjumbe/features/news/data/models/article_model.dart';
import 'package:mjumbe/features/news/domain/entities/article_entity.dart';
import 'package:mjumbe/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<({Failure? failure, List<ArticleEntity>? articles})> getTopHeadlines({
    String category = 'general',
    bool forceRefresh = false,
  }) async {
    final bool isOnline = await networkInfo.isConnected;

    if (isOnline) {
      // Si on force le rafraîchissement ou s'il n'y a pas encore de logique de cache complexe
      try {
        final remoteModels = await remoteDataSource.getTopHeadlines(category: category);
        
        // On ne cache que si c'est la catégorie générale ou si on veut mettre en cache toutes les catégories
        if (category == 'general') {
          await localDataSource.cacheArticles(remoteModels);
        }

        return (failure: null, articles: remoteModels);
      } on ServerException catch (e) {
        if (forceRefresh) {
           return (failure: ServerFailure(e.message, statusCode: e.statusCode), articles: null);
        }
        return _fetchFromCacheOrFailure(
          ServerFailure(e.message, statusCode: e.statusCode),
        );
      } catch (e) {
        if (forceRefresh) {
          return (failure: ServerFailure(e.toString()), articles: null);
        }
        return _fetchFromCacheOrFailure(ServerFailure(e.toString()));
      }
    } else {
      if (forceRefresh) {
        return (failure: const NetworkFailure('Pas de connexion pour forcer le rafraîchissement.'), articles: null);
      }
      return _fetchFromCacheOrFailure(
        const NetworkFailure('Pas de connexion. Affichage du mode hors-ligne.'),
      );
    }
  }

  @override
  Future<({Failure? failure, List<ArticleEntity>? articles})> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteModels = await remoteDataSource.searchNews(
          query: query,
          page: page,
          pageSize: pageSize,
        );
        return (failure: null, articles: remoteModels);
      } on ServerException catch (e) {
        return (
        failure: ServerFailure(e.message, statusCode: e.statusCode),
        articles: null,
        );
      } catch (e) {
        return (failure: ServerFailure(e.toString()), articles: null);
      }
    } else {
      return (
      failure: const NetworkFailure('La recherche exige une connexion Internet.'),
      articles: null,
      );
    }
  }

  @override
  Future<({Failure? failure, bool? isBookmarked})> toggleBookmark(
      ArticleEntity article,
      ) async {
    try {
      final bool currentlyBookmarked = await localDataSource.isBookmarked(article.id);
      final model = ArticleModel.fromEntity(article);

      if (currentlyBookmarked) {
        await localDataSource.removeBookmark(article.id);
        return (failure: null, isBookmarked: false);
      } else {
        await localDataSource.bookmarkArticle(model);
        return (failure: null, isBookmarked: true);
      }
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), isBookmarked: null);
    }
  }

  @override
  Future<({Failure? failure, List<ArticleEntity>? articles})> getBookmarkedArticles() async {
    try {
      final bookmarkedModels = await localDataSource.getBookmarkedArticles();
      return (failure: null, articles: bookmarkedModels);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), articles: null);
    }
  }

  @override
  Future<bool> isBookmarked(String articleId) async {
    return await localDataSource.isBookmarked(articleId);
  }

  Future<({Failure? failure, List<ArticleEntity>? articles})> _fetchFromCacheOrFailure(
      Failure originalFailure,
      ) async {
    try {
      final cachedModels = await localDataSource.getCachedArticles();
      if (cachedModels.isNotEmpty) {
        // On retourne les articles ET l'erreur originale pour informer l'utilisateur
        return (failure: originalFailure, articles: cachedModels);
      } else {
        return (failure: originalFailure, articles: null);
      }
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), articles: null);
    }
  }
}