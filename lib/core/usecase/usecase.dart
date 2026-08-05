import 'package:equatable/equatable.dart';

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}

abstract class UseCase<Input, Output> {
  const UseCase();

  Future<Output> call(Input params);
}

abstract class InstantUseCase<Input, Output> {
  Output call(Input params);
}

abstract class StreamUseCase<Input, Output> {
  Stream<Output> call(Input params);
}
