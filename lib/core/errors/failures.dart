/// Failures are domain-level error representations.
///
/// Unlike exceptions (which are thrown), failures are returned as values
/// through the [Result] type, so the UI can handle errors explicitly.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

class ServerFailure extends AppFailure {
  const ServerFailure([
    super.message = 'Server error occurred. Please try again.',
  ]);
}

class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Unable to access local data.']);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure([super.message = 'Validation failed.']);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Something went wrong.']);
}
