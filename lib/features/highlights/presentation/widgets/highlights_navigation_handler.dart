import 'package:flutter/material.dart';
import 'package:unity_app/features/business_deal/presentation/bloc/business_deals_event.dart';
import 'package:unity_app/features/leaderboard/presentation/bloc/leaderboard_event.dart';
import 'package:unity_app/features/referrals/presentation/bloc/referrals_event.dart';
import 'package:unity_app/features/testimonials/presentation/bloc/testimonials_event.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../business_deal/presentation/screens/business_deals_screen.dart';

import '../../../leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../../p2p_meetings/presentation/screens/p2p_meetings_screen.dart';
import '../../../referrals/presentation/screens/referrals_screen.dart';
import '../../../testimonials/presentation/screens/testimonials_screen.dart';
import '../../../menu/presentation/screens/circulars_screen.dart';
import '../../../menu/presentation/screens/event_gallery_screen.dart';
import '../../../menu/presentation/screens/event_videos_screen.dart';
import '../../../menu/presentation/screens/tutorials_screen.dart';
import '../../domain/entities/highlight_section.dart';
import '../screens/ask_form_screen.dart';
import '../screens/become_mentor_screen.dart';
import '../screens/become_speaker_screen.dart';
import '../screens/coins_screen.dart';
import '../screens/claim_your_coin_screen.dart';
import '../../../milestones/presentation/screens/coin_milestones_screen.dart';
import '../screens/entrepreneur_certification_screen.dart';
import '../screens/gratitude_script_screen.dart';
import '../screens/last_month_activity_screen.dart';
import '../screens/leadership_certification_screen.dart';
import '../screens/leadership_role_screen.dart';
import '../screens/life_impact_screen.dart';
import '../screens/my_network_screen.dart';
import '../screens/recommend_peer_screen.dart';
import '../screens/recommend_peer_history_screen.dart';
import '../screens/register_visitor_screen.dart';
import '../screens/top_community_builders_screen.dart';
import '../screens/partner_with_us_screen.dart';
import '../screens/vyapaar_jagat_story_screen.dart';
import '../screens/welcome_creative_template_screen.dart';
import '../../../asks/presentation/screens/peers_asks_hub_screen.dart';

class HighlightsNavigationHandler {
  const HighlightsNavigationHandler._();

  static void handleTap(BuildContext context, HighlightSection item) {
    final id = item.id.toLowerCase().trim();

    switch (id) {
      case 'asks_collaboration':
      case 'collaboration_asks':
      case 'collaborations':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PeersAsksHubScreen(
              flowCode: 'collaboration',
              flowTitle: 'Collaboration Asks',
            ),
          ),
        );
        break;
      case 'asks_referral':
      case 'referral_asks':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PeersAsksHubScreen(
              flowCode: 'referral',
              flowTitle: 'Referral Asks',
            ),
          ),
        );
        break;
      case 'asks_help':
      case 'help_asks':
      case 'get_help':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PeersAsksHubScreen(
              flowCode: 'help',
              flowTitle: 'Get Help Asks',
            ),
          ),
        );
        break;
      case 'bookmarks':
      case 'bookmarked_peers':
      case 'bookmark':
        Navigator.pushNamed(context, AppRoutes.bookmarkedPeers);
        break;
      case 'intro_videos':
      case 'intro_video':
      case 'shorts':
      case 'peer_videos':
        Navigator.pushNamed(context, AppRoutes.shorts);
        break;
      case 'business_deals_leaderboard':
      case 'business_deal_leaderboard':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BusinessDealsScreen(
              initialTab: BusinessDealTab.leaderboard,
            ),
          ),
        );
        break;
      case 'p2p_meetings_leaderboard':
      case 'p2p_meeting_leaderboard':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const P2pMeetingsScreen(initialTabIndex: 0),
          ),
        );
        break;
      case 'testimonials_leaderboard':
      case 'testimonial_leaderboard':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TestimonialsScreen(
              initialTab: TestimonialTab.leaderboard,
            ),
          ),
        );
        break;
      case 'referrals_leaderboard':
      case 'referral_leaderboard':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ReferralsScreen(
              initialTab: ReferralTab.leaderboard,
            ),
          ),
        );
        break;
      case 'impact_leaderboard':
      case 'life_impact_leaderboard':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LeaderboardScreen(
              type: LeaderboardType.impact,
            ),
          ),
        );
        break;
      case 'coins_leaderboard':
      case 'coin_leaderboard':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LeaderboardScreen(
              type: LeaderboardType.coins,
            ),
          ),
        );
        break;
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
      case 'collaboration_ask':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AskFormScreen()),
        );
        break;
      case 'post_ask':
      case 'post_requirement':
      case 'add_ask':
        Navigator.pushNamed(context, AppRoutes.askBrief);
        break;
      case 'open_asks':
      case 'open_ask':
      case 'open_requirement':
      case 'open_requirements':
      case 'requirements':
      case 'peers_feed':
        Navigator.pushNamed(context, AppRoutes.peersFeed);
        break;
      case 'my_asks':
      case 'my_requirements':
        Navigator.pushNamed(context, AppRoutes.myAsks);
        break;
      case 'apply_collaboration':
      case 'post_collaboration':
      case 'add_collaboration':
        Navigator.pushNamed(context, AppRoutes.postAsk);
        break;
      case 'open_collaboration':
      case 'collaboration_opportunities':
        Navigator.pushNamed(context, AppRoutes.peersFeed, arguments: 0);
        break;
      case 'register_visitor':
      case 'register_a_visitor':
      case 'visitor_registration':
      case 'visitor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegisterVisitorScreen()),
        );
        break;
      case 'recommend_peer':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecommendPeerScreen()),
        );
        break;
      case 'recommend_peer_history':
      case 'recommend_history':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecommendPeerHistoryScreen()),
        );
        break;
      case 'add_impact':
      case 'impact_score':
      case 'my_impact_score':
      case 'life_impact':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LifeImpactScreen(
              initialTabIndex: id == 'add_impact' ? 1 : 0,
            ),
          ),
        );
        break;
      case 'claim_coins':
      case 'claim_your_coin':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClaimYourCoinScreen()),
        );
        break;
      case 'badges':
      case 'my_badges':
      case 'milestones':
      case 'coin_milestones':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CoinMilestonesScreen()),
        );
        break;
      case 'coins_wallet':
      case 'coins':
      case 'my_coins':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CoinsScreen()),
        );
        break;
      case 'top_community_builders':
      case 'introduced_peers':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TopCommunityBuildersScreen()),
        );
        break;
      case 'events':
      case 'event':
      case 'upcoming_events':
      case 'all_events':
        Navigator.pushNamed(context, AppRoutes.events);
        break;
      case 'my_events':
        Navigator.pushNamed(context, AppRoutes.myEvents);
        break;
      case 'gallery':
      case 'event_gallery':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EventGalleryScreen()),
        );
        break;
      case 'invite_friends':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyNetworkScreen()),
        );
        break;
      case 'gratitude_script':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GratitudeScriptScreen()),
        );
        break;
      case 'last_month_activity':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LastMonthActivityScreen()),
        );
        break;
      case 'circle_chat':
        Navigator.pushNamed(context, AppRoutes.circles);
        break;
      case 'leadership_role':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LeadershipRoleScreen()),
        );
        break;
      case 'become_mentor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BecomeMentorScreen()),
        );
        break;
      case 'become_speaker':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BecomeSpeakerScreen()),
        );
        break;
      case 'partner_with_us':
      case 'partner':
      case 'partner_with':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PartnerWithUsScreen()),
        );
        break;
      case 'vyapaar_jagat_story':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VyapaarJagatStoryScreen()),
        );
        break;
      case 'leadership_certificate':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LeadershipCertificationScreen(),
          ),
        );
        break;
      case 'entrepreneur_certificate':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EntrepreneurCertificationScreen(),
          ),
        );
        break;
      case 'collaboration_history':
        Navigator.pushNamed(context, AppRoutes.myAsks, arguments: 1);
        break;
      case 'circulars':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CircularsScreen()),
        );
        break;
      case 'videos':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EventVideosScreen()),
        );
        break;
      case 'tutorials':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TutorialsScreen()),
        );
        break;
      case 'welcome_creative':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WelcomeCreativeTemplateScreen(),
          ),
        );
        break;
      default:
        AppSnackBar.showInfo(context, '${item.title} section');
        break;
    }
  }
}
