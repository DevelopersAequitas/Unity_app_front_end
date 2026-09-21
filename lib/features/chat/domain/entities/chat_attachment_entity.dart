import 'package:equatable/equatable.dart';

class ChatAttachmentEntity extends Equatable {
  final String id;
  final String url;
  final String fileType; // 'image', 'video', 'file', 'audio'
  final String? fileName;
  final int? fileSize;
  final String? thumbnailUrl;

  const ChatAttachmentEntity({
    required this.id,
    required this.url,
    required this.fileType,
    this.fileName,
    this.fileSize,
    this.thumbnailUrl,
  });

  bool get isImage =>
      fileType == 'image' ||
      url.endsWith('.png') ||
      url.endsWith('.jpg') ||
      url.endsWith('.jpeg') ||
      url.endsWith('.webp');

  bool get isVideo =>
      fileType == 'video' || url.endsWith('.mp4') || url.endsWith('.mov');

  bool get isAudio =>
      fileType == 'audio' ||
      url.endsWith('.m4a') ||
      url.endsWith('.mp3') ||
      url.endsWith('.aac') ||
      url.endsWith('.wav') ||
      url.endsWith('.ogg');

  @override
  List<Object?> get props => [
        id,
        url,
        fileType,
        fileName,
        fileSize,
        thumbnailUrl,
      ];
}
