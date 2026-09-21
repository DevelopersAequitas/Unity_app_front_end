import 'package:flutter/material.dart';
import '../models/highlight_section_model.dart';

abstract class HighlightsLocalDataSource {
  Future<List<HighlightSectionModel>> getHighlightSections();
}

class HighlightsLocalDataSourceImpl implements HighlightsLocalDataSource {
  @override
  Future<List<HighlightSectionModel>> getHighlightSections() async {
    return const [
      // Category 1: Highlights
      HighlightSectionModel(
        id: 'top_community_builders',
        title: 'Top Community Builders',
        category: 'Highlights',
        icon: Icons.emoji_events_rounded,
        accentColor: Color(0xFFF59E0B),
      ),
      HighlightSectionModel(
        id: 'events',
        title: 'Events',
        category: 'Highlights',
        icon: Icons.event_available_rounded,
        accentColor: Color(0xFFE11D48),
      ),
      HighlightSectionModel(
        id: 'invite_friends',
        title: 'Invite Friends',
        category: 'Highlights',
        icon: Icons.group_add_rounded,
        accentColor: Color(0xFF2563EB),
      ),
      HighlightSectionModel(
        id: 'gratitude_script',
        title: 'Gratitude Script',
        category: 'Highlights',
        icon: Icons.favorite_rounded,
        accentColor: Color(0xFFF43F5E),
      ),
      HighlightSectionModel(
        id: 'last_month_activity',
        title: 'Last Month Activity',
        category: 'Highlights',
        icon: Icons.insert_chart_rounded,
        accentColor: Color(0xFF10B981),
      ),
      HighlightSectionModel(
        id: 'circle_chat',
        title: 'Circle Chat',
        category: 'Highlights',
        icon: Icons.chat_bubble_rounded,
        accentColor: Color(0xFF8B5CF6),
        isLocked: true,
      ),
      HighlightSectionModel(
        id: 'open_asks',
        title: 'Open Asks',
        category: 'Highlights',
        icon: Icons.campaign_rounded,
        accentColor: Color(0xFFF97316),
      ),
      HighlightSectionModel(
        id: 'collaborations',
        title: 'Collaborations',
        category: 'Highlights',
        icon: Icons.hub_rounded,
        accentColor: Color(0xFF3B82F6),
      ),
      HighlightSectionModel(
        id: 'leadership_role',
        title: 'Leadership Role',
        category: 'Highlights',
        icon: Icons.co_present_rounded,
        accentColor: Color(0xFF9333EA),
      ),
      HighlightSectionModel(
        id: 'recommend_peer',
        title: 'Recommend a Peer',
        category: 'Highlights',
        icon: Icons.person_add_alt_1_rounded,
        accentColor: Color(0xFFEC4899),
      ),
      HighlightSectionModel(
        id: 'become_mentor',
        title: 'Become a Mentor',
        category: 'Highlights',
        icon: Icons.workspace_premium_rounded,
        accentColor: Color(0xFF059669),
      ),
      HighlightSectionModel(
        id: 'become_speaker',
        title: 'Become a Speaker',
        category: 'Highlights',
        icon: Icons.mic_rounded,
        accentColor: Color(0xFFEA580C),
      ),
      HighlightSectionModel(
        id: 'partner_with_us',
        title: 'Partner with Us',
        category: 'Highlights',
        icon: Icons.handshake_rounded,
        accentColor: Color(0xFF2563EB),
      ),
      HighlightSectionModel(
        id: 'vyapaar_jagat_story',
        title: 'Vyapaar Jagat Story',
        category: 'Highlights',
        icon: Icons.auto_stories_rounded,
        accentColor: Color(0xFF0284C7),
      ),
      HighlightSectionModel(
        id: 'leadership_certificate',
        title: 'Leadership Certificate',
        category: 'Highlights',
        icon: Icons.verified_rounded,
        accentColor: Color(0xFF7C3AED),
      ),
      HighlightSectionModel(
        id: 'entrepreneur_certificate',
        title: 'Entrepreneur Certificate',
        category: 'Highlights',
        icon: Icons.military_tech_rounded,
        accentColor: Color(0xFFD97706),
      ),

      // Category 2: Core Collaboration Actions
      HighlightSectionModel(
        id: 'referral',
        title: 'Referral',
        category: 'Core Collaboration Actions',
        icon: Icons.person_pin_circle_rounded,
        accentColor: Color(0xFF2563EB),
      ),
      HighlightSectionModel(
        id: 'business_deal',
        title: 'Business Deal',
        category: 'Core Collaboration Actions',
        icon: Icons.business_center_rounded,
        accentColor: Color(0xFF059669),
      ),
      HighlightSectionModel(
        id: 'p2p_meeting',
        title: 'P2P Meeting',
        category: 'Core Collaboration Actions',
        icon: Icons.groups_rounded,
        accentColor: Color(0xFF7C3AED),
      ),
      HighlightSectionModel(
        id: 'testimonial',
        title: 'Testimonial',
        category: 'Core Collaboration Actions',
        icon: Icons.thumb_up_rounded,
        accentColor: Color(0xFFD97706),
      ),
      HighlightSectionModel(
        id: 'post_ask',
        title: 'Post an Ask',
        category: 'Core Collaboration Actions',
        icon: Icons.post_add_rounded,
        accentColor: Color(0xFFE11D48),
      ),
      HighlightSectionModel(
        id: 'apply_collaboration',
        title: 'Apply Collaboration',
        category: 'Core Collaboration Actions',
        icon: Icons.sync_alt_rounded,
        accentColor: Color(0xFF3B82F6),
      ),
      // HighlightSectionModel(
      //   id: 'collaboration_ask',
      //   title: 'Collaboration Ask',
      //   category: 'Core Collaboration Actions',
      //   icon: Icons.help_center_rounded,
      //   accentColor: Color(0xFFEA580C),
      // ),
      HighlightSectionModel(
        id: 'register_visitor',
        title: 'Register Visitor',
        category: 'Core Collaboration Actions',
        icon: Icons.person_add_rounded,
        accentColor: Color(0xFF10B981),
      ),
      HighlightSectionModel(
        id: 'add_impact',
        title: 'Add Impact',
        category: 'Core Collaboration Actions',
        icon: Icons.volunteer_activism_rounded,
        accentColor: Color(0xFFF43F5E),
      ),
      HighlightSectionModel(
        id: 'claim_coins',
        title: 'Claim Coins',
        category: 'Core Collaboration Actions',
        icon: Icons.monetization_on_rounded,
        accentColor: Color(0xFFF59E0B),
      ),

      // Category 3: Impact Dashboard
      HighlightSectionModel(
        id: 'impact_score',
        title: 'My Impact Score',
        category: 'Impact Dashboard',
        icon: Icons.speed_rounded,
        accentColor: Color(0xFF0284C7),
      ),
      HighlightSectionModel(
        id: 'badges',
        title: 'My Badges',
        category: 'Impact Dashboard',
        icon: Icons.stars_rounded,
        accentColor: Color(0xFFF59E0B),
      ),
      HighlightSectionModel(
        id: 'coins_wallet',
        title: 'My Coins',
        category: 'Impact Dashboard',
        icon: Icons.account_balance_wallet_rounded,
        accentColor: Color(0xFF10B981),
      ),
      HighlightSectionModel(
        id: 'collaboration_history',
        title: 'Collaboration History',
        category: 'Impact Dashboard',
        icon: Icons.history_rounded,
        accentColor: Color(0xFF8B5CF6),
      ),

      // Category 4: Menu / More Options
      HighlightSectionModel(
        id: 'circulars',
        title: 'Circulars',
        category: 'Menu / More Options',
        icon: Icons.campaign_rounded,
        accentColor: Color(0xFFE11D48),
      ),
      HighlightSectionModel(
        id: 'gallery',
        title: 'Gallery',
        category: 'Menu / More Options',
        icon: Icons.photo_library_rounded,
        accentColor: Color(0xFF3B82F6),
      ),
      HighlightSectionModel(
        id: 'videos',
        title: 'Videos',
        category: 'Menu / More Options',
        icon: Icons.video_library_rounded,
        accentColor: Color(0xFFEA580C),
      ),
      HighlightSectionModel(
        id: 'tutorials',
        title: 'Tutorials',
        category: 'Menu / More Options',
        icon: Icons.school_rounded,
        accentColor: Color(0xFF059669),
      ),
      HighlightSectionModel(
        id: 'meeting_schedule',
        title: 'Meeting Schedule',
        category: 'Menu / More Options',
        icon: Icons.calendar_month_rounded,
        accentColor: Color(0xFF7C3AED),
      ),
      HighlightSectionModel(
        id: 'welcome_creative',
        title: 'Welcome Creative',
        category: 'Menu / More Options',
        icon: Icons.auto_fix_high_rounded,
        accentColor: Color(0xFFEC4899),
      ),
    ];
  }
}
