import 'package:equatable/equatable.dart';

abstract class AskFormConfigEvent extends Equatable {
  const AskFormConfigEvent();

  @override
  List<Object?> get props => [];
}

class AskFormConfigFetchRequested extends AskFormConfigEvent {
  final String flowId;
  final String typeId;

  const AskFormConfigFetchRequested({
    required this.flowId,
    required this.typeId,
  });

  @override
  List<Object?> get props => [flowId, typeId];
}
