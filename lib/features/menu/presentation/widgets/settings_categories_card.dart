import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import 'settings_section_card.dart';
import 'settings_switch_tile.dart';

class SettingsCategoriesCard extends StatelessWidget {
  final bool chatEnabled;
  final bool circleEnabled;
  final bool businessEnabled;
  final bool eventEnabled;
  final bool campaignEnabled;
  final ValueChanged<bool> onChatChanged;
  final ValueChanged<bool> onCircleChanged;
  final ValueChanged<bool> onBusinessChanged;
  final ValueChanged<bool> onEventChanged;
  final ValueChanged<bool> onCampaignChanged;

  const SettingsCategoriesCard({
    super.key,
    required this.chatEnabled,
    required this.circleEnabled,
    required this.businessEnabled,
    required this.eventEnabled,
    required this.campaignEnabled,
    required this.onChatChanged,
    required this.onCircleChanged,
    required this.onBusinessChanged,
    required this.onEventChanged,
    required this.onCampaignChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Alert Categories',
      subtitle: 'Customize which specific network activities notify you',
      children: [
        SettingsSwitchTile(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'Chat & Direct Messages',
          subtitle: 'Alerts for one-on-one peer chats and messages',
          value: chatEnabled,
          onChanged: onChatChanged,
        ),
        const Divider(height: 1, color: AppColor.lightSurfaceSubtle, indent: 64),
        SettingsSwitchTile(
          icon: Icons.hub_outlined,
          title: 'Circles & Chapter Updates',
          subtitle: 'Notifications for circle activities & join requests',
          value: circleEnabled,
          onChanged: onCircleChanged,
        ),
        const Divider(height: 1, color: AppColor.lightSurfaceSubtle, indent: 64),
        SettingsSwitchTile(
          icon: Icons.handshake_outlined,
          title: 'Business Deals & Referrals',
          subtitle: 'Alerts for incoming referrals & business slips',
          value: businessEnabled,
          onChanged: onBusinessChanged,
        ),
        const Divider(height: 1, color: AppColor.lightSurfaceSubtle, indent: 64),
        SettingsSwitchTile(
          icon: Icons.event_available_outlined,
          title: 'Events & Meetups',
          subtitle: 'Reminders and updates for upcoming networking events',
          value: eventEnabled,
          onChanged: onEventChanged,
        ),
        const Divider(height: 1, color: AppColor.lightSurfaceSubtle, indent: 64),
        SettingsSwitchTile(
          icon: Icons.campaign_outlined,
          title: 'Announcements & Spotlights',
          subtitle: 'Community updates and member spotlights',
          value: campaignEnabled,
          onChanged: onCampaignChanged,
        ),
      ],
    );
  }
}
