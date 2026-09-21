import 'package:equatable/equatable.dart';
import '../../../domain/entities/submit_life_impact_params.dart';

sealed class LifeImpactEvent extends Equatable {
  const LifeImpactEvent();

  @override
  List<Object?> get props => [];
}

class FetchLifeImpactHistoryEvent extends LifeImpactEvent {
  final bool isRefresh;
  const FetchLifeImpactHistoryEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class FetchLifeImpactActionsEvent extends LifeImpactEvent {
  const FetchLifeImpactActionsEvent();
}

class SubmitLifeImpactEvent extends LifeImpactEvent {
  final SubmitLifeImpactParams params;
  const SubmitLifeImpactEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class ChangeLifeImpactFilterEvent extends LifeImpactEvent {
  final String filter;
  const ChangeLifeImpactFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
