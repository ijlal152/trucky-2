import 'package:trucky/core/utils/result.dart';

/// Return type used by every repository and use case method.
typedef ResultFuture<T> = Future<Result<T>>;
