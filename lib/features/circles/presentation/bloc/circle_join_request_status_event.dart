import 'package:equatable/equatable.dart';

abstract class CircleJoinRequestStatusEvent extends Equatable {
  const CircleJoinRequestStatusEvent();

  @override
  List<Object?> get props => [];
}

class CircleJoinRequestStatusFetchRequested extends CircleJoinRequestStatusEvent {
  final String requestId;
  final String circleName;
  final bool silent;

  const CircleJoinRequestStatusFetchRequested({
    required this.requestId,
    required this.circleName,
    this.silent = false,
  });

  @override
  List<Object?> get props => [requestId, circleName, silent];
}

class CircleJoinRequestCancelRequested extends CircleJoinRequestStatusEvent {
  final String requestId;

  const CircleJoinRequestCancelRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}
