import 'package:equatable/equatable.dart';
import '../../../domain/entities/life_impact_entity.dart';

enum LifeImpactStatus { initial, loading, success, failure }

class LifeImpactState extends Equatable {
  final LifeImpactStatus status;
  final List<LifeImpactEntity> history;
  final bool isSubmitting;
  final String? errorMessage;
  final String? successMessage;

  const LifeImpactState({
    this.status = LifeImpactStatus.initial,
    this.history = const [],
    this.isSubmitting = false,
    this.errorMessage,
    this.successMessage,
  });

  int get totalScore => history.fold<int>(0, (sum, item) => sum + item.impactPoints);

  LifeImpactState copyWith({
    LifeImpactStatus? status,
    List<LifeImpactEntity>? history,
    bool? isSubmitting,
    String? errorMessage,
    String? successMessage,
  }) {
    return LifeImpactState(
      status: status ?? this.status,
      history: history ?? this.history,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, history, isSubmitting, errorMessage, successMessage];
}
