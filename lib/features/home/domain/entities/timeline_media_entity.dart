import 'package:equatable/equatable.dart';

enum MediaType { image, video, unknown }

class TimelineMediaEntity extends Equatable {
  final String url;
  final MediaType type;
  final String? mimeType;
  final String? fileId;
  final int? width;
  final int? height;

  const TimelineMediaEntity({
    required this.url,
    this.type = MediaType.image,
    this.mimeType,
    this.fileId,
    this.width,
    this.height,
  });

  bool get isVideo => type == MediaType.video;

  @override
  List<Object?> get props => [url, type, mimeType, fileId, width, height];
}
