import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/message_reader_entity.dart';

class MessageReaderModel extends MessageReaderEntity {
  const MessageReaderModel({
    required super.id,
    required super.name,
    super.companyName,
    super.profilePhotoUrl,
    super.readAt,
  });

  factory MessageReaderModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['user_id'] ?? '').toString();
    final name = (json['name'] ??
            json['display_name'] ??
            '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim())
        .toString();

    final readAt = AppDateFormatter.parseUtc(json['read_at']);

    return MessageReaderModel(
      id: id,
      name: name.isEmpty ? 'Member' : name,
      companyName:
          json['company_name']?.toString() ?? json['company']?.toString(),
      profilePhotoUrl:
          json['profile_photo_url']?.toString() ?? json['avatar_url']?.toString(),
      readAt: readAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'company_name': companyName,
      'profile_photo_url': profilePhotoUrl,
      'read_at': readAt?.toIso8601String(),
    };
  }
}
