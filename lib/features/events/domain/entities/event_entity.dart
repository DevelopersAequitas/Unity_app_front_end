import 'package:equatable/equatable.dart';
import 'user_registration_info.dart';

class EventCircleEntity extends Equatable {
  final String id;
  final String name;
  final String? slug;
  final String? stateName;

  const EventCircleEntity({
    required this.id,
    required this.name,
    this.slug,
    this.stateName,
  });

  @override
  List<Object?> get props => [id, name, slug, stateName];
}

class EventEntity extends Equatable {
  final String eventId;
  final String occurrenceId;
  final String title;
  final String description;
  final String eventType;
  final String eventCategory;
  final String mode; // 'in_person' or 'online'
  final DateTime? startAt;
  final DateTime? endAt;
  final String? formattedStartAt;
  final String? recurrence;
  final String status;
  final int registeredCount;
  final int checkedInCount;
  final String? imageUrl;
  final String? location;
  final String? meetingLink;
  final String? circleId;
  final List<String> circleIds;
  final List<EventCircleEntity> circles;
  final EventCircleEntity? circle;
  final String groupStatus; // 'today', 'live', 'upcoming', 'past'
  final bool isPaid;
  final String? ticketPrice;
  final String? currency;
  final bool visitorRegistrationEnabled;
  final UserRegistrationInfo? userRegistration;

  // Rich display data from API
  final String? displayDate;   // display_date (server-formatted, correct timezone)
  final String? displayTime;   // display_time (server-formatted, correct timezone)
  final List<String> whatYoullGain;        // what_youll_gain
  final List<Map<String, String>> agendaItems;  // agenda [{time, title}]
  final List<Map<String, String>> speakers;     // speakers [{name, designation, company, photo_url}]
  final String? organizerName; // organizer.name

  const EventEntity({
    required this.eventId,
    required this.occurrenceId,
    required this.title,
    this.description = '',
    this.eventType = 'chapter_event',
    this.eventCategory = 'networking',
    this.mode = 'in_person',
    this.startAt,
    this.endAt,
    this.formattedStartAt,
    this.recurrence,
    this.status = 'scheduled',
    this.registeredCount = 0,
    this.checkedInCount = 0,
    this.imageUrl,
    this.location,
    this.meetingLink,
    this.circleId,
    this.circleIds = const [],
    this.circles = const [],
    this.circle,
    this.groupStatus = 'upcoming',
    this.isPaid = false,
    this.ticketPrice,
    this.currency = 'INR',
    this.visitorRegistrationEnabled = true,
    this.userRegistration,
    // Rich display data
    this.displayDate,
    this.displayTime,
    this.whatYoullGain = const [],
    this.agendaItems = const [],
    this.speakers = const [],
    this.organizerName,
  });

  bool get isInPerson => mode == 'in_person';
  bool get isOnline => mode == 'online';

  EventEntity copyWith({
    String? eventId,
    String? occurrenceId,
    String? title,
    String? description,
    String? eventType,
    String? eventCategory,
    String? mode,
    DateTime? startAt,
    DateTime? endAt,
    String? formattedStartAt,
    String? recurrence,
    String? status,
    int? registeredCount,
    int? checkedInCount,
    String? imageUrl,
    String? location,
    String? meetingLink,
    String? circleId,
    List<String>? circleIds,
    List<EventCircleEntity>? circles,
    EventCircleEntity? circle,
    String? groupStatus,
    bool? isPaid,
    String? ticketPrice,
    String? currency,
    bool? visitorRegistrationEnabled,
    UserRegistrationInfo? userRegistration,
    String? displayDate,
    String? displayTime,
    List<String>? whatYoullGain,
    List<Map<String, String>>? agendaItems,
    List<Map<String, String>>? speakers,
    String? organizerName,
  }) {
    return EventEntity(
      eventId: eventId ?? this.eventId,
      occurrenceId: occurrenceId ?? this.occurrenceId,
      title: title ?? this.title,
      description: description ?? this.description,
      eventType: eventType ?? this.eventType,
      eventCategory: eventCategory ?? this.eventCategory,
      mode: mode ?? this.mode,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      formattedStartAt: formattedStartAt ?? this.formattedStartAt,
      recurrence: recurrence ?? this.recurrence,
      status: status ?? this.status,
      registeredCount: registeredCount ?? this.registeredCount,
      checkedInCount: checkedInCount ?? this.checkedInCount,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      meetingLink: meetingLink ?? this.meetingLink,
      circleId: circleId ?? this.circleId,
      circleIds: circleIds ?? this.circleIds,
      circles: circles ?? this.circles,
      circle: circle ?? this.circle,
      groupStatus: groupStatus ?? this.groupStatus,
      isPaid: isPaid ?? this.isPaid,
      ticketPrice: ticketPrice ?? this.ticketPrice,
      currency: currency ?? this.currency,
      visitorRegistrationEnabled: visitorRegistrationEnabled ?? this.visitorRegistrationEnabled,
      userRegistration: userRegistration ?? this.userRegistration,
      displayDate: displayDate ?? this.displayDate,
      displayTime: displayTime ?? this.displayTime,
      whatYoullGain: whatYoullGain ?? this.whatYoullGain,
      agendaItems: agendaItems ?? this.agendaItems,
      speakers: speakers ?? this.speakers,
      organizerName: organizerName ?? this.organizerName,
    );
  }

  @override
  List<Object?> get props => [
        eventId,
        occurrenceId,
        title,
        description,
        eventType,
        eventCategory,
        mode,
        startAt,
        endAt,
        status,
        registeredCount,
        checkedInCount,
        imageUrl,
        location,
        circleId,
        groupStatus,
        isPaid,
        ticketPrice,
        userRegistration,
      ];
}
