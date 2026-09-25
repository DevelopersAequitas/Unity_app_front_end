import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';

class HomeQuickTabItem {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String? route;
  final String? imageAsset;

  const HomeQuickTabItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.route,
    this.imageAsset,
  });
}

class HomeQuickMainTab {
  final String id;
  final String title;
  final IconData icon;
  final Color accentColor;
  final String? badge;
  final List<HomeQuickTabItem> items;

  const HomeQuickMainTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.accentColor,
    this.badge,
    required this.items,
  });
}

class HomeQuickTabConfig {
  const HomeQuickTabConfig._();

  static const List<HomeQuickMainTab> tabs = [
    HomeQuickMainTab(
      id: 'act',
      title: 'ACT',
      icon: Icons.bolt_rounded,
      accentColor: Color(0xFFE11D48),
      badge: 'Daily',
      items: [
        HomeQuickTabItem(id: 'post_ask', title: 'Post an Ask', icon: Icons.post_add_rounded, color: Color(0xFFE11D48), route: AppRoutes.postAsk),
        HomeQuickTabItem(id: 'open_asks', title: 'Open Asks', icon: Icons.inbox_rounded, color: Color(0xFF7C3AED), route: AppRoutes.openAsks),
        HomeQuickTabItem(id: 'referrals', title: 'Referral', icon: Icons.person_pin_circle_rounded, color: Color(0xFF2563EB), route: AppRoutes.referrals),
        HomeQuickTabItem(id: 'business_deals', title: 'Business Deal', icon: Icons.business_center_rounded, color: Color(0xFF059669), route: AppRoutes.businessDeals),
        HomeQuickTabItem(id: 'p2p_meeting', title: 'P2P Meeting', icon: Icons.groups_rounded, color: Color(0xFF7C3AED), route: AppRoutes.p2pMeetings),
        HomeQuickTabItem(id: 'add_impact', title: 'Add Impact', icon: Icons.volunteer_activism_rounded, color: Color(0xFFF43F5E), route: AppRoutes.lifeImpact),
        HomeQuickTabItem(id: 'testimonials', title: 'Testimonial', icon: Icons.thumb_up_rounded, color: Color(0xFFD97706), route: AppRoutes.testimonials),
        HomeQuickTabItem(id: 'register_visitor', title: 'Register Visitor', icon: Icons.person_add_rounded, color: Color(0xFF10B981), route: AppRoutes.registerVisitor),
      ],
    ),
    HomeQuickMainTab(
      id: 'leaderboard',
      title: 'Leaders',
      icon: Icons.emoji_events_rounded,
      accentColor: Color(0xFFF59E0B),
      badge: 'Rank',
      items: [
        HomeQuickTabItem(id: 'top_community_builders', title: 'Top Community Builders', icon: Icons.emoji_events_rounded, color: Color(0xFFF59E0B), route: AppRoutes.topCommunityBuilders),
        HomeQuickTabItem(id: 'top_impact_creators', title: 'Top Impact Creators', icon: Icons.volunteer_activism_rounded, color: Color(0xFFF43F5E), route: AppRoutes.impactLeaderboard),
        HomeQuickTabItem(id: 'highest_givers', title: 'Highest Givers', icon: Icons.card_giftcard_rounded, color: Color(0xFF10B981), route: AppRoutes.referrals),
        HomeQuickTabItem(id: 'top_contributors', title: 'Top Contributors', icon: Icons.workspace_premium_rounded, color: Color(0xFF8B5CF6), route: AppRoutes.leaderboard),
        HomeQuickTabItem(id: 'impact_score', title: 'My Life Impact Score', icon: Icons.speed_rounded, color: Color(0xFF0284C7), route: AppRoutes.impactScore),
        HomeQuickTabItem(id: 'badges', title: 'My Badges', icon: Icons.stars_rounded, color: Color(0xFFF59E0B), route: AppRoutes.badges),
        HomeQuickTabItem(id: 'coins_wallet', title: 'My Coins', icon: Icons.account_balance_wallet_rounded, color: Color(0xFF10B981), imageAsset: 'assets/images/coin.png', route: AppRoutes.coins),
        HomeQuickTabItem(id: 'claim_coins', title: 'Claim Coins', icon: Icons.monetization_on_rounded, color: Color(0xFFF59E0B), imageAsset: 'assets/images/coin.png', route: AppRoutes.claimCoins),
      ],
    ),
    HomeQuickMainTab(
      id: 'grow',
      title: 'GROW',
      icon: Icons.trending_up_rounded,
      accentColor: Color(0xFF059669),
      badge: 'Lead',
      items: [
        HomeQuickTabItem(id: 'leadership_role', title: 'Leadership Role', icon: Icons.co_present_rounded, color: Color(0xFF9333EA), route: AppRoutes.leadershipRole),
        HomeQuickTabItem(id: 'become_mentor', title: 'Become a Mentor', icon: Icons.workspace_premium_rounded, color: Color(0xFF059669), route: AppRoutes.becomeMentor),
        HomeQuickTabItem(id: 'become_speaker', title: 'Become a Speaker', icon: Icons.mic_rounded, color: Color(0xFFEA580C), route: AppRoutes.becomeSpeaker),
        HomeQuickTabItem(id: 'recommend_peer', title: 'Recommend a Peer', icon: Icons.person_add_alt_1_rounded, color: Color(0xFFEC4899), route: AppRoutes.recommendPeer),
        HomeQuickTabItem(id: 'invite_friends', title: 'Invite Friends', icon: Icons.group_add_rounded, color: Color(0xFF2563EB), route: AppRoutes.myNetwork),
        HomeQuickTabItem(id: 'vyapaar_jagat_story', title: 'Vyapaar Jagat Story', icon: Icons.auto_stories_rounded, color: Color(0xFF0284C7), route: AppRoutes.vyapaarJagatStory),
        HomeQuickTabItem(id: 'leadership_certificate', title: 'Leadership Certificate', icon: Icons.verified_rounded, color: Color(0xFF7C3AED), route: AppRoutes.leadershipCertificate),
        HomeQuickTabItem(id: 'entrepreneur_certificate', title: 'Entrepreneur Certificate', icon: Icons.emoji_events_rounded, color: Color(0xFFF59E0B), route: AppRoutes.leadershipCertificate),
      ],
    ),
    HomeQuickMainTab(
      id: 'events',
      title: 'EVENTS',
      icon: Icons.event_available_rounded,
      accentColor: Color(0xFF3B82F6),
      badge: 'Live',
      items: [
        HomeQuickTabItem(id: 'events', title: 'Events', icon: Icons.event_available_rounded, color: Color(0xFFE11D48), route: AppRoutes.events),
        HomeQuickTabItem(id: 'my_events', title: 'My Events', icon: Icons.confirmation_number_rounded, color: Color(0xFF10B981), route: AppRoutes.myEvents),
        HomeQuickTabItem(id: 'meeting_schedule', title: 'Meeting Schedule', icon: Icons.calendar_month_rounded, color: Color(0xFF7C3AED)),
        HomeQuickTabItem(id: 'circulars', title: 'Circulars', icon: Icons.campaign_rounded, color: Color(0xFFE11D48), route: AppRoutes.circulars),
        HomeQuickTabItem(id: 'gallery', title: 'Gallery', icon: Icons.photo_library_rounded, color: Color(0xFF3B82F6)),
        HomeQuickTabItem(id: 'videos', title: 'Videos', icon: Icons.video_library_rounded, color: Color(0xFFEA580C), route: AppRoutes.eventVideos),
        HomeQuickTabItem(id: 'tutorials', title: 'Tutorials', icon: Icons.school_rounded, color: Color(0xFF059669), route: AppRoutes.tutorials),
        HomeQuickTabItem(id: 'partner_with_us', title: 'Partner with Us', icon: Icons.handshake_rounded, color: Color(0xFF2563EB), route: AppRoutes.partnerWithUs),
      ],
    ),
  ];
}
