/// Model representing the event popup configuration returned by
/// `GET /events/all-with-live-status` or `/events/popups`.
class EventPopupModel {
  final String eventId;
  final String? occurrenceId;
  final String eventName;
  final String? address;
  final String circleName;
  final String eventType;
  final String circleId;
  final String? imageUrl;
  final bool showPopup;
  final bool realtimePopup;
  final String popupTitle;
  final String popupMessage;
  final String? popupActionUrl;
  final int popupVersion;
  final bool alreadySeen;
  final DateTime updatedAt;
  final String? startDatetime;
  final String? endDatetime;

  const EventPopupModel({
    required this.eventId,
    this.occurrenceId,
    required this.eventName,
    this.address,
    required this.circleName,
    required this.eventType,
    required this.circleId,
    this.imageUrl,
    required this.showPopup,
    required this.realtimePopup,
    required this.popupTitle,
    required this.popupMessage,
    this.popupActionUrl,
    required this.popupVersion,
    required this.alreadySeen,
    required this.updatedAt,
    this.startDatetime,
    this.endDatetime,
  });

  /// Parse from a standard JSON map.
  factory EventPopupModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return DateTime.now();
      }
    }

    return EventPopupModel(
      eventId: (json['event_id'] ?? json['id'] ?? '').toString(),
      occurrenceId: json['occurrence_id']?.toString(),
      eventName: (json['event_name'] ?? json['title'] ?? '').toString(),
      address: json['address']?.toString(),
      circleName: (json['circle_name'] ?? '').toString(),
      eventType: (json['event_type'] ?? '').toString(),
      circleId: (json['circle_id'] ?? '').toString(),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      showPopup: json['show_popup'] == true ||
          json['show_popup']?.toString() == '1' ||
          json['show_popup'] == null,
      realtimePopup: json['realtime_popup'] == true ||
          json['realtime_popup']?.toString() == '1',
      popupTitle: (json['popup_title'] ?? 'New Event Alert').toString(),
      popupMessage: (json['popup_message'] ??
              json['description'] ??
              'A new event is available. Register now.')
          .toString(),
      popupActionUrl: json['popup_action_url']?.toString(),
      popupVersion: (json['popup_version'] is int)
          ? json['popup_version'] as int
          : int.tryParse(json['popup_version']?.toString() ?? '0') ?? 0,
      alreadySeen: json['already_seen'] == true ||
          json['already_seen']?.toString() == '1',
      updatedAt: parseDate(json['updated_at'] ?? json['start_datetime']),
      startDatetime: json['start_datetime']?.toString(),
      endDatetime: json['end_datetime']?.toString(),
    );
  }

  /// Map from an item in `/events/all-with-live-status` response list.
  factory EventPopupModel.fromLiveStatusEvent(Map<String, dynamic> json) {
    final isLive = json['is_live_event'] == true ||
        json['event_status']?.toString().toLowerCase() == 'live';
    final title = (json['title'] ?? json['event_name'] ?? 'Event').toString();
    final circleName = (json['circle_name'] ?? '').toString();
    final description = json['description']?.toString();

    return EventPopupModel(
      eventId: (json['event_id'] ?? json['id'] ?? '').toString(),
      occurrenceId: json['occurrence_id']?.toString(),
      eventName: title,
      address: json['address']?.toString(),
      circleName: circleName,
      eventType: (json['event_type'] ?? '').toString(),
      circleId: (json['circle_id'] ?? '').toString(),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      showPopup: json['show_popup'] != false &&
          json['show_popup']?.toString() != '0',
      realtimePopup: false,
      popupTitle: isLive ? 'Live Event Alert!' : 'Upcoming Event Alert!',
      popupMessage: description != null && description.isNotEmpty
          ? description
          : (circleName.isNotEmpty
              ? 'A new event "$title" is scheduled by $circleName.'
              : 'A new event "$title" is scheduled.'),
      popupActionUrl: json['popup_action_url']?.toString(),
      popupVersion: 1,
      alreadySeen: false,
      updatedAt: DateTime.tryParse(json['start_datetime']?.toString() ?? '') ??
          DateTime.now(),
      startDatetime: json['start_datetime']?.toString(),
      endDatetime: json['end_datetime']?.toString(),
    );
  }

  /// Unique key used to track the "seen" state if desired.
  String get seenKey => 'event_popup_seen_${eventId}_$popupVersion';

  @override
  String toString() =>
      'EventPopupModel(eventId=$eventId, eventName=$eventName, '
      'showPopup=$showPopup, realtimePopup=$realtimePopup, '
      'popupVersion=$popupVersion)';
}
