import 'package:equatable/equatable.dart';

abstract class AskResponsesEvent extends Equatable {
  const AskResponsesEvent();

  @override
  List<Object?> get props => [];
}

class AskResponsesFetchRequested extends AskResponsesEvent {
  final String askId;

  const AskResponsesFetchRequested(this.askId);

  @override
  List<Object?> get props => [askId];
}

class AskResponsesFilterChanged extends AskResponsesEvent {
  final String filter; // 'all', 'direct_help', 'referral', 'intro'

  const AskResponsesFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}
