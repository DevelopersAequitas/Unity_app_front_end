import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/notification_entity.dart';

/// Central router helper to navigate to proper screens, bottom nav bars, and sub-tabs
/// on notification item tap.
class NotificationRouterHelper {
  NotificationRouterHelper._();

  static void handleNotificationTap(
    BuildContext context,
    NotificationEntity notification,
  ) {
    final meta = notification.metaData ?? {};
    final rawType = (notification.type.isNotEmpty
            ? notification.type
            : (meta['notification_type'] ?? meta['type'] ?? ''))
        .toString()
        .toLowerCase()
        .trim();
    final tapDest = (notification.tapDestination ??
            notification.screen ??
            meta['navigation_screen'] ??
            meta['screen'] ??
            meta['tap_destination'] ??
            '')
        .toString()
        .trim();

    void safePush(String routeName, {Object? arguments}) {
      try {
        Navigator.of(context).pushNamed(routeName, arguments: arguments);
      } catch (_) {
        // Safe fallback to home if route is missing
        try {
          Navigator.of(context).pushNamed(AppRoutes.home);
        } catch (_) {}
      }
    }

    // Direct screen path overrides from backend if explicitly matching a known route
    if (tapDest.isNotEmpty) {
      if (tapDest == '/connection-requests' ||
          tapDest == '/peer-requests' ||
          tapDest == '/pending-requests') {
        safePush(AppRoutes.peerRequests);
        return;
      } else if (tapDest == '/connections' || tapDest == '/my-connections') {
        safePush(AppRoutes.connections);
        return;
      } else if (tapDest == '/profile') {
        safePush(AppRoutes.profile);
        return;
      } else if (tapDest == '/chats' || tapDest == '/chat-hub') {
        safePush(AppRoutes.chatList);
        return;
      } else if (tapDest == '/membership-paywall' ||
          tapDest == '/paywall' ||
          tapDest == '/renew') {
        safePush(AppRoutes.membershipPaywall);
        return;
      } else if (tapDest == '/business-deals') {
        safePush(AppRoutes.businessDeals);
        return;
      } else if (tapDest == '/referrals') {
        safePush(AppRoutes.referrals);
        return;
      } else if (tapDest == '/leaderboard') {
        safePush(AppRoutes.leaderboard);
        return;
      } else if (tapDest == '/wallet' || tapDest == '/coins') {
        safePush(AppRoutes.coins);
        return;
      } else if (tapDest == '/circulars') {
        safePush(AppRoutes.circulars);
        return;
      } else if (tapDest == '/support' || tapDest == '/ticket-history') {
        safePush(AppRoutes.ticketHistory);
        return;
      } else if (tapDest == '/life-impact') {
        safePush(AppRoutes.lifeImpact, arguments: 0);
        return;
      } else if (tapDest == '/vyapaar-jagat-story' ||
          tapDest == '/story' ||
          tapDest == '/story-submissions') {
        safePush(AppRoutes.vyapaarJagatStory);
        return;
      }
    }

    switch (rawType) {
      // ═════════════════════════════════════════════════════════════════════════
      // Group 1: Feed, Posts & Social Interactions
      // ═════════════════════════════════════════════════════════════════════════
      case 'new_post':
      case 'member_introduced':
      case 'post':
      case 'post_like':
      case 'post_comment':
      case 'post_mention':
      case 'user_mention':
      case 'share_post':
        final memberId = meta['member_id'] ??
            meta['actor_id'] ??
            meta['profile_id'] ??
            meta['user_id'] ??
            meta['from_user_id'] ??
            notification.referenceId;
        if (memberId != null && memberId.toString().isNotEmpty) {
          safePush(AppRoutes.peerProfile, arguments: memberId.toString());
        } else {
          safePush(AppRoutes.home);
        }
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 2: Business Requirements & Open Asks
      // ═════════════════════════════════════════════════════════════════════════
      case 'requirement':
      case 'requirement_created':
      case 'requirement_match':
      case 'requirement_lead':
        // Tab 0: Open Asks / Opportunities
        safePush(AppRoutes.openAsks, arguments: 0);
        break;

      case 'requirement_interest':
        // Tab 1: My Asks (view received interest & responses)
        safePush(AppRoutes.openAsks, arguments: 1);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 3: P2P 1-on-1 Peer Meetings
      // ═════════════════════════════════════════════════════════════════════════
      case 'p2p_meeting_request':
        // Scheduled Tab (2) -> Received SubTab (0)
        safePush(
          AppRoutes.p2pMeetings,
          arguments: {'initialTabIndex': 2, 'initialSubTabIndex': 0},
        );
        break;

      case 'p2p_meeting_accepted':
      case 'p2p_meeting_rejected':
      case 'p2p_meeting_cancelled':
        // Scheduled Tab (2) -> Sent / Status SubTab (1)
        safePush(
          AppRoutes.p2pMeetings,
          arguments: {'initialTabIndex': 2, 'initialSubTabIndex': 1},
        );
        break;

      case 'p2p_reschedule_requested':
      case 'p2p_reschedule_approved':
      case 'p2p_reschedule_rejected':
        // Scheduled Tab (2) -> Reschedules SubTab (2)
        safePush(
          AppRoutes.p2pMeetings,
          arguments: {'initialTabIndex': 2, 'initialSubTabIndex': 2},
        );
        break;

      case 'activity_p2p_meeting':
      case 'meeting_scheduled':
      case 'p2p_meeting_notification':
      case 'p2p_reschedule_notification':
        // Completed Tab (1) -> I Initiated SubTab (0)
        safePush(
          AppRoutes.p2pMeetings,
          arguments: {'initialTabIndex': 1, 'initialSubTabIndex': 0},
        );
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 4: Business Deals & Slips
      // ═════════════════════════════════════════════════════════════════════════
      case 'deal_logged':
      case 'activity_business_deal':
      case 'business_deal':
        safePush(AppRoutes.businessDeals);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 5: Connections & Social Graph
      // ═════════════════════════════════════════════════════════════════════════
      case 'connection_request':
      case 'follow_requested':
      case 'follow_request':
      case 'connection_request_pending_reminder':
        safePush(AppRoutes.peerRequests);
        break;

      case 'connection_accepted':
      case 'follow_accepted':
      case 'follow_accept':
      case 'profile_viewed':
      case 'unfollowed':
        final memberId = meta['member_id'] ??
            meta['actor_id'] ??
            meta['profile_id'] ??
            meta['viewer_id'] ??
            meta['from_user_id'] ??
            notification.referenceId;
        if (memberId != null && memberId.toString().isNotEmpty) {
          safePush(AppRoutes.peerProfile, arguments: memberId.toString());
        } else {
          safePush(AppRoutes.connections);
        }
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 6: Circles & Communities
      // ═════════════════════════════════════════════════════════════════════════
      case 'circle_join_request_submitted':
      case 'circle_join_request_cd_approved':
      case 'circle_join_request_cd_rejected':
      case 'circle_join_request_id_approved':
      case 'circle_join_request_id_rejected':
        final requestId = meta['circle_join_request_id'] ??
            meta['request_id'] ??
            notification.referenceId;
        final circleName = meta['circle_name'] ?? meta['title'] ?? 'Circle';
        if (requestId != null && requestId.toString().isNotEmpty) {
          safePush(
            AppRoutes.joinRequestStatus,
            arguments: {
              'requestId': requestId.toString(),
              'circleName': circleName.toString(),
            },
          );
        } else {
          safePush(AppRoutes.circles);
        }
        break;

      case 'circle_approved':
      case 'circle_join_request_member_confirmed':
      case 'circle_join_notification':
        final circleId = meta['circle_id'] ?? notification.referenceId;
        if (circleId != null && circleId.toString().isNotEmpty) {
          safePush(
            AppRoutes.circleDetails,
            arguments: {
              'circle_id': circleId.toString(),
              'circle_name': meta['circle_name'] ?? 'Circle',
            },
          );
        } else {
          safePush(AppRoutes.circles);
        }
        break;

      case 'trending_circle':
        safePush(AppRoutes.circles);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 7: Business Collaborations & Partnerships
      // ═════════════════════════════════════════════════════════════════════════
      case 'collaboration_created':
        // Tab 0: Explore Opportunities
        safePush(AppRoutes.collaborations, arguments: 0);
        break;

      case 'collaboration_completed':
      case 'collaboration_interest_received':
      case 'collaboration_meeting_requested':
      case 'collaboration_meeting_accepted':
      case 'collaboration_meeting_rejected':
        // Tab 1: My Collaborations & History
        safePush(AppRoutes.collaborations, arguments: 1);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 8: Member Referrals
      // ═════════════════════════════════════════════════════════════════════════
      case 'activity_referral':
      case 'activity_referral_status_updated':
      case 'referral_joined':
      case 'referral_signup':
      case 'referral':
        safePush(AppRoutes.referrals);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 9: Testimonials & Reviews
      // ═════════════════════════════════════════════════════════════════════════
      case 'activity_testimonial':
      case 'testimonial_received':
        safePush(AppRoutes.testimonials);
        break;

      case 'testimonial_request_after_deal':
      case 'testimonial_request':
        safePush(AppRoutes.addTestimonial);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 10: Reward Coins & Verified Claims
      // ═════════════════════════════════════════════════════════════════════════
      case 'coins_received':
      case 'coin_earned_notification':
      case 'wallet':
        safePush(AppRoutes.coins);
        break;

      case 'coin_claim_approved':
      case 'coin_claim_rejected':
      case 'coin_claim_reviewed':
      case 'coin_milestone':
        // Tab 1: Claim Status list
        safePush(AppRoutes.claimYourCoin, arguments: 1);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 11: Life Impact & Giving
      // ═════════════════════════════════════════════════════════════════════════
      case 'impact_submitted':
      case 'impact_received':
      case 'impact_approved':
      case 'impact_rejected':
      case 'life_impact':
      case 'impact_reviewed':
        // Tab 0: Impact score ledger
        safePush(AppRoutes.lifeImpact, arguments: 0);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 12: Events & Official Circulars
      // ═════════════════════════════════════════════════════════════════════════
      case 'event':
      case 'event_created':
      case 'event_live_reminder':
      case 'post_event_feedback':
        final eventId = meta['event_id'] ?? notification.referenceId;
        if (eventId != null && eventId.toString().isNotEmpty) {
          safePush(
            AppRoutes.eventDetail,
            arguments: {
              'event_id': eventId.toString(),
              'event_title': meta['event_title'] ?? meta['title'] ?? '',
            },
          );
        } else {
          safePush(AppRoutes.events);
        }
        break;

      case 'circular':
      case 'circular_notification':
        final circularId = meta['circular_id'] ?? notification.referenceId;
        safePush(AppRoutes.circulars, arguments: circularId?.toString());
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 13: Brand Partners & Exclusive Offers
      // ═════════════════════════════════════════════════════════════════════════
      case 'brand_partner_offer':
      case 'new_offer_added':
      case 'brand_partner_joined':
      case 'new_partner_joined':
        final partnerId = meta['partner_id'] ??
            meta['brand_partner_id'] ??
            notification.referenceId;
        if (partnerId != null && partnerId.toString().isNotEmpty) {
          safePush(
            AppRoutes.brandPartnerDetails,
            arguments: {
              'partner_id': partnerId.toString(),
              'partner_name': meta['partner_name'] ?? 'Brand Partner',
              'logo_url': meta['logo_url'] ?? '',
            },
          );
        } else {
          safePush(AppRoutes.highlights);
        }
        break;

      case 'brand_offer_expiry_reminder':
      case 'offer_expiry_reminder':
        safePush(AppRoutes.highlights);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 14: Real-Time Chat & Messaging
      // ═════════════════════════════════════════════════════════════════════════
      case 'chat_message':
      case 'chat_message_notification':
      case 'circle_chat':
      case 'circle_chat_message_notification':
        final isLeadership = meta['is_leadership'] == true ||
            meta['chat_type'] == 'leadership';
        final circleId = meta['circle_id'] ?? notification.referenceId;
        final circleName = meta['circle_name'] ?? meta['title'];
        if (circleId != null && circleId.toString().isNotEmpty) {
          if (isLeadership) {
            safePush(
              AppRoutes.circleLeadershipChat,
              arguments: {
                'circle_id': circleId.toString(),
                'circle_name': circleName?.toString(),
              },
            );
          } else {
            safePush(
              AppRoutes.circleChat,
              arguments: {
                'circle_id': circleId.toString(),
                'circle_name': circleName?.toString(),
              },
            );
          }
        } else {
          safePush(AppRoutes.chatList);
        }
        break;

      case 'direct_message':
      case 'direct_chat':
      case 'direct_message_notification':
      case 'chat_direct':
      case 'new_message':
        final chatId = meta['chat_id'] ?? meta['conversation_id'];
        final peerId = meta['peer_id'] ??
            meta['user_id'] ??
            meta['sender_id'] ??
            notification.referenceId;
        final peerName =
            meta['peer_name'] ?? meta['sender_name'] ?? meta['user_name'];
        final peerAvatar = meta['peer_avatar'] ??
            meta['avatar_url'] ??
            meta['profile_photo_url'];
        if (peerId != null && peerId.toString().isNotEmpty) {
          safePush(
            AppRoutes.directChat,
            arguments: {
              'chat_id': chatId?.toString(),
              'peer_id': peerId.toString(),
              'peer_name': peerName?.toString(),
              'peer_avatar': peerAvatar?.toString(),
            },
          );
        } else {
          safePush(AppRoutes.chatList);
        }
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 15: Support Tickets & SME Stories
      // ═════════════════════════════════════════════════════════════════════════
      case 'ticket_status':
      case 'support_ticket_notification':
        safePush(AppRoutes.ticketHistory);
        break;

      case 'story_submitted':
      case 'story_approved':
      case 'story_rejected':
      case 'story_published':
      case 'story_publish':
      case 'story':
      case 'vyapaar_jagat_story':
      case 'vyapaarjagat_story':
        safePush(AppRoutes.vyapaarJagatStory);
        break;

      // ═════════════════════════════════════════════════════════════════════════
      // Group 16: Membership Lifecycle & App System
      // ═════════════════════════════════════════════════════════════════════════
      case 'welcome':
      case 'welcome_notification':
      case 'membership_activated':
        safePush(AppRoutes.home);
        break;

      case 'membership_updated':
      case 'membership_upgraded':
      case 'upcoming_membership_expiry_reminder':
      case 'membership_expiry_reminder':
      case 'membership_expiry':
      case 'circle_membership_expiry_reminder':
      case 'renew':
      case 'upgrade':
        // Navigate to Paywall Screen for all membership renewals/upgrades/expiries
        safePush(AppRoutes.membershipPaywall);
        break;

      case 'badge_unlocked':
        safePush(AppRoutes.badges);
        break;

      case 'leaderboard_rank_change':
        safePush(AppRoutes.leaderboard);
        break;

      case 'app_update':
      case 'app_update_reminder':
        String? targetUrl;
        if (!kIsWeb && Platform.isIOS) {
          targetUrl = (meta['appstore_url'] ??
                  'https://apps.apple.com/in/app/peers-global-unity/id6739198477')
              .toString();
        } else {
          targetUrl = (meta['playstore_url'] ??
                  'https://play.google.com/store/apps/details?id=com.peers.peersunity&pcampaignid=web_share')
              .toString();
        }
        if (targetUrl.isNotEmpty) {
          try {
            final uri = Uri.parse(targetUrl);
            launchUrl(uri, mode: LaunchMode.externalApplication);
          } catch (_) {
            safePush(AppRoutes.home);
          }
        } else {
          safePush(AppRoutes.home);
        }
        break;

      case 'daily_reminder':
      case 'streak_reminder':
      case 'daily_engagement_reminder':
      case 'engagement_reminder':
      default:
        // Graceful default: If no specific screen is needed, navigate to Home
        if (tapDest.isNotEmpty && tapDest != 'home' && tapDest != '/home') {
          safePush(tapDest);
        } else {
          safePush(AppRoutes.home);
        }
        break;
    }
  }
}
