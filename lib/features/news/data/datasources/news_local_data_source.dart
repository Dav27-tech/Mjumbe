import 'package:dio/dio.dart';
import 'package:mjumbe/core/error/exceptions.dart';
import 'package:mjumbe/features/news/data/datasources/news_remote_data_source.dart';
import 'package:mjumbe/features/news/data/models/article_model.dart';

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;
  final String apiKey;

  NewsRemoteDataSourceImpl({
    required this.dio,
    required this.apiKey,
  });

  @override
  Future<List<ArticleModel>> getTopHeadlines({
    String category = 'general',
    String country = 'us',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dio.get(
        '/v2/top-headlines',
        queryParameters: {
          'apiKey': apiKey,
          'category': category,
          'country': country,
          'page': page,
          'pageSize': pageSize,
        },
      );

      return _processNewsResponse(response);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erreur lors de la récupération des actualités.',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ArticleModel>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dio.get(
        '/v2/everything',
        queryParameters: {
          'apiKey': apiKey,
          'q': query,
          'page': page,
          'pageSize': pageSize,
          'sortBy': 'publishedAt',
        },
      );

      return _processNewsResponse(response);
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? 'Erreur lors de la recherche des actualités.',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Traitement centralisé de la réponse JSON de NewsAPI
  List<ArticleModel> _processNewsResponse(Response response) {
    if (response.statusCode == 200 && response.data != null) {
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;

      if (data['status'] == 'ok' && data['articles'] != null) {
        final List<dynamic> articlesJson = data['articles'] as List<dynamic>;

        // Filtrage des articles supprimés ou incomplets (sans titre ou marqués [Removed])
        return articlesJson
            .where((json) =>
        json['title'] != null &&
            json['title'] != '[Removed]' &&
            json['url'] != null)
            .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: data['message'] ?? 'Réponse invalide de NewsAPI.',
        );
      }
    } else {
      throw ServerException(
        message: 'Erreur serveur avec le code statut: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}