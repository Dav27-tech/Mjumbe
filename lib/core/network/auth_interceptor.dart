import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mjumbe/features/auth/domain/repositories/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;

  AuthInterceptor(this._authRepository);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Récupération silencieuse du token d'accès OAuth2
    final String? token = await _authRepository.getOAuth2AccessToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      if (kDebugMode) {
        print('Network: OAuth2 Token injecté dans les headers.');
      }
    }
    
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) {
    // Gestion du cycle de vie du token OAuth2 : Cas 401 Unauthorized
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        print('Network: Erreur 401 détectée. Tentative de rafraîchissement OAuth2...');
      }

      _authRepository.getOAuth2AccessToken(forceRefresh: true).then((newToken) async {
        if (newToken != null) {
          if (kDebugMode) {
            print('Network: Nouveau token obtenu. Rejeu de la requête...');
          }

          final requestOptions = err.requestOptions;
          requestOptions.headers['Authorization'] = 'Bearer $newToken';

          final retryDio = Dio(BaseOptions(
            baseUrl: requestOptions.baseUrl,
            headers: requestOptions.headers,
          ));

          try {
            final response = await retryDio.request(
              requestOptions.path,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
              options: Options(
                method: requestOptions.method,
              ),
            );
            handler.resolve(response);
            return;
          } catch (e) {
            if (kDebugMode) {
              print('Network: Échec du rejeu après rafraîchissement : $e');
            }
          }
        } else {
          if (kDebugMode) {
            print('Network: Impossible de rafraîchir le token. Session expirée.');
          }
          await _authRepository.signOut();
        }

        handler.next(err);
      }).catchError((Object error) {
        if (kDebugMode) {
          print('Network: Erreur pendant le rafraîchissement OAuth2 : $error');
        }
        handler.next(err);
      });
      return;
    }

    handler.next(err);
  }
}
