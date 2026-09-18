import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import 'settings_section_card.dart';
import 'settings_switch_tile.dart';

class SettingsQuietHoursCard extends StatelessWidget {
  final String? quietHoursStart;
  final String? quietHoursEnd;
  final void Function(String? start, String? end) onUpdateQuietHours;

  const SettingsQuietHoursCard({
    super.key,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.onUpdateQuietHours,
  });

  bool get _isEnabled => quietHoursStart != null && quietHoursEnd != null;

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final currentStr = isStart ? (quietHoursStart ?? '22:00') : (quietHoursEnd ?? '07:00');
    final parts = currentStr.split(':');
    final initialTime = TimeOfDay(
      hour: int.tryParse(parts.first) ?? (isStart ? 22 : 7),
      minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      if (isStart) {
        onUpdateQuietHours(formatted, quietHoursEnd ?? '07:00');
      } else {
        onUpdateQuietHours(quietHoursStart ?? '22:00', formatted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSectionCard(
      title: 'Quiet Hours (Do Not Disturb)',
      subtitle: 'Automatically mute notifications during scheduled hours',
      children: [
        SettingsSwitchTile(
          icon: Icons.nightlight_round,
          title: 'Enable Quiet Hours',
          subtitle: _isEnabled ? 'Active — notifications muted during set hours' : 'Disabled — receive notifications at all times',
          value: _isEnabled,
          onChanged: (val) {
            if (val) {
              onUpdateQuietHours('22:00', '07:00');
            } else {
              onUpdateQuietHours(null, null);
            }
          },
        ),
        if (_isEnabled)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildTimeChip(
                    context,
                    label: 'From (Start)',
                    time: quietHoursStart ?? '22:00',
                    onTap: () => _pickTime(context, true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeChip(
                    context,
                    label: 'To (End)',
                    time: quietHoursEnd ?? '07:00',
                    onTap: () => _pickTime(context, false),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTimeChip(BuildContext context, {required String label, required String time, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.lightSurfaceSubtle,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 16, color: AppColor.primaryBlue),
                const SizedBox(width: 6),
                Text(time, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
