import 'package:equatable/equatable.dart';
import '../../domain/entities/referral_entity.dart';

enum ReferralTab { received, given }

abstract class ReferralsEvent extends Equatable {
  const ReferralsEvent();

  @override
  List<Object?> get props => [];
}

class ReferralsTabChanged extends ReferralsEvent {
  final ReferralTab tab;
  const ReferralsTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class ReferralsFetchStatsRequested extends ReferralsEvent {
  final bool forceRefresh;
  const ReferralsFetchStatsRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class ReferralsFetchReceivedRequested extends ReferralsEvent {
  final bool forceRefresh;
  const ReferralsFetchReceivedRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class ReferralsLoadMoreReceivedRequested extends ReferralsEvent {
  const ReferralsLoadMoreReceivedRequested();
}

class ReferralsFetchGivenRequested extends ReferralsEvent {
  final bool forceRefresh;
  const ReferralsFetchGivenRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class ReferralsLoadMoreGivenRequested extends ReferralsEvent {
  const ReferralsLoadMoreGivenRequested();
}

class ReferralsStatusesFetchRequested extends ReferralsEvent {
  const ReferralsStatusesFetchRequested();
}

class ReferralStatusUpdated extends ReferralsEvent {
  final String referralId;
  final int statusId;
  final String statusName;

  const ReferralStatusUpdated({
    required this.referralId,
    required this.statusId,
    required this.statusName,
  });

  @override
  List<Object?> get props => [referralId, statusId, statusName];
}

class ReferralCreatedLocally extends ReferralsEvent {
  final ReferralEntity referral;
  const ReferralCreatedLocally(this.referral);

  @override
  List<Object?> get props => [referral];
}

class ReferralsSearchChanged extends ReferralsEvent {
  final String query;
  const ReferralsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ReferralsStatusFilterChanged extends ReferralsEvent {
  final String? statusFilter; // e.g. null for All, "Pending", "Contacted", "Got Business", "Not Qualified"
  const ReferralsStatusFilterChanged(this.statusFilter);

  @override
  List<Object?> get props => [statusFilter];
}
