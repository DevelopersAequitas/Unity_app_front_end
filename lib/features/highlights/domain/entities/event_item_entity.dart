class EventItemEntity {
  final String id;
  final String occurrenceId;
  final String title;
  final String eventType;
  final String? deliveryMode;
  final String? circleName;
  final String startAt;
  final String startDate;
  final String startTime;
  final String displayDate;
  final String displayTime;
  final String? locationText;
  final String? venueName;
  final String? city;
  final String? onlineMeetingUrl;
  final bool isPaid;
  final String? ticketPrice;

  const EventItemEntity({
    required this.id,
    required this.occurrenceId,
    required this.title,
    required this.eventType,
    this.deliveryMode,
    this.circleName,
    required this.startAt,
    required this.startDate,
    required this.startTime,
    required this.displayDate,
    required this.displayTime,
    this.locationText,
    this.venueName,
    this.city,
    this.onlineMeetingUrl,
    required this.isPaid,
    this.ticketPrice,
  });

  bool get isOnline {
    final mode = deliveryMode?.toLowerCase().trim() ?? '';
    final type = eventType.toLowerCase().trim();
    final url = onlineMeetingUrl?.trim() ?? '';
    return mode == 'online' || type == 'online' || url.isNotEmpty;
  }

  bool get isPhysical => !isOnline;
}
