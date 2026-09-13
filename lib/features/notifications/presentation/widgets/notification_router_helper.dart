import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationRouterHelper {
  NotificationRouterHelper._();

  static void handleNotificationTap(BuildContext context, NotificationEntity notification) {
    final meta = notification.metaData ?? {};
    final type = (notification.type.isNotEmpty ? notification.type : (meta['type'] ?? meta['notification_type'] ?? '')).toString().toLowerCase().trim();
    final tapDest = (notification.tapDestination ?? notification.screen ?? meta['screen'] ?? meta['tap_destination'] ?? '').toString().trim();

    void safePush(String routeName, {Object? arguments}) {
      try {
        Navigator.of(context).pushNamed(routeName, arguments: arguments);
      } catch (_) {
        // Graceful fallback to home
      }
    }

    // Direct screen override from backend if provided
    if (tapDest == '/connection-requests' || tapDest == '/peer-requests') {
      safePush(AppRoutes.peerRequests);
      return;
    } else if (tapDest == '/connections' || tapDest == '/my-connections') {
      safePush(AppRoutes.connections);
      return;
    } else if (tapDest == '/profile') {
      safePush(AppRoutes.profile);
      return;
    }

    switch (type) {
      // 1. Post & Requirements
      case 'new_post':
      case 'post':
      case 'post_like':
      case 'post_comment':
      case 'post_mention':
      case 'requirement_created':
      case 'requirement_lead':
      case 'requirement_match':
      case 'requirement':
        final memberId = meta['member_id'] ?? meta['actor_id'] ?? meta['user_id'];
        final postId = meta['post_id'] ?? meta['requirement_id'] ?? notification.referenceId;
        if (memberId != null && memberId.toString().isNotEmpty) {
          safePush(AppRoutes.peerProfile, arguments: memberId.toString());
        } else if (postId != null && postId.toString().isNotEmpty) {
          safePush(AppRoutes.peerProfile, arguments: postId.toString());
        }
        break;

      // 2. Peer Profile (Accepted Connections)
      case 'follow_accepted':
      case 'follow_accept':
      case 'connection_accepted':
        final memberId = meta['member_id'] ?? meta['actor_id'] ?? meta['profile_id'] ?? notification.referenceId;
        if (memberId != null && memberId.toString().isNotEmpty) {
          safePush(AppRoutes.peerProfile, arguments: memberId.toString());
        } else {
          safePush(AppRoutes.connections);
        }
        break;

      // 3. Incoming Connection Requests
      case 'follow_requested':
      case 'follow_request':
      case 'connection_request':
        safePush(AppRoutes.peerRequests);
        break;

      // 4. P2P Meetings
      case 'p2p_meeting_notification':
      case 'p2p_reschedule_notification':
      case 'meeting_scheduled':
      case 'meeting_rescheduled':
        final meetingId = meta['meeting_id'] ?? notification.referenceId;
        safePush(AppRoutes.p2pMeetings, arguments: meetingId?.toString());
        break;

      // 5. Circle & Circle Chat
      case 'circle_join_notification':
      case 'circle_approved':
        final circleId = meta['circle_id'] ?? notification.referenceId;
        if (circleId != null && circleId.toString().isNotEmpty) {
          safePush(AppRoutes.circleDetails, arguments: circleId.toString());
        }
        break;
      case 'chat_message_notification':
      case 'chat_message':
        final circleId = meta['circle_id'] ?? notification.referenceId;
        if (circleId != null && circleId.toString().isNotEmpty) {
          safePush(AppRoutes.circleChat, arguments: circleId.toString());
        }
        break;

      // 6. Coins & Wallet
      case 'coin_earned_notification':
      case 'coin_claim_reviewed':
      case 'coins_received':
        safePush(AppRoutes.wallet);
        break;

      // 7. Brand Partners & Offers
      case 'new_offer_added':
      case 'new_partner_joined':
      case 'brand_partner_offer':
        final partnerId = meta['partner_id'] ?? notification.referenceId;
        if (partnerId != null && partnerId.toString().isNotEmpty) {
          safePush(AppRoutes.brandPartnerDetails, arguments: partnerId.toString());
        }
        break;

      // 8. Life Impact
      case 'impact_reviewed':
      case 'impact_submitted':
      case 'life_impact':
        safePush(AppRoutes.lifeImpact);
        break;

      // 9. Membership & Account
      case 'welcome_notification':
      case 'membership_expiry_reminder':
      case 'upcoming_membership_expiry_reminder':
      case 'circle_membership_expiry_reminder':
        safePush(AppRoutes.profile);
        break;

      // 10. Official Circulars
      case 'circular_notification':
      case 'circular':
        final circularId = meta['circular_id'] ?? notification.referenceId;
        safePush(AppRoutes.circulars, arguments: circularId?.toString());
        break;

      // 11. Support Tickets
      case 'support_ticket_notification':
      case 'ticket_status':
        final ticketId = meta['ticket_id'] ?? notification.referenceId;
        safePush(AppRoutes.supportTicketDetails, arguments: ticketId?.toString());
        break;

      // 12. Default / Daily Reminder / Engagement -> Stay on Home Feed
      case 'daily_engagement_reminder':
      case 'daily_reminder':
      case 'streak_reminder':
      case 'engagement_reminder':
      default:
        break;
    }
  }
}
