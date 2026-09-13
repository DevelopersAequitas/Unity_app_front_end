import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class NotificationBadgeConfig {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final IconData fallbackIcon;

  const NotificationBadgeConfig({
    required this.icon,
    required this.backgroundColor,
    this.iconColor = Colors.white,
    this.fallbackIcon = Icons.notifications_none_rounded,
  });
}

class NotificationTypeHelper {
  NotificationTypeHelper._();

  static NotificationBadgeConfig getBadgeConfig(String type, String category) {
    final t = type.toLowerCase().trim();
    final c = category.toLowerCase().trim();

    if (t.contains('connection_accepted') || c.contains('connection_accepted')) {
      return const NotificationBadgeConfig(
        icon: Icons.check_rounded,
        backgroundColor: Color(0xFF10B981), // Emerald green
        fallbackIcon: Icons.people_outline_rounded,
      );
    }
    if (t.contains('connection_request') || t.contains('request') || c.contains('connection_request')) {
      return const NotificationBadgeConfig(
        icon: Icons.person_add_alt_1_rounded,
        backgroundColor: Color(0xFF2563EB), // Royal blue
        fallbackIcon: Icons.person_add_outlined,
      );
    }
    if (t.contains('profile_view') || c.contains('profile_view') || t.contains('viewed')) {
      return const NotificationBadgeConfig(
        icon: Icons.visibility_rounded,
        backgroundColor: Color(0xFF7C3AED), // Violet
        fallbackIcon: Icons.visibility_outlined,
      );
    }
    if (t.contains('follow') || c.contains('follow')) {
      return const NotificationBadgeConfig(
        icon: Icons.person_add_rounded,
        backgroundColor: Color(0xFF059669), // Green
        fallbackIcon: Icons.person_outline_rounded,
      );
    }
    if (t.contains('new_post') || t.contains('post_created') || c.contains('post')) {
      return const NotificationBadgeConfig(
        icon: Icons.description_rounded,
        backgroundColor: Color(0xFF3B82F6), // Blue
        fallbackIcon: Icons.article_outlined,
      );
    }
    if (t.contains('like') || c.contains('like')) {
      return const NotificationBadgeConfig(
        icon: Icons.favorite_rounded,
        backgroundColor: Color(0xFFE11D48), // Rose pink
        fallbackIcon: Icons.favorite_border_rounded,
      );
    }
    if (t.contains('comment') || c.contains('comment')) {
      return const NotificationBadgeConfig(
        icon: Icons.chat_bubble_rounded,
        backgroundColor: Color(0xFF0284C7), // Sky blue
        fallbackIcon: Icons.chat_bubble_outline_rounded,
      );
    }
    if (t.contains('mention') || c.contains('mention')) {
      return const NotificationBadgeConfig(
        icon: Icons.alternate_email_rounded,
        backgroundColor: Color(0xFF8B5CF6), // Purple
        fallbackIcon: Icons.alternate_email_rounded,
      );
    }
    if (t.contains('announcement') || t.contains('event') || c.contains('announcement')) {
      return const NotificationBadgeConfig(
        icon: Icons.campaign_rounded,
        backgroundColor: Color(0xFFF43F5E), // Coral
        fallbackIcon: Icons.campaign_outlined,
      );
    }

    return const NotificationBadgeConfig(
      icon: Icons.notifications_rounded,
      backgroundColor: AppColor.primaryBlue,
      fallbackIcon: Icons.notifications_none_rounded,
    );
  }

  static String formatTimeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()}w ago';
    return '${date.day} ${_monthName(date.month)}';
  }

  static String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  static String formatGroupDate(DateTime? date) {
    if (date == null) return 'Earlier';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(itemDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return 'Earlier';
  }

  static String formatHeaderDateString(DateTime? date) {
    if (date == null) return '';
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }
}
