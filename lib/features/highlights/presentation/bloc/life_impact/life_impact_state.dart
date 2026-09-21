import 'package:equatable/equatable.dart';
import '../../../domain/entities/life_impact_entity.dart';

enum LifeImpactStatus { initial, loading, success, failure }

class LifeImpactState extends Equatable {
  final LifeImpactStatus status;
  final LifeImpactStatus actionsStatus;
  final int totalScore;
  final List<LifeImpactEntity> history;
  final List<String> actions;
  final String selectedFilter;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const LifeImpactState({
    this.status = LifeImpactStatus.initial,
    this.actionsStatus = LifeImpactStatus.initial,
    this.totalScore = 0,
    this.history = const [],
    this.actions = const [],
    this.selectedFilter = 'all',
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  List<LifeImpactEntity> get filteredHistory {
    if (selectedFilter == 'all') return history;
    return history.where((item) {
      if (selectedFilter == 'p2p_meeting') {
        return item.activityType == 'p2p_meeting' || item.actionKey == 'p2p_meeting';
      }
      if (selectedFilter == 'business_deal') {
        return item.activityType == 'business_deal' || item.actionKey == 'business_deal';
      }
      if (selectedFilter == 'referral') {
        return item.activityType == 'referral' || item.actionKey == 'referral';
      }
      if (selectedFilter == 'testimonial') {
        return item.activityType == 'testimonial' || item.actionKey == 'testimonial';
      }
      if (selectedFilter == 'adjustment') {
        return item.activityType == 'admin_adjustment' || item.actionKey == 'admin_adjustment';
      }
      return true;
    }).toList();
  }

  LifeImpactState copyWith({
    LifeImpactStatus? status,
    LifeImpactStatus? actionsStatus,
    int? totalScore,
    List<LifeImpactEntity>? history,
    List<String>? actions,
    String? selectedFilter,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
  }) {
    return LifeImpactState(
      status: status ?? this.status,
      actionsStatus: actionsStatus ?? this.actionsStatus,
      totalScore: totalScore ?? this.totalScore,
      history: history ?? this.history,
      actions: actions ?? this.actions,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        actionsStatus,
        totalScore,
        history,
        actions,
        selectedFilter,
        isSubmitting,
        errorMessage,
        successMessage,
      ];
}
