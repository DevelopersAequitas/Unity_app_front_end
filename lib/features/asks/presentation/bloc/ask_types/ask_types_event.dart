import 'package:equatable/equatable.dart';

abstract class AskTypesEvent extends Equatable {
  const AskTypesEvent();

  @override
  List<Object?> get props => [];
}

class AskTypesFetchRequested extends AskTypesEvent {
  final String flowIdOrCode;

  const AskTypesFetchRequested(this.flowIdOrCode);

  @override
  List<Object?> get props => [flowIdOrCode];
}

class AskTypesRefreshRequested extends AskTypesEvent {
  final String flowIdOrCode;

  const AskTypesRefreshRequested(this.flowIdOrCode);

  @override
  List<Object?> get props => [flowIdOrCode];
}
