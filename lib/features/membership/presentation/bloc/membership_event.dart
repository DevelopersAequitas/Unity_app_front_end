import 'package:equatable/equatable.dart';
import 'package:unity_app/features/membership/domain/entities/membership_plan_entity.dart';

abstract class MembershipEvent extends Equatable {
  const MembershipEvent();

  @override
  List<Object?> get props => [];
}

class MembershipPlansFetchRequested extends MembershipEvent {
  const MembershipPlansFetchRequested();
}

class MembershipPlanSelected extends MembershipEvent {
  final MembershipPlanEntity plan;

  const MembershipPlanSelected(this.plan);

  @override
  List<Object?> get props => [plan];
}

class MembershipCheckoutInitiated extends MembershipEvent {
  final String planCode;

  const MembershipCheckoutInitiated(this.planCode);

  @override
  List<Object?> get props => [planCode];
}

class MembershipCheckoutStatusVerified extends MembershipEvent {
  final String hostedPageId;

  const MembershipCheckoutStatusVerified(this.hostedPageId);

  @override
  List<Object?> get props => [hostedPageId];
}

class MembershipHistoryFetchRequested extends MembershipEvent {
  const MembershipHistoryFetchRequested();
}
