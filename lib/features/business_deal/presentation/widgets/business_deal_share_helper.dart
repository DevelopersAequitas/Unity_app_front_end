import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../domain/entities/business_deal_entity.dart';

class BusinessDealShareHelper {
  BusinessDealShareHelper._();

  static String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} Lakh';
    } else if (amount >= 1000) {
      return '₹${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))'), (m) => '${m[1]},')}';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  static Future<void> shareBusinessDeal({
    required BusinessDealEntity deal,
    String? currentUserName,
    String tabType = 'received',
  }) async {
    final peerId = deal.fromUserId ?? deal.toUserId;
    final link = AppEnvironment.getBusinessDealDeepLink(
      dealId: deal.id,
      peerId: peerId,
      tab: tabType,
    );

    final isReceived = tabType.toLowerCase() == 'received';
    final typeLabel = isReceived ? 'Received from' : 'Given to';
    final peerName = deal.peerName;
    final subtitle = deal.subtitle;
    final formattedAmount = _formatAmount(deal.dealAmount);

    final buffer = StringBuffer();
    buffer.writeln('🤝 Business Deal $typeLabel $peerName');
    buffer.writeln('💰 Amount: $formattedAmount (${deal.businessTypeLabel})');
    if (deal.dealDate.isNotEmpty) {
      buffer.writeln('📅 Date: ${deal.dealDate}');
    }
    if (subtitle.isNotEmpty) {
      buffer.writeln('🏢 $subtitle');
    }
    if (deal.comment != null && deal.comment!.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln('“${deal.comment!.trim()}”');
    }
    buffer.writeln();
    if (currentUserName != null && currentUserName.isNotEmpty) {
      buffer.writeln('Shared by $currentUserName on ${AppEnvironment.appName}');
    }
    buffer.writeln('Connect & view on ${AppEnvironment.appName}: $link');

    final text = buffer.toString();
    final subject =
        'Business Deal ($formattedAmount) with $peerName on ${AppEnvironment.appName}';

    SharePlus.instance.share(
      ShareParams(text: text, subject: subject),
    );
  }
}
