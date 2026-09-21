import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/chat_attachment_entity.dart';

class ChatAttachmentModel extends ChatAttachmentEntity {
  const ChatAttachmentModel({
    required super.id,
    required super.url,
    required super.fileType,
    super.fileName,
    super.fileSize,
    super.thumbnailUrl,
  });

  factory ChatAttachmentModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['file_id'] ?? '').toString();
    var rawUrl = (json['url'] ?? json['file_url'] ?? json['path'] ?? '').toString().trim();

    // Detect local Android/iOS file paths — keep as-is for Image.file() rendering
    final isLocalPath = rawUrl.isNotEmpty &&
        !rawUrl.startsWith('http') &&
        (rawUrl.startsWith('/data/') ||
            rawUrl.startsWith('/storage/') ||
            rawUrl.startsWith('/var/') ||
            rawUrl.startsWith('/private/') ||
            (rawUrl.length > 2 && rawUrl[1] == ':')); // Windows C:\...

    if (rawUrl.isEmpty && id.isNotEmpty) {
      rawUrl = '${AppEnvironment.baseUrl}/files/$id';
    } else if (!isLocalPath && rawUrl.startsWith('/')) {
      rawUrl = '${AppEnvironment.baseUrl}$rawUrl';
    } else if (!isLocalPath && rawUrl.isNotEmpty && !rawUrl.startsWith('http')) {
      rawUrl = '${AppEnvironment.baseUrl}/files/$rawUrl';
    }

    // Prefer mime_type from upload response (e.g. "image/webp", "video/mp4")
    final mimeType = (json['mime_type'] ?? '').toString().toLowerCase();
    final rawType = (json['file_type'] ?? json['type'] ?? mimeType).toString().toLowerCase();
    final urlLower = rawUrl.toLowerCase();
    String detectedType = 'file';

    if (mimeType.startsWith('image/') ||
        rawType.contains('image') ||
        urlLower.contains('.jpg') ||
        urlLower.contains('.jpeg') ||
        urlLower.contains('.png') ||
        urlLower.contains('.webp') ||
        urlLower.contains('.gif')) {
      detectedType = 'image';
    } else if (mimeType.startsWith('audio/') ||
        rawType.contains('audio') ||
        rawType.contains('voice') ||
        urlLower.contains('.m4a') ||
        urlLower.contains('.mp3') ||
        urlLower.contains('.aac') ||
        urlLower.contains('.wav') ||
        urlLower.contains('.ogg')) {
      detectedType = 'audio';
    } else if (mimeType.startsWith('video/') ||
        rawType.contains('video') ||
        urlLower.contains('.mp4') ||
        urlLower.contains('.mov') ||
        urlLower.contains('.avi') ||
        urlLower.contains('.mkv')) {
      detectedType = 'video';
    }

    return ChatAttachmentModel(
      id: id.isNotEmpty ? id : (rawUrl.isNotEmpty ? rawUrl : 'att'),
      url: rawUrl,
      fileType: detectedType,
      fileName: json['file_name']?.toString() ?? json['name']?.toString(),
      fileSize: json['file_size'] is int
          ? json['file_size'] as int
          : (json['size_bytes'] is int
              ? json['size_bytes'] as int
              : int.tryParse(
                  (json['file_size'] ?? json['size_bytes'])?.toString() ?? '')),
      thumbnailUrl:
          json['thumbnail_url']?.toString() ?? json['thumb']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'file_type': fileType,
      'file_name': fileName,
      'file_size': fileSize,
      'thumbnail_url': thumbnailUrl,
    };
  }
}
