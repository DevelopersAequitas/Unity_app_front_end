import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../menu/presentation/screens/activity_summary_screen.dart';
import '../../../menu/presentation/screens/circulars_screen.dart';
import '../../../menu/presentation/screens/event_gallery_screen.dart';
import '../../../menu/presentation/screens/event_videos_screen.dart';
import '../../../menu/presentation/screens/tutorials_screen.dart';
import '../../domain/entities/highlight_section.dart';
import '../bloc/highlights_bloc.dart';
import '../bloc/highlights_event.dart';
import '../bloc/highlights_state.dart';
import '../widgets/highlights_bottom_banner.dart';
import '../widgets/highlights_sections_grid.dart';
import 'become_mentor_screen.dart';
import 'become_speaker_screen.dart';
import 'coins_screen.dart';
import 'entrepreneur_certification_screen.dart';
import 'gratitude_script_screen.dart';
import 'last_month_activity_screen.dart';
import 'leadership_certification_screen.dart';
import 'leadership_role_screen.dart';
import 'life_impact_screen.dart';
import 'my_network_screen.dart';
import 'partner_with_us_screen.dart';
import 'post_ask_screen.dart';
import 'recommend_peer_screen.dart';
import 'top_community_builders_screen.dart';
import 'vyapaar_jagat_story_screen.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<HighlightsBloc>();
    if (bloc.state.status == HighlightsStatus.initial) {
      bloc.add(const HighlightsFetchRequested());
    }
  }

  void _onSectionTap(HighlightSection item) {
    final id = item.id.toLowerCase().trim();

    switch (id) {
      // Core Collaboration Actions
      case 'referral':
      case 'referrals':
        Navigator.pushNamed(context, AppRoutes.referrals);
        break;
      case 'business_deal':
      case 'business_deals':
        Navigator.pushNamed(context, AppRoutes.businessDeals);
        break;
      case 'p2p_meeting':
      case 'p2p_meetings':
      case 'p2p':
      case 'meeting_schedule':
        Navigator.pushNamed(context, AppRoutes.p2pMeetings);
        break;
      case 'testimonial':
      case 'testimonials':
        Navigator.pushNamed(context, AppRoutes.testimonials);
        break;
      case 'post_ask':
      case 'collaboration_ask':
      case 'requirements':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PostAskScreen(initialTabIndex: 0)));
        break;
      case 'open_requirement':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PostAskScreen(initialTabIndex: 1)));
        break;
      case 'collaborations':
      case 'apply_collaboration':
      case 'partner_with_us':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PartnerWithUsScreen()));
        break;
      case 'register_visitor':
      case 'recommend_peer':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const RecommendPeerScreen()));
        break;
      case 'add_impact':
      case 'impact_score':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LifeImpactScreen()));
        break;
      case 'claim_coins':
      case 'badges':
      case 'coins_wallet':
      case 'coins':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CoinsScreen()));
        break;

      // Highlights
      case 'top_community_builders':
      case 'introduced_peers':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TopCommunityBuildersScreen()));
        break;
      case 'events':
      case 'gallery':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const EventGalleryScreen()));
        break;
      case 'invite_friends':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MyNetworkScreen()));
        break;
      case 'gratitude_script':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GratitudeScriptScreen()));
        break;
      case 'last_month_activity':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LastMonthActivityScreen()));
        break;
      case 'circle_chat':
        Navigator.pushNamed(context, AppRoutes.circles);
        break;
      case 'leadership_role':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LeadershipRoleScreen()));
        break;
      case 'become_mentor':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BecomeMentorScreen()));
        break;
      case 'become_speaker':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const BecomeSpeakerScreen()));
        break;
      case 'vyapaar_jagat_story':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const VyapaarJagatStoryScreen()));
        break;
      case 'leadership_certificate':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const LeadershipCertificationScreen()));
        break;
      case 'entrepreneur_certificate':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const EntrepreneurCertificationScreen()));
        break;

      // Menu & More Options
      case 'collaboration_history':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivitySummaryScreen()));
        break;
      case 'circulars':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CircularsScreen()));
        break;
      case 'videos':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const EventVideosScreen()));
        break;
      case 'tutorials':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialsScreen()));
        break;
      case 'welcome_creative':
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
      default:
        AppSnackBar.showInfo(context, '${item.title} section');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HighlightsBloc, HighlightsState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null && prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) AppSnackBar.showError(context, state.errorMessage!);
      },
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async => context.read<HighlightsBloc>().add(const HighlightsRefreshRequested()),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBody(state),
                const SizedBox(height: 16),
                const HighlightsBottomBanner(),
                SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(HighlightsState state) {
    if (state.status == HighlightsStatus.loading && state.allSections.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }
    if (state.status == HighlightsStatus.failure && state.allSections.isEmpty) return _buildErrorState();
    if (state.filteredSections.isEmpty) return _buildEmptySearchState();

    return HighlightsSectionsGrid(sections: state.filteredSections, onSectionTap: _onSectionTap);
  }

  Widget _buildEmptySearchState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 36, color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
            const SizedBox(height: 8),
            Text('No sections found', style: AppTypography.titleMedium.copyWith(color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 36, color: AppColor.error),
            const SizedBox(height: 8),
            Text('Failed to load highlights', style: AppTypography.titleMedium.copyWith(color: AppColor.error)),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.read<HighlightsBloc>().add(const HighlightsFetchRequested()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
