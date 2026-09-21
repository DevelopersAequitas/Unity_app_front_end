import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../router/app_router.dart';
import '../../features/events/domain/entities/event_entity.dart';

class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> init() async {
    _appLinks = AppLinks();

    // 1. Handle app launch from terminated state
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('[DeepLinkService] Initial URI received: $initialUri');
        _handleUriWithRetry(initialUri);
      }
    } catch (e) {
      debugPrint('[DeepLinkService] Error getting initial link: $e');
    }

    // 2. Handle links while app is running in background/foreground
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('[DeepLinkService] Stream URI received: $uri');
        _handleUriWithRetry(uri);
      },
      onError: (err) {
        debugPrint('[DeepLinkService] Stream error: $err');
      },
    );
  }

  void _handleUriWithRetry(Uri uri, {int retryCount = 0}) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      if (retryCount < 10) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _handleUriWithRetry(uri, retryCount: retryCount + 1);
        });
      }
      return;
    }

    _handleUri(uri, context);
  }

  void _handleUri(Uri uri, BuildContext context) {
    debugPrint(
        '[DeepLinkService] Handling URI: $uri (path: ${uri.path}, host: ${uri.host}, query: ${uri.queryParameters})');

    String? type = uri.queryParameters['type'];
    String? id = uri.queryParameters['id'];
    String? ref = uri.queryParameters['ref'] ?? uri.queryParameters['code'];
    String? tab = uri.queryParameters['tab'];

    // Handle path-based links
    if (type == null || type.isEmpty) {
      if (uri.pathSegments.isNotEmpty) {
        final first = uri.pathSegments.first.toLowerCase();
        if (first == 'share') {
          type = uri.queryParameters['type'];
        } else if (first == 'register' || first == 'invite' || first == 'join') {
          type = 'register';
          if (uri.pathSegments.length > 1) {
            ref = uri.pathSegments[1];
          }
        } else if (first == 'profile' || first == 'peer_profile' || first == 'peer') {
          if (uri.pathSegments.length > 1) {
            type = 'peer_profile';
            id = uri.pathSegments[1];
          } else {
            type = 'profile';
          }
        } else if (first == 'post' || first == 'posts') {
          type = 'post';
          if (uri.pathSegments.length > 1) {
            id = uri.pathSegments[1];
          }
        } else {
          type = first;
        }
      }
    }

    // Fallback to host for custom scheme links: peersunity://peer_profile?id=...
    if (type == null || type.isEmpty) {
      type = uri.host;
    }

    if (id == null || id.isEmpty) {
      id = uri.queryParameters['id'] ??
          uri.queryParameters['profile_id'] ??
          uri.queryParameters['peer_id'] ??
          uri.queryParameters['post_id'] ??
          uri.queryParameters['circle_id'] ??
          uri.queryParameters['event_id'];
    }

    final cleanId = id?.replaceAll('/', '').trim();
    final cleanType = type.toLowerCase().replaceAll('-', '_').trim();

    void safePush(String routeName, {Object? arguments}) {
      try {
        Navigator.pushNamed(context, routeName, arguments: arguments);
      } catch (e) {
        debugPrint('[DeepLinkService] Navigation error for $routeName: $e');
      }
    }

    switch (cleanType) {
      // 1. Home / Unity / Feed
      case 'home':
      case 'unity':
      case 'app_unity':
      case 'feed':
      case 'post':
      case 'posts':
        safePush(AppRoutes.home);
        break;

      // 2. Peers / Connections / Matches
      case 'peers':
      case 'my_peers':
      case 'my_peer':
        safePush(AppRoutes.peers);
        break;

      case 'peer_profile':
      case 'member_profile':
        if (cleanId != null && cleanId.isNotEmpty) {
          safePush(AppRoutes.peerProfile, arguments: cleanId);
        } else {
          safePush(AppRoutes.peers);
        }
        break;

      case 'profile':
      case 'my_profile':
        if (cleanId != null && cleanId.isNotEmpty) {
          safePush(AppRoutes.peerProfile, arguments: cleanId);
        } else {
          safePush(AppRoutes.profile);
        }
        break;

      case 'matches':
      case 'one_to_one':
      case 'find_a_peer':
      case 'matchmaking':
        safePush(AppRoutes.matches);
        break;

      case 'near_me':
      case 'nearme':
      case 'nearby':
        safePush(AppRoutes.nearMe);
        break;

      case 'connections':
      case 'my_connections':
        safePush(AppRoutes.connections);
        break;

      case 'requests':
      case 'peer_requests':
      case 'connection_requests':
        safePush(AppRoutes.peerRequests);
        break;

      // 3. Profile & Profile Editing
      case 'edit_profile':
      case 'edit_profile_overview':
      case 'complete_profile':
        safePush(AppRoutes.editProfileOverview);
        break;

      case 'edit_personal_info':
      case 'add_photo':
      case 'your_face':
        safePush(AppRoutes.editPersonalInfo);
        break;

      case 'edit_business_info':
      case 'your_business':
      case 'update_business':
        safePush(AppRoutes.editBusinessInfo);
        break;

      case 'edit_interests_goals':
      case 'how_i_can_help':
      case 'interests_goals':
        safePush(AppRoutes.editInterestsGoals);
        break;

      case 'edit_social_links':
        safePush(AppRoutes.editSocialLinks);
        break;

      case 'edit_media_portfolio':
        safePush(AppRoutes.editMediaPortfolio);
        break;

      case 'welcome_creative':
        safePush(AppRoutes.profile);
        break;

      // 4. Circles
      case 'circles':
      case 'my_circles':
      case 'circle':
        safePush(AppRoutes.circles);
        break;

      case 'circle_details':
        safePush(AppRoutes.circles);
        break;

      case 'join_circle':
      case 'joincircle':
      case 'explore_circles':
        safePush(AppRoutes.circles);
        break;

      // 5. Stories & Certifications
      case 'vyapaar_jagat_story':
      case 'share_story':
      case 'story':
        safePush(AppRoutes.vyapaarJagatStory);
        break;

      case 'leadership_certificate':
      case 'leadership_certification':
        safePush(AppRoutes.leadershipCertificate);
        break;

      case 'entrepreneur_certificate':
      case 'entrepreneur_certification':
        safePush(AppRoutes.entrepreneurCertificate);
        break;

      // 6. Post Ask / Requirements / Give First
      case 'collaboration_ask':
      case 'ask_form':
        safePush(AppRoutes.collaborationAsk);
        break;

      case 'post_ask':
      case 'post_requirement':
      case 'add_ask':
      case 'ask_peers':
        safePush(AppRoutes.postAsk);
        break;

      case 'open_asks':
      case 'open_ask':
      case 'requirement':
      case 'requirements':
      case 'open_requirement':
      case 'open_requirements':
      case 'give_first':
      case 'help_peer':
      case 'peer_needs_help':
        safePush(AppRoutes.openAsks, arguments: 0);
        break;

      case 'my_asks':
      case 'my_requirements':
        safePush(AppRoutes.openAsks, arguments: 1);
        break;

      // 7. Collaborations / Sales / Opportunities
      case 'collaborations':
      case 'collaboration':
      case 'explore_opportunities':
      case 'open_collaboration':
      case 'sales':
      case 'opportunities':
        safePush(AppRoutes.collaborations, arguments: 0);
        break;

      case 'apply_collaboration':
      case 'post_collaboration':
      case 'add_collaboration':
        safePush(AppRoutes.addCollaboration);
        break;

      case 'collaboration_history':
        safePush(AppRoutes.collaborations, arguments: 2);
        break;

      // 8. Events
      case 'event':
      case 'event_detail':
        if (cleanId != null && cleanId.isNotEmpty) {
          final occId = uri.queryParameters['occurrence_id'] ?? '';
          safePush(
            AppRoutes.eventDetail,
            arguments: EventEntity(
              eventId: cleanId,
              occurrenceId: occId,
              title: '',
              description: '',
              eventType: '',
              eventCategory: '',
              mode: '',
            ),
          );
        } else {
          safePush(AppRoutes.events);
        }
        break;

      case 'events':
      case 'gallery':
      case 'event_gallery':
      case 'meet_in_person':
        safePush(AppRoutes.events);
        break;

      case 'event_videos':
      case 'videos':
        safePush(AppRoutes.eventVideos);
        break;

      case 'event_qr':
      case 'event_pass':
        safePush(AppRoutes.events);
        break;

      // 9. Tutorials / Resources / Circulars
      case 'tutorials':
      case 'learn':
      case 'learning':
      case 'training':
        safePush(AppRoutes.tutorials);
        break;

      case 'circulars':
      case 'resources':
      case 'documents':
        safePush(AppRoutes.circulars);
        break;

      // 10. Impact / LSR / Leaderboard
      case 'life_impact':
      case 'impact':
      case 'my_impact':
      case 'impact_score':
      case 'live_impact':
      case 'live_impacted':
        safePush(AppRoutes.lifeImpact);
        break;

      case 'impact_leaderboard':
        safePush(AppRoutes.impactLeaderboard);
        break;

      case 'leaderboard':
      case 'coins_leaderboard':
        safePush(AppRoutes.leaderboard);
        break;

      case 'coins':
      case 'coins_wallet':
      case 'claim_coins':
      case 'badges':
        safePush(AppRoutes.coins);
        break;

      case 'coin_guidelines':
        safePush(AppRoutes.coinGuidelines);
        break;

      case 'impact_guidelines':
      case 'lsr':
      case 'lsr_goal':
        safePush(AppRoutes.impactGuidelines);
        break;

      // 11. P2P Meetings
      case 'p2p_meetings':
      case 'p2p_meeting':
      case 'p2p':
      case 'meetings':
        final initialTab = int.tryParse(tab ?? '') ?? 0;
        safePush(AppRoutes.p2pMeetings, arguments: initialTab);
        break;

      case 'add_p2p_meeting':
        safePush(AppRoutes.addP2pMeeting);
        break;

      // 12. Referrals
      case 'referrals':
      case 'referral':
        safePush(AppRoutes.referrals);
        break;

      case 'add_referral':
        safePush(AppRoutes.addReferral);
        break;

      // 13. Business Deals
      case 'business_deals':
      case 'business_deal':
      case 'deals':
        safePush(AppRoutes.businessDeals);
        break;

      case 'add_business_deal':
        safePush(AppRoutes.addBusinessDeal);
        break;

      // 14. Testimonials
      case 'testimonials':
      case 'testimonial':
        safePush(AppRoutes.testimonials);
        break;

      case 'add_testimonial':
        safePush(AppRoutes.addTestimonial);
        break;


      // 16. Highlights & Other Actions
      case 'recommend_peer':
      case 'introduce_peer':
      case 'introduce_a_peer':
        safePush(AppRoutes.recommendPeer);
        break;

      case 'top_community_builders':
      case 'top_builders':
      case 'introduced_peers':
        safePush(AppRoutes.topCommunityBuilders);
        break;

      case 'my_network':
      case 'invite_friends':
        safePush(AppRoutes.myNetwork);
        break;

      case 'gratitude_script':
        safePush(AppRoutes.gratitudeScript);
        break;

      case 'last_month_activity':
      case 'my_journey':
      case 'impact_recap':
        safePush(AppRoutes.lastMonthActivity);
        break;

      case 'become_mentor':
        safePush(AppRoutes.becomeMentor);
        break;

      case 'become_speaker':
        safePush(AppRoutes.becomeSpeaker);
        break;

      case 'leadership_role':
        safePush(AppRoutes.leadershipRole);
        break;

      case 'partner_with_us':
        safePush(AppRoutes.partnerWithUs);
        break;

      case 'membership':
      case 'membership_paywall':
        safePush(AppRoutes.membershipPaywall);
        break;

      case 'notifications':
        safePush(AppRoutes.notifications);
        break;

      case 'register':
        safePush(AppRoutes.register, arguments: ref);
        break;

      default:
        debugPrint('[DeepLinkService] Unhandled deep link type: $type');
        safePush(AppRoutes.home);
        break;
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}

