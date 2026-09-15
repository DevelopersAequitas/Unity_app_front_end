import 'package:equatable/equatable.dart';

abstract class MembershipEvent extends Equatable {
  const MembershipEvent();

  @override
  List<Object?> get props => [];
}

class MembershipPlansFetchRequested extends MembershipEvent {
  const MembershipPlansFetchRequested();
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
