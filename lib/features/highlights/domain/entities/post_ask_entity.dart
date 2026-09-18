import 'package:equatable/equatable.dart';

class PostAskEntity extends Equatable {
  final String id;
  final String subject;
  final String description;
  final String category;
  final String regionLabel;
  final String cityName;
  final String? mediaId;
  final String? mediaUrl;
  final String status;
  final DateTime? createdAt;
  final String? authorName;
  final String? authorAvatar;

  const PostAskEntity({
    this.id = '',
    required this.subject,
    required this.description,
    required this.category,
    this.regionLabel = 'All India',
    this.cityName = '',
    this.mediaId,
    this.mediaUrl,
    this.status = 'open',
    this.createdAt,
    this.authorName,
    this.authorAvatar,
  });

  bool get isOpen => status.toLowerCase() == 'open';
  bool get isCompleted => status.toLowerCase() == 'completed' || status.toLowerCase() == 'closed';

  @override
  List<Object?> get props => [
        id,
        subject,
        description,
        category,
        regionLabel,
        cityName,
        mediaId,
        mediaUrl,
        status,
        createdAt,
        authorName,
        authorAvatar,
      ];
}
