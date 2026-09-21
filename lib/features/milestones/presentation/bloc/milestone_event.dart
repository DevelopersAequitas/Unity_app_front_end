import 'package:equatable/equatable.dart';

abstract class MilestoneEvent extends Equatable {
  const MilestoneEvent();

  @override
  List<Object?> get props => [];
}

class FetchMilestonesEvent extends MilestoneEvent {
  final String userId;
  final bool isRefresh;

  const FetchMilestonesEvent({
    required this.userId,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [userId, isRefresh];
}
