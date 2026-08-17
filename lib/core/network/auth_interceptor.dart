import 'package:dio/dio.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;

  AuthInterceptor(this._authRepository);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Récupération silencieuse du token (sans forcer le rafraîchissement)
    final String? token = await _authRepository.getIdToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    // Logique de rafraîchissement explicite en cas d'erreur 401
    if (err.response?.statusCode == 401) {
      // On tente de forcer le rafraîchissement du token JWT (OAuth 2.0 flow)
      final String? newToken = await _authRepository.getIdToken(forceRefresh: true);
      
      if (newToken != null) {
        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $newToken';

        // Rejeu de la requête initiale avec le nouveau token
        // On crée une nouvelle instance Dio pour éviter les boucles d'intercepteurs
        final dio = Dio();
        try {
          final response = await dio.fetch(requestOptions);
          return handler.resolve(response);
        } catch (_) {
          // Si le rejeu échoue, on continue avec l'erreur originale
        }
      } else {
        // Si on ne peut pas obtenir de nouveau token, on peut forcer la déconnexion
        await _authRepository.signOut();
      }
    }
    return handler.next(err);
  }
}
