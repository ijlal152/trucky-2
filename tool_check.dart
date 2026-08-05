import 'package:equatable/equatable.dart';

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

void main() {
  const p = NoParams();
  print('const NoParams OK');
}
