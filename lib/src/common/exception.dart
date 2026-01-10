class ServerException implements Exception {

  ServerException(this.message);
  final String message;
}

class DatabaseException implements Exception {

  DatabaseException(this.message);
  final String message;
}

class CacheException implements Exception {

  CacheException(this.message);
  final String message;
}

class NetworkException implements Exception {

  NetworkException(this.message);
  final String message;
}

class TimeoutException implements Exception {

  TimeoutException(this.message);
  final String message;
}

class UnauthorizedException implements Exception {

  UnauthorizedException(this.message);
  final String message;
}

class ValidationException implements Exception {

  ValidationException(this.message);
  final String message;
}
