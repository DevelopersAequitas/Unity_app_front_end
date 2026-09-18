import 'package:equatable/equatable.dart';
import '../../../domain/entities/leadership_interest_entity.dart';

abstract class LeadershipRoleEvent extends Equatable {
  const LeadershipRoleEvent();

  @override
  List<Object?> get props => [];
}

class SubmitLeadershipRoleInterestEvent extends LeadershipRoleEvent {
  final LeadershipInterestEntity interest;

  const SubmitLeadershipRoleInterestEvent(this.interest);

  @override
  List<Object?> get props => [interest];
}
