import 'package:equatable/equatable.dart';
import '../../domain/entities/business_deal_entity.dart';

enum BusinessDealTab { leaderboard, received, given }

abstract class BusinessDealsEvent extends Equatable {
  const BusinessDealsEvent();

  @override
  List<Object?> get props => [];
}

class BusinessDealsTabChanged extends BusinessDealsEvent {
  final BusinessDealTab tab;

  const BusinessDealsTabChanged(this.tab);

  @override
  List<Object?> get props => [tab];
}

class BusinessDealsFetchLeaderboardRequested extends BusinessDealsEvent {
  final bool forceRefresh;

  const BusinessDealsFetchLeaderboardRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class BusinessDealsFetchReceivedRequested extends BusinessDealsEvent {
  final bool forceRefresh;

  const BusinessDealsFetchReceivedRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class BusinessDealsFetchGivenRequested extends BusinessDealsEvent {
  final bool forceRefresh;

  const BusinessDealsFetchGivenRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class BusinessDealsFetchUserRequested extends BusinessDealsEvent {
  final String userId;

  const BusinessDealsFetchUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class BusinessDealCreatedLocally extends BusinessDealsEvent {
  final BusinessDealEntity deal;

  const BusinessDealCreatedLocally(this.deal);

  @override
  List<Object?> get props => [deal];
}

class BusinessDealsLoadMoreReceivedRequested extends BusinessDealsEvent {
  const BusinessDealsLoadMoreReceivedRequested();
}

class BusinessDealsLoadMoreGivenRequested extends BusinessDealsEvent {
  const BusinessDealsLoadMoreGivenRequested();
}

class BusinessDealsLoadMoreUserRequested extends BusinessDealsEvent {
  final String userId;

  const BusinessDealsLoadMoreUserRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class BusinessDealsSearchChanged extends BusinessDealsEvent {
  final String query;

  const BusinessDealsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
