import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import 'settings_section_card.dart';
import 'settings_switch_tile.dart';

class SettingsChannelsCard extends StatelessWidget {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool soundEnabled;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onSoundChanged;

  const SettingsChannelsCard({
    super.key,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.soundEnabled,
    required this.onPushChanged,
    required this.onEmailChanged,
    required this.onSoundChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Notification Channels',
      subtitle: 'Manage how and where you receive notifications',
      children: [
        SettingsSwitchTile(
          icon: Icons.notifications_active_outlined,
          title: 'Push Notifications',
          subtitle: 'Receive instant push alerts on your device',
          value: pushEnabled,
          onChanged: onPushChanged,
        ),
        const Divider(height: 1, color: AppColor.lightSurfaceSubtle, indent: 64),
        SettingsSwitchTile(
          icon: Icons.mail_outline_rounded,
          title: 'Email Notifications',
          subtitle: 'Receive summaries and major alerts via email',
          value: emailEnabled,
          onChanged: onEmailChanged,
        ),
        const Divider(height: 1, color: AppColor.lightSurfaceSubtle, indent: 64),
        SettingsSwitchTile(
          icon: Icons.volume_up_outlined,
          title: 'Notification Sound',
          subtitle: 'Play sound effect when in-app alerts arrive',
          value: soundEnabled,
          onChanged: onSoundChanged,
        ),
      ],
    );
  }
}
