import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthInterceptor extends Interceptor {
  final FirebaseAuth _firebaseAuth;

  AuthInterceptor(this._firebaseAuth);

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        final String? token = await user.getIdToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (_) {
        // En cas d'erreur lors de la récupération du token, la requête continue sans header Auth.
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
      ) async {
    if (err.response?.statusCode == 401) {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        try {
          // Obtention d'un nouveau token rafraîchi auprès de Firebase Auth
          final String? newToken = await user.getIdToken(true);
          if (newToken != null) {
            final requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newToken';

            // Rejeu de la requête initiale avec le nouveau token
            final dio = Dio();
            final response = await dio.fetch(requestOptions);
            return handler.resolve(response);
          }
        } catch (_) {
          await _firebaseAuth.signOut();
        }
      }
    }
    return handler.next(err);
  }
}