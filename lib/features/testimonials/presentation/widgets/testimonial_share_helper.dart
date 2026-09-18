import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/testimonial_entity.dart';

class TestimonialShareHelper {
  TestimonialShareHelper._();

  static Future<void> shareTestimonial({
    required TestimonialEntity testimonial,
    String? currentUserName,
    String tabType = 'received',
  }) async {
    final peerId = testimonial.fromUserId ?? testimonial.toUserId;
    final link = AppEnvironment.getTestimonialDeepLink(
      testimonialId: testimonial.id,
      peerId: peerId,
      tab: tabType,
    );

    final isReceived = tabType.toLowerCase() == 'received';
    final typeLabel =
        isReceived ? 'Received from' : 'Given to';
    final peerName = testimonial.peerName;
    // final rating = testimonial.rating?.round() ?? 5;
    // final ratingStars = '★' * rating;
    final subtitle = testimonial.subtitle;

    final buffer = StringBuffer();
    buffer.writeln('🌟 Testimonial $typeLabel $peerName');
    if (subtitle.isNotEmpty) {
      buffer.writeln('🏢 $subtitle');
    }
    // if (rating > 0) {
    //   buffer.writeln('⭐ Rating: $ratingStars ($rating/5)');
    // }
    buffer.writeln();
    buffer.writeln('“${testimonial.content.trim()}”');
    buffer.writeln();
    if (currentUserName != null && currentUserName.isNotEmpty) {
      buffer.writeln('Shared by $currentUserName on ${AppEnvironment.appName}');
    }
    buffer.writeln('Connect & view on ${AppEnvironment.appName}: $link');

    final text = buffer.toString();
    final subject = 'Testimonial for $peerName on ${AppEnvironment.appName}';

    // Check media
    if (testimonial.media.isEmpty ||
        testimonial.media.first.url == null ||
        testimonial.media.first.url!.isEmpty) {
      SharePlus.instance.share(
        ShareParams(text: text, subject: subject),
      );
      return;
    }

    final mediaUrl = testimonial.media.first.url!;
    try {
      final tempDir = await getTemporaryDirectory();
      final cleanId =
          testimonial.id.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      final fileName = 'testimonial_${cleanId.isNotEmpty ? cleanId : 'media'}.jpg';
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);

      if (!await file.exists()) {
        final dio = Dio();
        await dio.download(
          mediaUrl,
          filePath,
          options: Options(receiveTimeout: const Duration(seconds: 15)),
        );
      }

      if (await file.exists()) {
        SharePlus.instance.share(
          ShareParams(
            files: [XFile(filePath)],
            text: text,
            subject: subject,
          ),
        );
        return;
      }
    } catch (e) {
      debugPrint('[TestimonialShareHelper] Error downloading image: $e');
    }

    // Fallback without image
    SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
  }
}
