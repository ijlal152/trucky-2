import 'package:trucky/core/errors/failures.dart';

/// A lightweight `Either`-style wrapper used to model success/failure
/// without relying on exceptions for control flow.
///
/// Example:
/// ```dart
/// Result<int> parse(String input) {
///   final value = int.tryParse(input);
///   return value == null
///       ? const Result.failure(ValidationFailure())
///       : Result.success(value);
/// }
/// ```
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;

  const factory Result.failure(AppFailure failure) = Failure<T>;

  /// Maps the result to a single value, handling both cases exhaustively.
  TResult when<TResult>({
    required TResult Function(T data) success,
    required TResult Function(AppFailure failure) failure,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Failure(failure: final error) => failure(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  final AppFailure failure;
}
