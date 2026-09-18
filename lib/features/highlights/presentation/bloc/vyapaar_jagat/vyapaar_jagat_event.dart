import 'package:equatable/equatable.dart';
import '../../../domain/entities/vyapaar_jagat_story_entity.dart';

abstract class VyapaarJagatEvent extends Equatable {
  const VyapaarJagatEvent();

  @override
  List<Object?> get props => [];
}

class FetchStoryStatusEvent extends VyapaarJagatEvent {
  const FetchStoryStatusEvent();
}

class SubmitStoryEvent extends VyapaarJagatEvent {
  final VyapaarJagatStoryEntity entity;

  const SubmitStoryEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class ResetVyapaarJagatStateEvent extends VyapaarJagatEvent {
  const ResetVyapaarJagatStateEvent();
}
