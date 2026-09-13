import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_environment.dart';
import '../../features/home/domain/entities/timeline_item_entity.dart';

class PostShareHelper {
  PostShareHelper._();

  static Future<void> sharePost(TimelineItemEntity item) async {
    final link = AppEnvironment.getPostDeepLink(item.id);
    final content = item.contentText.isNotEmpty
        ? (item.contentText.length > 120
            ? '${item.contentText.substring(0, 120)}...'
            : item.contentText)
        : '';
    final text = content.isNotEmpty
        ? '$content\n\nCheck out this update on ${AppEnvironment.appName}: $link'
        : 'Check out this update on ${AppEnvironment.appName}: $link';

    if (item.media.isEmpty) {
      SharePlus.instance.share(
        ShareParams(text: text, subject: 'Post on ${AppEnvironment.appName}'),
      );
      return;
    }

    // Has media (image or video)
    final media = item.media.first;
    final mediaUrl = media.url;
    if (mediaUrl.isEmpty) {
      SharePlus.instance.share(
        ShareParams(text: text, subject: 'Post on ${AppEnvironment.appName}'),
      );
      return;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final isVideo = media.isVideo || mediaUrl.endsWith('.mp4') || mediaUrl.contains('/video');
      final ext = isVideo ? 'mp4' : 'jpg';
      final fileName = 'share_${item.id.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '')}.$ext';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);

      if (!await file.exists()) {
        final dio = Dio();
        await dio.download(
          mediaUrl,
          filePath,
          options: Options(receiveTimeout: const Duration(seconds: 20)),
        );
      }

      if (await file.exists()) {
        SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            text: text,
            subject: 'Post on ${AppEnvironment.appName}',
          ),
        );
        return;
      }
    } catch (e) {
      debugPrint('[PostShareHelper] Error sharing media file: $e');
    }

    // Fallback to text link
    SharePlus.instance.share(
      ShareParams(text: text, subject: 'Post on ${AppEnvironment.appName}'),
    );
  }
}
