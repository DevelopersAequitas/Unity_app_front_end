import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
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

  const NotificationEntity({
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

  NotificationEntity copyWith({
    String? id,
    String? type,
    String? category,
    String? title,
    String? body,
    String? message,
    String? channel,
    String? priority,
    String? screen,
    String? tapDestination,
    String? referenceType,
    String? referenceId,
    String? avatarUrl,
    String? actorName,
    bool? isRead,
    DateTime? sentAt,
    DateTime? readAt,
    DateTime? clickedAt,
    DateTime? createdAt,
    Map<String, dynamic>? metaData,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      message: message ?? this.message,
      channel: channel ?? this.channel,
      priority: priority ?? this.priority,
      screen: screen ?? this.screen,
      tapDestination: tapDestination ?? this.tapDestination,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      actorName: actorName ?? this.actorName,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      clickedAt: clickedAt ?? this.clickedAt,
      createdAt: createdAt ?? this.createdAt,
      metaData: metaData ?? this.metaData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        category,
        title,
        body,
        message,
        channel,
        priority,
        screen,
        tapDestination,
        referenceType,
        referenceId,
        avatarUrl,
        actorName,
        isRead,
        sentAt,
        readAt,
        clickedAt,
        createdAt,
        metaData,
      ];
}
