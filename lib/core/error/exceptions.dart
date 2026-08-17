class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });
}

class CacheException implements Exception {
  final String message;

  const CacheException({
    required this.message,
  });
}

class AuthException implements Exception {
  final String message;

  const AuthException({
    required this.message,
  });
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'Pas de connexion Internet disponible.',
  });
}