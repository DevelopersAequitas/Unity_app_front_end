import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../p2p_meetings/presentation/screens/p2p_meetings_screen.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';
import '../widgets/menu_header_card.dart';
import '../widgets/menu_item_tile.dart';
import '../widgets/menu_section_card.dart';
import '../widgets/menu_social_section.dart';
import '../widgets/menu_logout_dialog.dart';
import 'activity_summary_screen.dart';
import 'blocked_users_screen.dart';
import 'circulars_screen.dart';
import 'event_gallery_screen.dart';
import 'event_videos_screen.dart';
import 'feedback_screen.dart';
import 'invoice_list_screen.dart';
import 'settings_screen.dart';
import 'submit_ticket_screen.dart';
import 'tutorials_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(const MenuFetchSummaryRequested());
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  Future<void> _handleLogout() async {
    final confirmed = await MenuLogoutDialog.show(context);
    if (confirmed == true && mounted) {
      context.read<AuthBloc>().add(const AuthResetState());
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _shareApp() {
    SharePlus.instance.share(
      ShareParams(
        text: 'Join Peers Global Unity — the premier entrepreneur collaboration network! https://peersglobal.com',
        subject: 'Peers Global Unity',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text('Menu', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary)),
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.lightTextPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, menuState) {
          final s = menuState.summary;
          return RefreshIndicator(
            onRefresh: () async => context.read<MenuBloc>().add(const MenuRefreshSummaryRequested()),
            color: AppColor.primaryBlue,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) => MenuHeaderCard(profile: profileState.profile),
                ),
                const SizedBox(height: 24),
                MenuSectionCard(
                  title: 'COMMUNITY & EVENTS',
                  children: [
                    MenuItemTile(icon: Icons.campaign_outlined, title: 'Circulars & Notices', iconColor: AppColor.primaryBlue, badgeCount: s.unreadCircularsCount, onTap: () => _navigateTo(const CircularsScreen())),
                    MenuItemTile(icon: Icons.photo_library_outlined, title: 'Event Gallery', iconColor: AppColor.primaryPink, onTap: () => _navigateTo(const EventGalleryScreen())),
                    MenuItemTile(icon: Icons.play_circle_outline_rounded, title: 'Event Videos', iconColor: AppColor.primaryBlue, onTap: () => _navigateTo(const EventVideosScreen())),
                    MenuItemTile(icon: Icons.school_outlined, title: 'Tutorials & Guides', iconColor: AppColor.primaryPink, onTap: () => _navigateTo(const TutorialsScreen())),
                  ],
                ),
                const SizedBox(height: 24),
                MenuSectionCard(
                  title: 'ACTIVITIES & BILLING',
                  children: [
                    MenuItemTile(icon: Icons.calendar_today_outlined, title: '1-to-1 Meeting Schedule', iconColor: AppColor.primaryBlue, badgeCount: s.meetingRequestsCount, onTap: () => _navigateTo(const P2pMeetingsScreen())),
                    MenuItemTile(icon: Icons.analytics_outlined, title: 'Activity Summary', iconColor: AppColor.primaryPink, onTap: () => _navigateTo(const ActivitySummaryScreen())),
                    MenuItemTile(icon: Icons.receipt_outlined, title: 'Invoices & Receipts', iconColor: AppColor.primaryBlue, onTap: () => _navigateTo(const InvoiceListScreen())),
                    MenuItemTile(icon: Icons.person_off_outlined, title: 'Blocked Users', iconColor: AppColor.lightTextSecondary, onTap: () => _navigateTo(const BlockedUsersScreen())),
                  ],
                ),
                const SizedBox(height: 24),
                MenuSectionCard(
                  title: 'APP & PREFERENCES',
                  children: [
                    MenuItemTile(icon: Icons.share_outlined, title: 'Share App', iconColor: AppColor.primaryBlue, onTap: _shareApp),
                    MenuItemTile(icon: Icons.settings_outlined, title: 'Settings', iconColor: AppColor.lightTextSecondary, onTap: () => _navigateTo(const SettingsScreen())),
                    MenuItemTile(icon: Icons.rate_review_outlined, title: 'Submit Feedback', iconColor: AppColor.primaryPink, onTap: () => _navigateTo(const FeedbackScreen())),
                    MenuItemTile(icon: Icons.help_outline_rounded, title: 'Help & Support', iconColor: AppColor.primaryBlue, onTap: () => _navigateTo(const SubmitTicketScreen())),
                    MenuItemTile(icon: Icons.logout_rounded, title: 'Logout', iconColor: AppColor.error, textColor: AppColor.error, onTap: _handleLogout),
                  ],
                ),
                const SizedBox(height: 32),
                const MenuSocialSection(),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

