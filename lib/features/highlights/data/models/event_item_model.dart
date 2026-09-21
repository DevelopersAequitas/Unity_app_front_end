import '../../domain/entities/event_item_entity.dart';

class EventItemModel extends EventItemEntity {
  const EventItemModel({
    required super.id,
    required super.occurrenceId,
    required super.title,
    required super.eventType,
    super.deliveryMode,
    super.circleName,
    required super.startAt,
    required super.startDate,
    required super.startTime,
    required super.displayDate,
    required super.displayTime,
    super.locationText,
    super.venueName,
    super.city,
    super.onlineMeetingUrl,
    required super.isPaid,
    super.ticketPrice,
  });

  factory EventItemModel.fromJson(Map<String, dynamic> json) {
    String? circleName;
    if (json['circle'] is Map<String, dynamic>) {
      circleName = json['circle']['name']?.toString();
    } else if (json['circles'] is List && (json['circles'] as List).isNotEmpty) {
      final first = (json['circles'] as List).first;
      if (first is Map<String, dynamic>) {
        circleName = first['name']?.toString();
      }
    }

    String? venueName;
    String? city;
    String? locationText = json['location_text']?.toString();
    if (json['location'] is Map<String, dynamic>) {
      final loc = json['location'] as Map<String, dynamic>;
      venueName = loc['venue_name']?.toString() ?? loc['address_line']?.toString();
      city = loc['city']?.toString();
      locationText ??= loc['text']?.toString();
    }

    return EventItemModel(
      id: (json['id'] ?? json['event_id'] ?? '').toString(),
      occurrenceId: (json['occurrence_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      eventType: (json['event_type'] ?? json['type'] ?? 'circle_meeting').toString(),
      deliveryMode: json['delivery_mode']?.toString(),
      circleName: circleName,
      startAt: (json['start_at'] ?? '').toString(),
      startDate: (json['start_date'] ?? '').toString(),
      startTime: (json['start_time'] ?? '').toString(),
      displayDate: (json['display_date'] ?? '').toString(),
      displayTime: (json['display_time'] ?? '').toString(),
      locationText: locationText,
      venueName: venueName,
      city: city,
      onlineMeetingUrl: json['online_meeting_url']?.toString(),
      isPaid: json['is_paid'] == true || json['is_paid'] == 1,
      ticketPrice: json['ticket_price']?.toString(),
    );
  }
}
