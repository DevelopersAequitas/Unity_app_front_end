import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllEventsEvent extends EventsEvent {
  final bool isRefresh;
  final String? circleId;

  const FetchAllEventsEvent({this.isRefresh = false, this.circleId});

  @override
  List<Object?> get props => [isRefresh, circleId];
}

class ChangeEventFilterTabEvent extends EventsEvent {
  final String filter; // 'all', 'today', 'upcoming', 'past'

  const ChangeEventFilterTabEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class SearchEventsQueryEvent extends EventsEvent {
  final String query;

  const SearchEventsQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}
