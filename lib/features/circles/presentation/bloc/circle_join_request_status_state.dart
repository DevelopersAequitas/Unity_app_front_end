import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_join_request_entity.dart';

enum CircleJoinRequestStatusStateStatus {
  initial,
  loading,
  success,
  cancelling,
  cancelled,
  error
}

class CircleJoinRequestStatusState extends Equatable {
  final CircleJoinRequestStatusStateStatus status;
  final CircleJoinRequestEntity? request;
  final String? errorMessage;

  const CircleJoinRequestStatusState({
    this.status = CircleJoinRequestStatusStateStatus.initial,
    this.request,
    this.errorMessage,
  });

  CircleJoinRequestStatusState copyWith({
    CircleJoinRequestStatusStateStatus? status,
    CircleJoinRequestEntity? request,
    String? errorMessage,
  }) {
    return CircleJoinRequestStatusState(
      status: status ?? this.status,
      request: request ?? this.request,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, request, errorMessage];
}
