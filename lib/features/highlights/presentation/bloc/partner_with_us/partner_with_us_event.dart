import 'package:equatable/equatable.dart';
import '../../../domain/entities/partner_with_us_entity.dart';

abstract class PartnerWithUsEvent extends Equatable {
  const PartnerWithUsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPartnerWithUsHistoryEvent extends PartnerWithUsEvent {
  const FetchPartnerWithUsHistoryEvent();
}

class SubmitPartnerWithUsEvent extends PartnerWithUsEvent {
  final PartnerWithUsEntity entity;

  const SubmitPartnerWithUsEvent(this.entity);

  @override
  List<Object?> get props => [entity];
}

class ResetPartnerWithUsStateEvent extends PartnerWithUsEvent {
  const ResetPartnerWithUsStateEvent();
}
