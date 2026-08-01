/// Abstraction over the HTTP client.
///
/// Data sources depend on this interface (not on `dio`/`http` directly),
/// which keeps them decoupled and trivially faked in tests.
abstract interface class ApiClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? query});

  Future<dynamic> post(String path, {Object? body});

  Future<dynamic> put(String path, {Object? body});

  Future<dynamic> delete(String path);
}
