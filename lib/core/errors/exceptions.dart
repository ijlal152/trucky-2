/// Exceptions thrown by the data layer (data sources).
///
/// These are low-level, implementation-specific errors. They should NEVER
/// leak into the presentation layer — repositories convert them into
/// [AppFailure] values instead.
class ServerException implements Exception {
  const ServerException(this.message);

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  const CacheException(this.message);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
