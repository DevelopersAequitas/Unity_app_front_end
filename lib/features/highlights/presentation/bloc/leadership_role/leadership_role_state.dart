import 'package:equatable/equatable.dart';

enum LeadershipRoleStatus { initial, submitting, success, failure }

class LeadershipRoleState extends Equatable {
  final LeadershipRoleStatus status;
  final String? errorMessage;
  final String? successMessage;

  const LeadershipRoleState({
    this.status = LeadershipRoleStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  LeadershipRoleState copyWith({
    LeadershipRoleStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return LeadershipRoleState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, successMessage];
}
