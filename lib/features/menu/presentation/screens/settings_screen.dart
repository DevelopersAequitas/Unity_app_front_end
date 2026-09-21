import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/settings/settings_bloc.dart';
import '../bloc/settings/settings_event.dart';
import '../bloc/settings/settings_state.dart';
import '../widgets/settings_app_updates_card.dart';
import '../widgets/settings_categories_card.dart';
import '../widgets/settings_channels_card.dart';
import '../widgets/settings_quiet_hours_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextPrimary,
          ),
        ),
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.lightTextPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading && state.preferences.id == null) {
            return const Center(child: CircularProgressIndicator(color: AppColor.primaryBlue));
          }

          final prefs = state.preferences;
          return RefreshIndicator(
            onRefresh: () async => context.read<SettingsBloc>().add(const FetchSettingsEvent()),
            color: AppColor.primaryBlue,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                SettingsChannelsCard(
                  pushEnabled: prefs.pushEnabled,
                  emailEnabled: prefs.emailEnabled,
                  soundEnabled: prefs.soundEnabled,
                  onPushChanged: (v) => _update(context, prefs.copyWith(pushEnabled: v)),
                  onEmailChanged: (v) => _update(context, prefs.copyWith(emailEnabled: v)),
                  onSoundChanged: (v) => _update(context, prefs.copyWith(soundEnabled: v)),
                ),
                const SizedBox(height: 16),
                SettingsCategoriesCard(
                  chatEnabled: prefs.chatEnabled,
                  circleEnabled: prefs.circleEnabled,
                  businessEnabled: prefs.businessEnabled,
                  eventEnabled: prefs.eventEnabled,
                  campaignEnabled: prefs.campaignEnabled,
                  onChatChanged: (v) => _update(context, prefs.copyWith(chatEnabled: v)),
                  onCircleChanged: (v) => _update(context, prefs.copyWith(circleEnabled: v)),
                  onBusinessChanged: (v) => _update(context, prefs.copyWith(businessEnabled: v)),
                  onEventChanged: (v) => _update(context, prefs.copyWith(eventEnabled: v)),
                  onCampaignChanged: (v) => _update(context, prefs.copyWith(campaignEnabled: v)),
                ),
                const SizedBox(height: 16),
                SettingsQuietHoursCard(
                  quietHoursStart: prefs.quietHoursStart,
                  quietHoursEnd: prefs.quietHoursEnd,
                  onUpdateQuietHours: (start, end) => _update(
                    context,
                    start == null && end == null
                        ? prefs.copyWith(clearQuietHours: true)
                        : prefs.copyWith(quietHoursStart: start, quietHoursEnd: end),
                  ),
                ),
                const SizedBox(height: 16),
                SettingsAppUpdatesCard(
                  autoUpdateApp: prefs.autoUpdateApp,
                  allowUpdatesOverAnyNetwork: prefs.allowAnyNetwork,
                  notifyUpdateAvailable: prefs.notifyUpdateAvailable,
                  onAutoUpdateChanged: (v) => _update(context, prefs.copyWith(autoUpdateApp: v)),
                  onAllowAnyNetworkChanged: (v) => _update(context, prefs.copyWith(allowAnyNetwork: v)),
                  onNotifyUpdateChanged: (v) => _update(context, prefs.copyWith(notifyUpdateAvailable: v)),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _update(BuildContext context, dynamic updatedPrefs) {
    context.read<SettingsBloc>().add(UpdateSettingsEvent(updatedPrefs));
  }
}
