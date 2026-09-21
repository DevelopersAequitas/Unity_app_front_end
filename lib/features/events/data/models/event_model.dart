import 'package:unity_app/features/events/domain/entities/user_registration_info.dart';

import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/event_entity.dart';

class EventCircleModel extends EventCircleEntity {
  const EventCircleModel({
    required super.id,
    required super.name,
    super.slug,
    super.stateName,
  });

  factory EventCircleModel.fromJson(Map<String, dynamic> json) {
    return EventCircleModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      stateName: json['state_name']?.toString() ?? json['state']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'state_name': stateName,
    };
  }
}

class EventModel extends EventEntity {
  const EventModel({
    required super.eventId,
    required super.occurrenceId,
    required super.title,
    super.description = '',
    super.eventType = 'chapter_event',
    super.eventCategory = 'networking',
    super.mode = 'in_person',
    super.startAt,
    super.endAt,
    super.formattedStartAt,
    super.recurrence,
    super.status = 'scheduled',
    super.registeredCount = 0,
    super.checkedInCount = 0,
    super.imageUrl,
    super.location,
    super.meetingLink,
    super.circleId,
    super.circleIds = const [],
    super.circles = const [],
    super.circle,
    super.groupStatus = 'upcoming',
    super.isPaid = false,
    super.ticketPrice,
    super.currency = 'INR',
    super.visitorRegistrationEnabled = true,
    super.userRegistration,
    super.displayDate,
    super.displayTime,
    super.whatYoullGain = const [],
    super.agendaItems = const [],
    super.speakers = const [],
    super.organizerName,
  });

  @override
  EventModel copyWith({
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
    return EventModel(
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

  factory EventModel.fromJson(Map<String, dynamic> json, {String defaultGroup = 'upcoming'}) {
    final eventObj = json['event'] is Map<String, dynamic>
        ? json['event'] as Map<String, dynamic>
        : (json['occurrence'] is Map<String, dynamic> &&
                (json['occurrence'] as Map<String, dynamic>)['event'] is Map<String, dynamic>
            ? (json['occurrence'] as Map<String, dynamic>)['event'] as Map<String, dynamic>
            : null);

    final eventId = (json['event_id'] ?? json['id'] ?? eventObj?['id'] ?? eventObj?['event_id'] ?? '').toString();
    final occurrenceId = (json['occurrence_id'] ?? json['id'] ?? eventId).toString();
    final title = (json['title'] ?? json['name'] ?? eventObj?['title'] ?? eventObj?['name'] ?? '').toString();
    final description = (json['description'] ?? json['about'] ?? eventObj?['description'] ?? eventObj?['about'] ?? '').toString();
    final eventType = (json['event_type'] ?? eventObj?['event_type'] ?? 'chapter_event').toString();
    final eventCategory = (json['event_category'] ?? eventObj?['event_category'] ?? '').toString();
    // mode can be 'one_time', 'online', 'in_person', or null; map delivery_mode as fallback
    final mode = (json['mode'] ?? json['delivery_mode'] ?? eventObj?['mode'] ?? eventObj?['delivery_mode'] ?? '').toString();

    final startAt = AppDateFormatter.parseUtc(
      json['start_at'] ?? json['start_date'] ?? eventObj?['start_at'] ?? eventObj?['start_date'],
    );
    final endAt = AppDateFormatter.parseUtc(
      json['end_at'] ?? json['end_date'] ?? eventObj?['end_at'] ?? eventObj?['end_date'],
    );
    final formattedStartAt = json['formatted_start_at']?.toString() ?? eventObj?['formatted_start_at']?.toString();
    final recurrence = json['recurrence']?.toString() ?? eventObj?['recurrence']?.toString();
    final status = (json['status'] ?? eventObj?['status'] ?? 'scheduled').toString();

    final registeredCount = int.tryParse((json['registered_count'] ?? eventObj?['registered_count'] ?? '').toString()) ?? 0;
    final checkedInCount = int.tryParse((json['checked_in_count'] ?? eventObj?['checked_in_count'] ?? '').toString()) ?? 0;

    final imageUrl = json['image_url']?.toString() ??
        json['imageUrl']?.toString() ??
        json['banner_url']?.toString() ??
        json['bannerUrl']?.toString() ??
        json['cover_url']?.toString() ??
        json['coverUrl']?.toString() ??
        json['media_url']?.toString() ??
        json['poster_url']?.toString() ??
        json['image']?.toString() ??
        json['banner']?.toString() ??
        json['cover']?.toString() ??
        json['flyer_url']?.toString() ??
        json['photo_url']?.toString() ??
        eventObj?['image_url']?.toString() ??
        eventObj?['imageUrl']?.toString() ??
        eventObj?['banner_url']?.toString() ??
        eventObj?['bannerUrl']?.toString() ??
        eventObj?['cover_url']?.toString() ??
        eventObj?['coverUrl']?.toString() ??
        eventObj?['media_url']?.toString() ??
        eventObj?['poster_url']?.toString() ??
        eventObj?['image']?.toString() ??
        eventObj?['banner']?.toString() ??
        eventObj?['cover']?.toString() ??
        (json['media'] is Map ? json['media']['url']?.toString() : null) ??
        (eventObj?['media'] is Map ? eventObj!['media']['url']?.toString() : null);

    // location can be a nested map {text, venue_name, city, state} or a plain string
    String? extractLocation(dynamic raw, dynamic textFallback) {
      if (raw is Map<String, dynamic>) {
        return raw['text']?.toString() ??
            raw['venue_name']?.toString() ??
            raw['location_text']?.toString();
      }
      if (raw is String && raw.isNotEmpty) return raw;
      if (textFallback is String && textFallback.isNotEmpty) return textFallback;
      return null;
    }

    final location = extractLocation(json['location'], json['location_text']) ??
        extractLocation(eventObj?['location'], eventObj?['location_text']) ??
        json['venue']?.toString() ??
        json['address']?.toString();

    final meetingLink = json['meeting_link']?.toString() ??
        json['online_meeting_url']?.toString() ??
        eventObj?['meeting_link']?.toString();

    final circleJson = json['circle'] ??
        eventObj?['circle'] ??
        (json['basic_details'] is Map ? json['basic_details']['circle'] : null);
    final circle = circleJson is Map<String, dynamic> ? EventCircleModel.fromJson(circleJson) : null;

    final circleId = json['circle_id']?.toString() ??
        eventObj?['circle_id']?.toString() ??
        circle?.id ??
        (json['basic_details'] is Map && json['basic_details']['circle_id'] != null
            ? json['basic_details']['circle_id']?.toString()
            : null);

    final circleIds = (json['circle_ids'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        (eventObj?['circle_ids'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        (circleId != null && circleId.isNotEmpty ? [circleId] : <String>[]);

    final circles = (json['circles'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map((c) => EventCircleModel.fromJson(c))
            .toList() ??
        (eventObj?['circles'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map((c) => EventCircleModel.fromJson(c))
            .toList() ??
        (circle != null ? [circle] : <EventCircleModel>[]);

    final groupStatus = json['group_status']?.toString() ?? eventObj?['group_status']?.toString() ?? defaultGroup;
    final isPaid = json['is_paid'] == true || json['is_paid'] == 1 || eventObj?['is_paid'] == true;
    final ticketPrice = json['ticket_price']?.toString() ?? json['price']?.toString() ?? eventObj?['ticket_price']?.toString();
    final currency = json['currency']?.toString() ?? eventObj?['currency']?.toString() ?? 'INR';
    final visitorRegistrationEnabled = json['visitor_registration_enabled'] != false;

    final userRegistrationJson = json['user_registration'] ?? json['registration'] ?? json['my_registration'];
    final userRegistration = userRegistrationJson is Map<String, dynamic>
        ? UserRegistrationInfo.fromJson(userRegistrationJson)
        : null;

    // --- Display date/time (server-formatted, correct timezone) ---
    final displayDate = json['display_date']?.toString() ??
        eventObj?['display_date']?.toString();
    final displayTime = json['display_time']?.toString() ??
        eventObj?['display_time']?.toString();

    // --- What you'll gain ---
    final whatYoullGainRaw = (json['what_youll_gain'] as List<dynamic>?) ??
        (eventObj?['what_youll_gain'] as List<dynamic>?) ??
        <dynamic>[];
    final whatYoullGain = whatYoullGainRaw
        .whereType<String>()
        .toList();

    // --- Agenda ---
    final agendaRaw = (json['agenda'] as List<dynamic>?) ??
        (eventObj?['agenda'] as List<dynamic>?) ??
        <dynamic>[];
    final agendaItems = agendaRaw
        .whereType<Map<String, dynamic>>()
        .map((a) => <String, String>{
              'time': a['time']?.toString() ?? '',
              'title': a['title']?.toString() ?? '',
            })
        .toList();

    // --- Speakers ---
    final speakersRaw = (json['speakers'] as List<dynamic>?) ??
        (eventObj?['speakers'] as List<dynamic>?) ??
        <dynamic>[];
    final speakersData = speakersRaw
        .whereType<Map<String, dynamic>>()
        .map((s) => <String, String>{
              'name': s['name']?.toString() ?? '',
              'designation': s['designation']?.toString() ?? '',
              'company': s['company']?.toString() ?? '',
              'photo_url': s['photo_url']?.toString() ?? '',
              'initials': s['initials']?.toString() ?? '',
            })
        .toList();

    // --- Organizer ---
    final organizerJson = json['organizer'] is Map<String, dynamic>
        ? json['organizer'] as Map<String, dynamic>
        : (eventObj?['organizer'] is Map<String, dynamic>
            ? eventObj!['organizer'] as Map<String, dynamic>
            : null);
    final organizerName = organizerJson != null
        ? organizerJson['name']?.toString()
        : null;

    return EventModel(
      eventId: eventId,
      occurrenceId: occurrenceId,
      title: title,
      description: description,
      eventType: eventType,
      eventCategory: eventCategory,
      mode: mode,
      startAt: startAt,
      endAt: endAt,
      formattedStartAt: formattedStartAt,
      recurrence: recurrence,
      status: status,
      registeredCount: registeredCount,
      checkedInCount: checkedInCount,
      imageUrl: imageUrl,
      location: location,
      meetingLink: meetingLink,
      circleId: circleId,
      circleIds: circleIds,
      circles: circles,
      circle: circle,
      groupStatus: groupStatus,
      isPaid: isPaid,
      ticketPrice: ticketPrice,
      currency: currency,
      visitorRegistrationEnabled: visitorRegistrationEnabled,
      userRegistration: userRegistration,
      displayDate: displayDate,
      displayTime: displayTime,
      whatYoullGain: whatYoullGain,
      agendaItems: agendaItems,
      speakers: speakersData,
      organizerName: organizerName,
    );
  }
}
