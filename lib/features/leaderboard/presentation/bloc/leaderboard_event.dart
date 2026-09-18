import 'package:equatable/equatable.dart';

enum LeaderboardType {
  coins,
  impact,
}

abstract class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object?> get props => [];
}

class LeaderboardFetchRequested extends LeaderboardEvent {
  final bool forceRefresh;

  const LeaderboardFetchRequested({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

