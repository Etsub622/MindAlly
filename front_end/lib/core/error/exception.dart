class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});
}

class CloudinaryException implements Exception {
  final String message;
  CloudinaryException({required this.message});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}
