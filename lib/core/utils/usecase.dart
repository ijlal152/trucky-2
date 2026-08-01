import 'package:trucky/core/utils/typedefs.dart';

/// Base contract for every domain use case.
///
/// [Output] is the returned data type and [Params] the input parameter
/// (use [NoParams] when the use case needs no input).
abstract class UseCase<Output, Params> {
  const UseCase();

  ResultFuture<Output> call(Params params);
}

/// Marker for use cases that require no parameters.
class NoParams {
  const NoParams();
}
