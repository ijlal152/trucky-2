/// Global application-wide constants.
abstract final class AppConstants {
  static const String appName = 'Trucky';

  /// Base URL for the REST API.
  static const String baseUrl = 'https://api.trucky.example.com/v1';

  /// Default request timeout used by the HTTP client.
  static const Duration apiTimeout = Duration(seconds: 15);

  /// Number of retries for failed network requests.
  static const int apiRetries = 2;
}
