import 'package:equatable/equatable.dart';
import '../../../domain/entities/register_visitor_entity.dart';

abstract class RegisterVisitorEvent extends Equatable {
  const RegisterVisitorEvent();

  @override
  List<Object?> get props => [];
}

class FetchRegisterVisitorHistoryEvent extends RegisterVisitorEvent {
  final bool isRefresh;
  const FetchRegisterVisitorHistoryEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class SubmitRegisterVisitorEvent extends RegisterVisitorEvent {
  final RegisterVisitorEntity entity;
  const SubmitRegisterVisitorEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class FetchEventsEvent extends RegisterVisitorEvent {
  final bool isRefresh;
  const FetchEventsEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}
