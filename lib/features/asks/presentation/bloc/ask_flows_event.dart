import 'package:equatable/equatable.dart';

abstract class AskFlowsEvent extends Equatable {
  const AskFlowsEvent();

  @override
  List<Object?> get props => [];
}

class AskFlowsFetchRequested extends AskFlowsEvent {
  const AskFlowsFetchRequested();
}

class AskFlowsRefreshRequested extends AskFlowsEvent {
  const AskFlowsRefreshRequested();
}
