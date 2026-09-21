import 'package:equatable/equatable.dart';

abstract class MyEventsEvent extends Equatable {
  const MyEventsEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyEventsEvent extends MyEventsEvent {
  final bool isRefresh;

  const FetchMyEventsEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class ChangeMyEventsTabEvent extends MyEventsEvent {
  final String tab; // 'registered', 'attending', 'past'

  const ChangeMyEventsTabEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}
