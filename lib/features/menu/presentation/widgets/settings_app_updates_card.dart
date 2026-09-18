import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import 'settings_section_card.dart';
import 'settings_switch_tile.dart';

class SettingsAppUpdatesCard extends StatelessWidget {
  final bool autoUpdateApp;
  final bool allowUpdatesOverAnyNetwork;
  final bool notifyUpdateAvailable;
  final ValueChanged<bool> onAutoUpdateChanged;
  final ValueChanged<bool> onAllowAnyNetworkChanged;
  final ValueChanged<bool> onNotifyUpdateChanged;

  const SettingsAppUpdatesCard({
    super.key,
    required this.autoUpdateApp,
    required this.allowUpdatesOverAnyNetwork,
    required this.notifyUpdateAvailable,
    required this.onAutoUpdateChanged,
    required this.onAllowAnyNetworkChanged,
    required this.onNotifyUpdateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'App Update Settings',
      subtitle: 'Configure automatic app update downloads & network preferences',
      children: [
        SettingsSwitchTile(
          icon: Icons.system_update_alt_outlined,
          title: 'Auto-update Unity App',
          subtitle: 'Automatically download latest feature patches in background',
          value: autoUpdateApp,
          onChanged: onAutoUpdateChanged,
        ),
        const Divider(height: 1, color: AppColor.lightSurfaceSubtle, indent: 64),
        SettingsSwitchTile(
          icon: Icons.wifi_tethering_outlined,
          title: 'Allow Updates Over Any Network',
          subtitle: 'Use mobile data to download updates when Wi-Fi is unavailable',
          value: autoUpdateApp ? allowUpdatesOverAnyNetwork : false,
          onChanged: autoUpdateApp ? onAllowAnyNetworkChanged : null,
        ),
        const Divider(height: 1, color: AppColor.lightSurfaceSubtle, indent: 64),
        SettingsSwitchTile(
          icon: Icons.notifications_active_outlined,
          title: 'Update Available Notifications',
          subtitle: 'Get notified as soon as a new app update is ready to install',
          value: notifyUpdateAvailable,
          onChanged: onNotifyUpdateChanged,
        ),
      ],
    );
  }
}
