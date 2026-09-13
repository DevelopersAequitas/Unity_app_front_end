import '../../domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String type;
  final String category;
  final String title;
  final String body;
  final String message;
  final String channel;
  final String priority;
  final String? screen;
  final String? tapDestination;
  final String? referenceType;
  final String? referenceId;
  final String? avatarUrl;
  final String? actorName;
  final bool isRead;
  final DateTime? sentAt;
  final DateTime? readAt;
  final DateTime? clickedAt;
  final DateTime? createdAt;
  final Map<String, dynamic>? metaData;

  const NotificationModel({
    required this.id,
    this.type = '',
    this.category = '',
    this.title = '',
    this.body = '',
    this.message = '',
    this.channel = '',
    this.priority = '',
    this.screen,
    this.tapDestination,
    this.referenceType,
    this.referenceId,
    this.avatarUrl,
    this.actorName,
    this.isRead = false,
    this.sentAt,
    this.readAt,
    this.clickedAt,
    this.createdAt,
    this.metaData,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawPayload = json['payload'];
    Map<String, dynamic>? meta;
    if (rawData is Map<String, dynamic>) {
      meta = Map<String, dynamic>.from(rawData);
    } else if (rawPayload is Map<String, dynamic>) {
      meta = Map<String, dynamic>.from(rawPayload);
    }

    String? avatar = json['avatar_url'] as String? ??
        json['avatar'] as String? ??
        meta?['avatar_url'] as String? ??
        meta?['avatar'] as String? ??
        meta?['profile_image'] as String? ??
        meta?['image_url'] as String? ??
        meta?['sender_avatar'] as String?;

    String? actor = meta?['actor_name'] as String? ??
        meta?['user_name'] as String? ??
        meta?['name'] as String? ??
        meta?['sender_name'] as String? ??
        json['actor_name'] as String?;

    bool parseIsRead(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is num) return value == 1;
      if (value is String) {
        final lower = value.toLowerCase().trim();
        return lower == 'true' || lower == '1' || lower == 'read';
      }
      return false;
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        return DateTime.tryParse(value)?.toLocal();
      }
      return null;
    }

    final rawTitle = (json['title'] ?? meta?['title'] ?? '').toString();
    final rawBody = (json['body'] ??
            json['message'] ??
            meta?['body'] ??
            meta?['message'] ??
            '')
        .toString();

    return NotificationModel(
      id: (json['id'] ?? '').toString(),
      type: (json['type'] ?? meta?['type'] ?? '').toString(),
      category: (json['category'] ?? meta?['category'] ?? '').toString(),
      title: rawTitle,
      body: rawBody,
      message: (json['message'] ?? rawBody).toString(),
      channel: (json['channel'] ?? '').toString(),
      priority: (json['priority'] ?? 'normal').toString(),
      screen: json['screen'] as String? ?? meta?['screen'] as String?,
      tapDestination: json['tap_destination'] as String? ??
          meta?['tap_destination'] as String? ??
          json['destination'] as String?,
      referenceType: json['reference_type'] as String? ??
          meta?['reference_type'] as String?,
      referenceId: json['reference_id']?.toString() ??
          meta?['reference_id']?.toString() ??
          meta?['user_id']?.toString() ??
          meta?['post_id']?.toString(),
      avatarUrl: avatar,
      actorName: actor,
      isRead: parseIsRead(json['is_read'] ?? json['read_at'] != null),
      sentAt: parseDate(json['sent_at']),
      readAt: parseDate(json['read_at']),
      clickedAt: parseDate(json['clicked_at']),
      createdAt: parseDate(json['created_at']),
      metaData: meta,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'title': title,
      'body': body,
      'message': message,
      'channel': channel,
      'priority': priority,
      'screen': screen,
      'tap_destination': tapDestination,
      'reference_type': referenceType,
      'reference_id': referenceId,
      'avatar_url': avatarUrl,
      'actor_name': actorName,
      'is_read': isRead,
      'sent_at': sentAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'clicked_at': clickedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'data': metaData,
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      type: type,
      category: category,
      title: title,
      body: body,
      message: message,
      channel: channel,
      priority: priority,
      screen: screen,
      tapDestination: tapDestination,
      referenceType: referenceType,
      referenceId: referenceId,
      avatarUrl: avatarUrl,
      actorName: actorName,
      isRead: isRead,
      sentAt: sentAt,
      readAt: readAt,
      clickedAt: clickedAt,
      createdAt: createdAt,
      metaData: metaData,
    );
  }
}
