import 'package:trucky/core/errors/exceptions.dart';
import 'package:trucky/core/network/api_client.dart';

/// In-memory fake used as the default [ApiClient] so the sample app runs
/// without a real backend.
///
/// Replace this with a real implementation (e.g. `dio`/`http`) when the
/// backend is available — nothing else in the codebase needs to change.
class MockApiClient implements ApiClient {
  const MockApiClient();

  static const List<Map<String, dynamic>> _mockTrips = [
    {'id': '1', 'origin': 'New York', 'destination': 'Boston', 'distance': 306},
    {
      'id': '2',
      'origin': 'Los Angeles',
      'destination': 'San Francisco',
      'distance': 559,
    },
    {'id': '3', 'origin': 'Chicago', 'destination': 'Detroit', 'distance': 282},
  ];

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    if (path == '/trips') {
      return _mockTrips;
    }

    final tripMatch = RegExp(r'^/trips/(.+)$').firstMatch(path);
    if (tripMatch != null) {
      final id = tripMatch.group(1);
      return _mockTrips.firstWhere(
        (trip) => trip['id'] == id,
        orElse: () => throw const ServerException('Trip not found'),
      );
    }

    throw ServerException('Endpoint not found: $path');
  }

  @override
  Future<dynamic> post(String path, {Object? body}) async {
    if (path == '/auth/login') {
      return {
        'id': '1',
        'name': 'Demo User',
        'email': (body as Map<String, dynamic>)['email'] ?? 'demo@trucky.app',
      };
    }

    throw ServerException('Endpoint not found: $path');
  }

  @override
  Future<dynamic> put(String path, {Object? body}) {
    throw ServerException('Not implemented: $path');
  }

  @override
  Future<dynamic> delete(String path) {
    throw ServerException('Not implemented: $path');
  }
}
