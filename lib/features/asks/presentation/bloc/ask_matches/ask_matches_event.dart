import 'package:equatable/equatable.dart';

abstract class AskMatchesEvent extends Equatable {
  const AskMatchesEvent();

  @override
  List<Object?> get props => [];
}

class AskMatchesFetchRequested extends AskMatchesEvent {
  final String askId;

  const AskMatchesFetchRequested(this.askId);

  @override
  List<Object?> get props => [askId];
}
