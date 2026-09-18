import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/referral_entity.dart';

class ReferralShareHelper {
  ReferralShareHelper._();

  static Future<void> shareReferral({
    required ReferralEntity referral,
    String? currentUserName,
    String tabType = 'received',
  }) async {
    final peerId = referral.fromUserId ?? referral.toUserId;
    final link = AppEnvironment.getReferralDeepLink(
      referralId: referral.id,
      peerId: peerId,
      tab: tabType,
    );

    final isReceived = tabType.toLowerCase() == 'received';
    final typeLabel = isReceived ? 'Received from' : 'Given to';
    final peerName = referral.peerName;
    final subtitle = referral.subtitle;
    final flameHotness = '🔥' * referral.hotValue;

    final buffer = StringBuffer();
    buffer.writeln('🎯 Business Referral $typeLabel $peerName');
    buffer.writeln('🏢 Referral For: ${referral.referralOf} (${referral.referralTypeLabel})');
    buffer.writeln('🔥 Hotness: $flameHotness (${referral.hotValue}/5)');
    buffer.writeln('📌 Status: ${referral.statusName}');
    if (referral.referralDate.isNotEmpty) {
      buffer.writeln('📅 Date: ${referral.referralDate}');
    }
    if (referral.phone != null && referral.phone!.trim().isNotEmpty) {
      buffer.writeln('📞 Phone: ${referral.phone!.trim()}');
    }
    if (referral.email != null && referral.email!.trim().isNotEmpty) {
      buffer.writeln('✉️ Email: ${referral.email!.trim()}');
    }
    if (referral.address != null && referral.address!.trim().isNotEmpty) {
      buffer.writeln('📍 Address: ${referral.address!.trim()}');
    }
    if (subtitle.isNotEmpty) {
      buffer.writeln('👤 Peer: $subtitle');
    }
    if (referral.remarks != null && referral.remarks!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('“${referral.remarks!.trim()}”');
    }
    buffer.writeln();
    if (currentUserName != null && currentUserName.isNotEmpty) {
      buffer.writeln('Shared by $currentUserName on ${AppEnvironment.appName}');
    }
    buffer.writeln('Connect & view on ${AppEnvironment.appName}: $link');

    final text = buffer.toString();
    final subject =
        'Business Referral (${referral.referralOf}) with $peerName on ${AppEnvironment.appName}';

    SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
  }
}
