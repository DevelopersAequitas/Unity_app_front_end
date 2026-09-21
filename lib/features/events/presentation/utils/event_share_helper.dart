import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/event_entity.dart';

class EventShareHelper {
  EventShareHelper._();

  static Future<void> shareEvent(EventEntity event) async {
    final link = AppEnvironment.getEventDeepLink(
      event.eventId,
      occurrenceId: event.occurrenceId,
    );

    final title = event.title.trim();
    final circleName = event.circle?.name ?? event.organizerName;

    // Date & Time
    final dateStr = (event.displayDate != null && event.displayDate!.isNotEmpty)
        ? event.displayDate!
        : (event.startAt != null ? AppDateFormatter.format(event.startAt) : '');
    final timeStr = (event.displayTime != null && event.displayTime!.isNotEmpty)
        ? event.displayTime!
        : (event.startAt != null ? AppDateFormatter.formatTime(event.startAt) : '');

    final buffer = StringBuffer();
    buffer.writeln('📅 $title');
    if (circleName != null && circleName.trim().isNotEmpty) {
      buffer.writeln('🏛️ Organized by: ${circleName.trim()}');
    }
    buffer.writeln();

    if (dateStr.isNotEmpty) {
      buffer.writeln('🗓️ Date: $dateStr');
    }
    if (timeStr.isNotEmpty) {
      buffer.writeln('⏰ Time: $timeStr');
    }
    if (event.location != null && event.location!.trim().isNotEmpty) {
      buffer.writeln('📍 Location: ${event.location!.trim()}');
    } else if (event.isInPerson) {
      buffer.writeln('📍 Mode: In-Person');
    } else if (event.mode.isNotEmpty) {
      buffer.writeln('🌐 Mode: Online Meeting');
    }

    if (event.ticketPrice != null && event.ticketPrice!.isNotEmpty) {
      final isFree = event.ticketPrice == '0' || event.ticketPrice == '0.00';
      buffer.writeln('🎟️ Ticket: ${isFree ? 'Free Entry' : '₹${event.ticketPrice}'}');
    }

    // Key Takeaways / What you'll gain
    if (event.whatYoullGain.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('✨ Key Takeaways:');
      for (final gain in event.whatYoullGain.take(3)) {
        buffer.writeln('• $gain');
      }
    } else if (event.description.trim().isNotEmpty) {
      buffer.writeln();
      final cleanDesc = event.description.replaceAll(RegExp(r'<[^>]*>'), '').trim();
      final snippet = cleanDesc.length > 150 ? '${cleanDesc.substring(0, 150)}...' : cleanDesc;
      buffer.writeln('📝 $snippet');
    }

    buffer.writeln();
    buffer.writeln('👉 View full event details & register on ${AppEnvironment.appName}:');
    buffer.writeln(link);

    final text = buffer.toString().trim();
    final subject = '$title on ${AppEnvironment.appName}';

    // Check if event has an image
    final imageUrl = event.imageUrl;
    if (imageUrl != null && imageUrl.trim().isNotEmpty) {
      try {
        final tempDir = await getTemporaryDirectory();
        final safeName = (event.eventId.isNotEmpty ? event.eventId : 'event')
            .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
        final filePath = '${tempDir.path}/event_$safeName.jpg';
        final file = File(filePath);

        if (!await file.exists()) {
          final dio = Dio();
          await dio.download(
            imageUrl.trim(),
            filePath,
            options: Options(receiveTimeout: const Duration(seconds: 15)),
          );
        }

        if (await file.exists()) {
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(filePath)],
              text: text,
              subject: subject,
            ),
          );
          return;
        }
      } catch (e) {
        debugPrint('[EventShareHelper] Error downloading image for share: $e');
      }
    }

    // Fallback without image
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
      ),
    );
  }
}
