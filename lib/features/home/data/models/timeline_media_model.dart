import '../../domain/entities/timeline_media_entity.dart';

class TimelineMediaModel {
  final String url;
  final MediaType type;
  final String? mimeType;
  final String? fileId;
  final int? width;
  final int? height;

  const TimelineMediaModel({
    required this.url,
    this.type = MediaType.image,
    this.mimeType,
    this.fileId,
    this.width,
    this.height,
  });

  factory TimelineMediaModel.fromJson(Map<String, dynamic> json) {
    final rawType = (json['type'] ?? json['media_type'] ?? '').toString().toLowerCase();
    final mimeType = json['mime_type'] as String?;

    MediaType resolvedType;
    if (rawType == 'video' ||
        (mimeType != null && mimeType.startsWith('video/'))) {
      resolvedType = MediaType.video;
    } else if (rawType == 'image' ||
        (mimeType != null && mimeType.startsWith('image/'))) {
      resolvedType = MediaType.image;
    } else {
      // Fallback: sniff from URL extension
      final url = (json['url'] ?? json['file_url'] ?? '').toString().toLowerCase();
      if (url.contains('.mp4') || url.contains('.mov') || url.contains('.m3u8')) {
        resolvedType = MediaType.video;
      } else {
        resolvedType = MediaType.image;
      }
    }

    return TimelineMediaModel(
      url: (json['url'] ?? json['file_url'] ?? json['creative_url'] ?? '').toString(),
      type: resolvedType,
      mimeType: mimeType,
      fileId: (json['file_id'] ?? json['id'])?.toString(),
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  TimelineMediaEntity toEntity() {
    return TimelineMediaEntity(
      url: url,
      type: type,
      mimeType: mimeType,
      fileId: fileId,
      width: width,
      height: height,
    );
  }
}
