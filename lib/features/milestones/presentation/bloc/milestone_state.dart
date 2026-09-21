import 'package:equatable/equatable.dart';
import '../../domain/entities/milestone_entity.dart';

enum MilestoneStatus { initial, loading, success, failure }

class MilestoneState extends Equatable {
  final MilestoneStatus status;
  final LatestMilestoneEntity? latestMilestone;
  final List<MilestoneItemEntity> history;
  final String? errorMessage;

  const MilestoneState({
    this.status = MilestoneStatus.initial,
    this.latestMilestone,
    this.history = const [],
    this.errorMessage,
  });

  MilestoneState copyWith({
    MilestoneStatus? status,
    LatestMilestoneEntity? latestMilestone,
    List<MilestoneItemEntity>? history,
    String? errorMessage,
  }) {
    return MilestoneState(
      status: status ?? this.status,
      latestMilestone: latestMilestone ?? this.latestMilestone,
      history: history ?? this.history,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        latestMilestone,
        history,
        errorMessage,
      ];
}
