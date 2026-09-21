import 'package:equatable/equatable.dart';
import '../../domain/entities/event_entity.dart';

enum EventsStatus { initial, loading, success, failure }

class EventsState extends Equatable {
  final EventsStatus status;
  final Map<String, List<EventEntity>> eventsMap; // 'all', 'today', 'live', 'upcoming'
  final String activeFilter; // 'all', 'today', 'upcoming', 'past'
  final String searchQuery;
  final String? errorMessage;

  const EventsState({
    this.status = EventsStatus.initial,
    this.eventsMap = const {
      'all': [],
      'today': [],
      'live': [],
      'upcoming': [],
    },
    this.activeFilter = 'all',
    this.searchQuery = '',
    this.errorMessage,
  });

  List<EventEntity> get allEvents => eventsMap['all'] ?? [];
  List<EventEntity> get todayEvents => eventsMap['today'] ?? [];
  List<EventEntity> get liveEvents => eventsMap['live'] ?? [];
  List<EventEntity> get upcomingEvents {
    final explicitUpcoming = eventsMap['upcoming'] ?? [];
    if (explicitUpcoming.isNotEmpty) return explicitUpcoming;
    final now = DateTime.now();
    return allEvents.where((e) {
      if (e.groupStatus == 'upcoming' || e.groupStatus == 'live') return true;
      if (e.endAt != null) return e.endAt!.isAfter(now);
      if (e.startAt != null) return e.startAt!.isAfter(now);
      return false;
    }).toList();
  }

  List<EventEntity> get pastEvents {
    final explicitPast = eventsMap['past'] ?? [];
    final now = DateTime.now();
    final derivedPast = allEvents.where((e) {
      if (e.groupStatus == 'past') return true;
      if (e.endAt != null) return e.endAt!.isBefore(now);
      if (e.startAt != null) return e.startAt!.isBefore(now);
      return false;
    }).toList();

    final unique = <String, EventEntity>{};
    for (final e in explicitPast) {
      final key = e.occurrenceId.isNotEmpty ? e.occurrenceId : e.eventId;
      unique[key] = e;
    }
    for (final e in derivedPast) {
      final key = e.occurrenceId.isNotEmpty ? e.occurrenceId : e.eventId;
      unique[key] = e;
    }
    return unique.values.toList();
  }

  EventEntity? get featuredEvent {
    if (liveEvents.isNotEmpty) return liveEvents.first;
    if (todayEvents.isNotEmpty) return todayEvents.first;
    if (upcomingEvents.isNotEmpty) return upcomingEvents.first;
    if (allEvents.isNotEmpty) return allEvents.first;
    return null;
  }

  List<EventEntity> get filteredEvents {
    List<EventEntity> baseList = [];
    switch (activeFilter) {
      case 'today':
        baseList = todayEvents;
        break;
      case 'upcoming':
        baseList = upcomingEvents;
        break;
      case 'past':
        baseList = pastEvents;
        break;
      case 'all':
      default:
        baseList = allEvents;
        break;
    }

    if (searchQuery.trim().isEmpty) return baseList;
    final q = searchQuery.trim().toLowerCase();
    return baseList.where((e) {
      final titleMatch = e.title.toLowerCase().contains(q);
      final locMatch = (e.location ?? '').toLowerCase().contains(q);
      final catMatch = e.eventCategory.toLowerCase().contains(q);
      final circleMatch = e.circle != null && e.circle!.name.toLowerCase().contains(q);
      final descMatch = e.description.toLowerCase().contains(q);
      return titleMatch || locMatch || catMatch || circleMatch || descMatch;
    }).toList();
  }

  EventsState copyWith({
    EventsStatus? status,
    Map<String, List<EventEntity>>? eventsMap,
    String? activeFilter,
    String? searchQuery,
    String? errorMessage,
  }) {
    return EventsState(
      status: status ?? this.status,
      eventsMap: eventsMap ?? this.eventsMap,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        eventsMap,
        activeFilter,
        searchQuery,
        errorMessage,
      ];
}
