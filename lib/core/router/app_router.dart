import 'package:flutter/material.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../features/home/presentation/screens/create_post_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/peers/presentation/screens/bookmarked_peers_screen.dart';
import '../../features/peers/presentation/screens/connections_screen.dart';
import '../../features/peers/presentation/screens/matches_screen.dart';
import '../../features/peers/presentation/screens/my_peers_screen.dart';
import '../../features/peers/presentation/screens/near_me_screen.dart';
import '../../features/peers/presentation/screens/peer_requests_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/domain/usecases/toggle_post_like_usecase.dart';
import '../../features/home/domain/usecases/toggle_post_save_usecase.dart';
import '../../features/peers/domain/usecases/block_peer_usecase.dart';
import '../../features/peers/domain/usecases/cancel_sent_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/follow_user_usecase.dart';
import '../../features/peers/domain/usecases/get_member_introduced_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_member_posts_usecase.dart';
import '../../features/peers/domain/usecases/get_member_profile_usecase.dart';
import '../../features/peers/domain/usecases/get_peer_block_status_usecase.dart';
import '../../features/peers/domain/usecases/remove_connection_usecase.dart';
import '../../features/peers/domain/usecases/send_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../features/peers/domain/usecases/unblock_peer_usecase.dart';
import '../../features/peers/domain/usecases/unfollow_user_usecase.dart';
import '../../features/peers/presentation/bloc/peer_profile_bloc.dart';
import '../../features/peers/presentation/screens/peer_profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/domain/entities/profile_entity.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/circles/domain/entities/circle_closed_category_entity.dart';
import '../../features/circles/domain/entities/circle_entity.dart';
import '../../features/circles/domain/entities/circle_open_category_entity.dart';
import '../../features/circles/domain/entities/circle_category_entity.dart';
import '../../features/circles/presentation/screens/circle_categories_screen.dart';
import '../../features/circles/presentation/screens/circle_detail_screen.dart';
import '../../features/circles/presentation/screens/circle_join_screen.dart';
import '../../features/circles/presentation/screens/circle_members_screen.dart';
import '../../features/circles/presentation/screens/circle_subcategories_screen.dart';
import '../../features/circles/presentation/screens/circles_screen.dart';
import '../../features/circles/presentation/screens/join_request_status_screen.dart';
import '../../features/membership/presentation/screens/membership_paywall_screen.dart';
import '../../features/testimonials/presentation/screens/add_testimonial_screen.dart';
import '../../features/testimonials/presentation/screens/peer_testimonials_screen.dart';
import '../../features/testimonials/presentation/screens/testimonials_screen.dart';
import '../../features/business_deal/presentation/screens/add_business_deal_screen.dart';
import '../../features/business_deal/presentation/screens/business_deals_screen.dart';
import '../../features/business_deal/presentation/screens/peer_business_deals_screen.dart';
import '../../features/referrals/presentation/screens/add_referral_screen.dart';
import '../../features/referrals/presentation/screens/referrals_screen.dart';
import '../../features/leaderboard/presentation/bloc/leaderboard_event.dart';
import '../../features/leaderboard/presentation/screens/coin_guidelines_screen.dart';
import '../../features/leaderboard/presentation/screens/impact_guidelines_screen.dart';
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';

import '../../features/p2p_meetings/presentation/screens/add_p2p_meeting_screen.dart';
import '../../features/p2p_meetings/presentation/screens/p2p_meetings_screen.dart';
import '../../features/requirements/presentation/screens/open_asks_screen.dart';
import '../../features/requirements/presentation/screens/post_ask_form_screen.dart';
import '../../features/highlights/presentation/screens/vyapaar_jagat_story_screen.dart';
import '../../features/highlights/presentation/screens/leadership_certification_screen.dart';
import '../../features/highlights/presentation/screens/entrepreneur_certification_screen.dart';
import '../../features/highlights/presentation/screens/ask_form_screen.dart';
import '../../features/collaborations/presentation/screens/add_collaboration_screen.dart';
import '../../features/collaborations/presentation/screens/collaborations_hub_screen.dart';
import '../../features/highlights/presentation/screens/recommend_peer_screen.dart';
import '../../features/highlights/presentation/screens/coins_screen.dart';
import '../../features/highlights/presentation/screens/claim_your_coin_screen.dart';
import '../../features/milestones/presentation/screens/coin_milestones_screen.dart';
import '../../features/highlights/presentation/screens/top_community_builders_screen.dart';
import '../../features/highlights/presentation/screens/my_network_screen.dart';
import '../../features/highlights/presentation/screens/gratitude_script_screen.dart';
import '../../features/highlights/presentation/screens/last_month_activity_screen.dart';
import '../../features/highlights/presentation/screens/become_mentor_screen.dart';
import '../../features/highlights/presentation/screens/become_speaker_screen.dart';
import '../../features/highlights/presentation/screens/leadership_role_screen.dart';
import '../../features/highlights/presentation/screens/partner_with_us_screen.dart';
import '../../features/highlights/presentation/screens/register_visitor_screen.dart';
import '../../features/highlights/presentation/screens/life_impact_screen.dart';
import '../../features/menu/presentation/screens/event_videos_screen.dart';
import '../../features/menu/presentation/screens/tutorials_screen.dart';
import '../../features/menu/presentation/screens/circulars_screen.dart';
import '../../features/highlights/presentation/screens/welcome_creative_template_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_overview_screen.dart';
import '../../features/profile/presentation/screens/edit_personal_info_screen.dart';
import '../../features/profile/presentation/screens/edit_business_info_screen.dart';
import '../../features/profile/presentation/screens/edit_interests_goals_screen.dart';
import '../../features/profile/presentation/screens/edit_social_links_screen.dart';
import '../../features/profile/presentation/screens/edit_media_portfolio_screen.dart';
import '../../features/profile/presentation/screens/edit_professional_journey_screen.dart';
import '../../features/profile/presentation/screens/edit_circle_membership_screen.dart';
import '../../features/profile/presentation/screens/edit_additional_info_screen.dart';

// Chat Screens
import '../../features/chat/presentation/screens/chat_hub_screen.dart';
import '../../features/chat/presentation/screens/direct_chat_screen.dart';
import '../../features/chat/presentation/screens/circle_chat_screen.dart';
import '../../features/chat/presentation/screens/circle_leadership_chat_screen.dart';

// Events Screens
import '../../features/events/domain/entities/event_entity.dart';
import '../../features/events/domain/entities/event_registration_entity.dart';
import '../../features/events/domain/entities/user_registration_info.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/events/presentation/screens/event_detail_screen.dart';
import '../../features/events/presentation/screens/my_events_screen.dart';
import '../../features/events/presentation/screens/event_qr_ticket_screen.dart';
import '../../features/highlights/presentation/screens/highlights_screen.dart';
import '../../features/shorts/presentation/screens/shorts_screen.dart';
import '../../features/home/presentation/screens/brand_partner_details_screen.dart';
import '../../features/home/domain/entities/brand_partner_entity.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String verifyOtp = '/verify-otp';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String peers = '/peers';
  static const String peerProfile = '/peer-profile';
  static const String matches = '/matches';
  static const String connections = '/connections';
  static const String nearMe = '/near-me';
  static const String peerRequests = '/peer-requests';
  static const String bookmarkedPeers = '/bookmarked-peers';
  static const String createPost = '/create-post';
  static const String notifications = '/notifications';
  static const String membershipPaywall = '/membership-paywall';
  static const String testimonials = '/testimonials';
  static const String peerTestimonials = '/peer-testimonials';
  static const String addTestimonial = '/add-testimonial';
  static const String businessDeals = '/business-deals';
  static const String peerBusinessDeals = '/peer-business-deals';
  static const String addBusinessDeal = '/add-business-deal';
  static const String referrals = '/referrals';
  static const String addReferral = '/add-referral';
  static const String p2pMeetings = '/p2p-meetings';
  static const String addP2pMeeting = '/add-p2p-meeting';
  static const String leaderboard = '/leaderboard';
  static const String impactLeaderboard = '/impact-leaderboard';
  static const String coinGuidelines = '/coin-guidelines';
  static const String impactGuidelines = '/impact-guidelines';

  // Highlights & Services
  static const String vyapaarJagatStory = '/vyapaar-jagat-story';
  static const String leadershipCertificate = '/leadership-certificate';
  static const String entrepreneurCertificate = '/entrepreneur-certificate';
  static const String postAsk = '/post-ask';
  static const String collaborationAsk = '/collaboration-ask';
  static const String collaborations = '/collaborations';
  static const String addCollaboration = '/add-collaboration';
  static const String recommendPeer = '/recommend-peer';
  static const String coins = '/coins';
  static const String claimCoins = '/claim-coins';
  static const String claimYourCoin = '/claim-your-coin';
  static const String welcomeCreative = '/welcome-creative';
  static const String badges = '/badges';
  static const String coinMilestones = '/milestones';
  static const String lifeImpact = '/life-impact';
  static const String impactScore = '/impact-score';
  static const String topCommunityBuilders = '/top-community-builders';
  static const String events = '/events';
  static const String eventDetail = '/event-detail';
  static const String myEvents = '/my-events';
  static const String eventQrTicket = '/event-qr-ticket';
  static const String eventVideos = '/event-videos';
  static const String myNetwork = '/my-network';
  static const String gratitudeScript = '/gratitude-script';
  static const String lastMonthActivity = '/last-month-activity';
  static const String becomeMentor = '/become-mentor';
  static const String becomeSpeaker = '/become-speaker';
  static const String leadershipRole = '/leadership-role';
  static const String tutorials = '/tutorials';
  static const String partnerWithUs = '/partner-with-us';
  static const String registerVisitor = '/register-visitor';
  static const String openRequirements = '/open-requirements';
  static const String openAsks = '/open-asks';
  static const String shorts = '/shorts';
  static const String highlights = '/highlights';

  // Profile Edit Screens
  static const String editProfileOverview = '/edit-profile-overview';
  static const String editPersonalInfo = '/edit-personal-info';
  static const String editBusinessInfo = '/edit-business-info';
  static const String editInterestsGoals = '/edit-interests-goals';
  static const String editSocialLinks = '/edit-social-links';
  static const String editMediaPortfolio = '/edit-media-portfolio';
  static const String editProfessionalJourney = '/edit-professional-journey';
  static const String editCircleMembership = '/edit-circle-membership';
  static const String editAdditionalInfo = '/edit-additional-info';

  // Aliases & Future Feature Routes (Fallback to Home/Parent screen if UI pending)
  static const String connectionRequests = '/peer-requests';
  static const String pendingRequests = '/peer-requests';
  static const String postDetails = '/post-details';

  static const String circles = '/circles';
  static const String circleDetails = '/circle-details';
  static const String circleMembers = '/circle-members';
  static const String circleCategories = '/circle-categories';
  static const String circleSubcategories = '/circle-subcategories';
  static const String circleJoin = '/circle-join';
  static const String joinRequestStatus = '/join-request-status';
  static const String circleChat = '/circle-chat';
  static const String circleLeadershipChat = '/circle-leadership-chat';
  static const String chatList = '/chats';
  static const String directChat = '/direct-chat';
  static const String wallet = '/wallet';
  static const String brandPartnerDetails = '/brand-partner-details';
  static const String circulars = '/circulars';
  static const String supportTicketDetails = '/support-ticket-details';
}

class AppRouter {
  AppRouter._();

  static final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case AppRoutes.verifyOtp:
        String identifier = '';
        String channel = 'email';
        if (settings.arguments is Map<String, dynamic>) {
          final map = settings.arguments as Map<String, dynamic>;
          identifier = (map['identifier'] ?? map['email']) as String? ?? '';
          channel = map['channel'] as String? ?? 'email';
        } else if (settings.arguments is String) {
          identifier = settings.arguments as String;
        }
        return MaterialPageRoute(
          builder: (_) =>
              VerifyOtpScreen(identifier: identifier, channel: channel),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case AppRoutes.peers:
        return MaterialPageRoute(
          builder: (_) => const MyPeersScreen(),
          settings: settings,
        );
      case AppRoutes.connections:
        return MaterialPageRoute(
          builder: (_) => const ConnectionsScreen(),
          settings: settings,
        );
      case AppRoutes.peerRequests:
        return MaterialPageRoute(
          builder: (_) => const PeerRequestsScreen(),
          settings: settings,
        );
      case AppRoutes.nearMe:
        return MaterialPageRoute(
          builder: (_) => const NearMeScreen(),
          settings: settings,
        );
      case AppRoutes.matches:
        return MaterialPageRoute(
          builder: (_) => const MatchesScreen(),
          settings: settings,
        );
      case AppRoutes.bookmarkedPeers:
        return MaterialPageRoute(
          builder: (_) => const BookmarkedPeersScreen(),
          settings: settings,
        );
      case AppRoutes.peerProfile:
        String peerId = '';
        if (settings.arguments is String) {
          peerId = settings.arguments as String;
        } else if (settings.arguments is Map) {
          final map = settings.arguments as Map;
          peerId = (map['memberId'] ?? map['peerId'] ?? map['id'] ?? '').toString();
        } else if (settings.arguments != null) {
          peerId = settings.arguments.toString();
        }
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (ctx) => PeerProfileBloc(
              getMemberProfileUseCase: ctx.read<GetMemberProfileUseCase>(),
              getMemberPostsUseCase: ctx.read<GetMemberPostsUseCase>(),
              getMemberIntroducedPeersUseCase:
                  ctx.read<GetMemberIntroducedPeersUseCase>(),
              followUserUseCase: ctx.read<FollowUserUseCase>(),
              unfollowUserUseCase: ctx.read<UnfollowUserUseCase>(),
              sendConnectionRequestUseCase: ctx
                  .read<SendConnectionRequestUseCase>(),
              cancelSentConnectionRequestUseCase: ctx
                  .read<CancelSentConnectionRequestUseCase>(),
              togglePeerBookmarkUseCase: ctx.read<TogglePeerBookmarkUseCase>(),
              removeConnectionUseCase: ctx.read<RemoveConnectionUseCase>(),
              togglePostLikeUseCase: ctx.read<TogglePostLikeUseCase>(),
              togglePostSaveUseCase: ctx.read<TogglePostSaveUseCase>(),
              blockPeerUseCase: ctx.read<BlockPeerUseCase>(),
              unblockPeerUseCase: ctx.read<UnblockPeerUseCase>(),
              getPeerBlockStatusUseCase: ctx.read<GetPeerBlockStatusUseCase>(),
            ),
            child: PeerProfileScreen(peerId: peerId),
          ),
          settings: settings,
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      case AppRoutes.createPost:
        return MaterialPageRoute(
          builder: (_) => const CreatePostScreen(),
          settings: settings,
        );
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      case AppRoutes.circles:
        return MaterialPageRoute(
          builder: (_) => const CirclesScreen(),
          settings: settings,
        );
      case AppRoutes.circleDetails:
        final circle = settings.arguments as CircleEntity?;
        return MaterialPageRoute(
          builder: (_) => CircleDetailScreen(circle: circle),
          settings: settings,
        );
      case AppRoutes.circleMembers:
        final circle = settings.arguments as CircleEntity;
        return MaterialPageRoute(
          builder: (_) => CircleMembersScreen(circle: circle),
          settings: settings,
        );
      case AppRoutes.circleCategories:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final circle = args['circle'] as CircleEntity?;
        final initialTab = (args['initialTab'] is int)
            ? args['initialTab'] as int
            : 0;
        final preloadedOpen =
            args['openCategories'] as List<CircleOpenCategoryEntity>?;
        final preloadedClosed =
            args['closedCategories'] as List<CircleClosedCategoryEntity>?;
        if (circle != null) {
          return MaterialPageRoute(
            builder: (_) => CircleCategoriesScreen(
              circle: circle,
              initialTabIndex: initialTab,
              preloadedOpen: preloadedOpen,
              preloadedClosed: preloadedClosed,
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
      case AppRoutes.circleSubcategories:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => CircleSubcategoriesScreen(
            circleId: args['circleId']?.toString() ?? '',
            circleName: args['circleName']?.toString() ?? 'Circle',
            isPicker: args['isPicker'] == true,
          ),
          settings: settings,
        );
      case AppRoutes.circleJoin:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => CircleJoinScreen(
            circleId: args['circleId']?.toString() ?? '',
            defaultSectorName: args['defaultSectorName']?.toString(),
            defaultSectorId: args['defaultSectorId']?.toString(),
            preselectedCategory:
                args['preselectedCategory'] as CircleCategoryEntity?,
            isOtherCategory: args['isOtherCategory'] == true,
          ),
          settings: settings,
        );
      case AppRoutes.joinRequestStatus:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return MaterialPageRoute(
          builder: (_) => JoinRequestStatusScreen(
            requestId: args['requestId']?.toString() ?? '',
            circleName: args['circleName']?.toString() ?? 'Circle',
          ),
          settings: settings,
        );
      case AppRoutes.membershipPaywall:
        return MaterialPageRoute(
          builder: (_) => const MembershipPaywallScreen(),
          settings: settings,
        );
      case AppRoutes.testimonials:
        return MaterialPageRoute(
          builder: (_) => const TestimonialsScreen(),
          settings: settings,
        );
      case AppRoutes.peerTestimonials:
        final args = settings.arguments;
        String peerId = '';
        String peerName = 'Peer';
        if (args is String) {
          peerId = args;
        } else if (args is Map) {
          peerId = args['peerId']?.toString() ?? '';
          peerName = args['peerName']?.toString() ?? 'Peer';
        }
        return MaterialPageRoute(
          builder: (_) => PeerTestimonialsScreen(
            peerId: peerId,
            peerName: peerName,
          ),
          settings: settings,
        );
      case AppRoutes.addTestimonial:
        return MaterialPageRoute(
          builder: (_) => const AddTestimonialScreen(),
          settings: settings,
        );
      case AppRoutes.businessDeals:
        return MaterialPageRoute(
          builder: (_) => const BusinessDealsScreen(),
          settings: settings,
        );
      case AppRoutes.peerBusinessDeals:
        final args = settings.arguments;
        String peerId = '';
        String peerName = 'Peer';
        if (args is String) {
          peerId = args;
        } else if (args is Map) {
          peerId = args['peerId']?.toString() ?? '';
          peerName = args['peerName']?.toString() ?? 'Peer';
        }
        return MaterialPageRoute(
          builder: (_) => PeerBusinessDealsScreen(
            peerId: peerId,
            peerName: peerName,
          ),
          settings: settings,
        );
      case AppRoutes.addBusinessDeal:
        return MaterialPageRoute(
          builder: (_) => const AddBusinessDealScreen(),
          settings: settings,
        );
      case AppRoutes.referrals:
        return MaterialPageRoute(
          builder: (_) => const ReferralsScreen(),
          settings: settings,
        );
      case AppRoutes.addReferral:
        return MaterialPageRoute(
          builder: (_) => const AddReferralScreen(),
          settings: settings,
        );
      case AppRoutes.p2pMeetings:
        final initialTab = settings.arguments is int ? settings.arguments as int : 0;
        return MaterialPageRoute(
          builder: (_) => P2pMeetingsScreen(initialTabIndex: initialTab),
          settings: settings,
        );
      case AppRoutes.addP2pMeeting:
        PeerEntity? initialPeer;
        DateTime? initialDate;
        String? initialPlace;
        if (settings.arguments is PeerEntity) {
          initialPeer = settings.arguments as PeerEntity;
        } else if (settings.arguments is Map) {
          final map = settings.arguments as Map;
          initialPeer = map['peer'] as PeerEntity?;
          initialDate = map['date'] as DateTime?;
          initialPlace = map['place'] as String?;
        }
        return MaterialPageRoute(
          builder: (_) => AddP2pMeetingScreen(
            initialPeer: initialPeer,
            initialDate: initialDate,
            initialPlace: initialPlace,
          ),
          settings: settings,
        );
      case AppRoutes.leaderboard:
        return MaterialPageRoute(
          builder: (_) => const LeaderboardScreen(type: LeaderboardType.coins),
          settings: settings,
        );
      case AppRoutes.impactLeaderboard:
        return MaterialPageRoute(
          builder: (_) => const LeaderboardScreen(type: LeaderboardType.impact),
          settings: settings,
        );
      case AppRoutes.coinGuidelines:
        return MaterialPageRoute(
          builder: (_) => const CoinGuidelinesScreen(),
          settings: settings,
        );
      case AppRoutes.impactGuidelines:
        return MaterialPageRoute(
          builder: (_) => const ImpactGuidelinesScreen(),
          settings: settings,
        );
      case AppRoutes.vyapaarJagatStory:
        return MaterialPageRoute(
          builder: (_) => const VyapaarJagatStoryScreen(),
          settings: settings,
        );
      case AppRoutes.leadershipCertificate:
        return MaterialPageRoute(
          builder: (_) => const LeadershipCertificationScreen(),
          settings: settings,
        );
      case AppRoutes.entrepreneurCertificate:
        return MaterialPageRoute(
          builder: (_) => const EntrepreneurCertificationScreen(),
          settings: settings,
        );
      case AppRoutes.postAsk:
        return MaterialPageRoute(
          builder: (_) => const PostAskFormScreen(),
          settings: settings,
        );
      case AppRoutes.collaborationAsk:
        return MaterialPageRoute(
          builder: (_) => const AskFormScreen(),
          settings: settings,
        );
      case AppRoutes.openAsks:
      case AppRoutes.openRequirements:
        final initialTab =
            settings.arguments is int ? settings.arguments as int : 0;
        return MaterialPageRoute(
          builder: (_) => OpenAsksScreen(initialTabIndex: initialTab),
          settings: settings,
        );
      case AppRoutes.collaborations:
        final initialTab = settings.arguments is int ? settings.arguments as int : 0;
        return MaterialPageRoute(
          builder: (_) => CollaborationsHubScreen(initialTabIndex: initialTab),
          settings: settings,
        );
      case AppRoutes.addCollaboration:
        return MaterialPageRoute(
          builder: (_) => const AddCollaborationScreen(),
          settings: settings,
        );
      case AppRoutes.recommendPeer:
        return MaterialPageRoute(
          builder: (_) => const RecommendPeerScreen(),
          settings: settings,
        );
      case AppRoutes.coins:
        return MaterialPageRoute(
          builder: (_) => const CoinsScreen(),
          settings: settings,
        );
      case AppRoutes.claimCoins:
      case AppRoutes.claimYourCoin:
        final initialTab = settings.arguments is int ? settings.arguments as int : 0;
        return MaterialPageRoute(
          builder: (_) => ClaimYourCoinScreen(initialTabIndex: initialTab),
          settings: settings,
        );
      case AppRoutes.welcomeCreative:
        return MaterialPageRoute(
          builder: (_) => const WelcomeCreativeTemplateScreen(),
          settings: settings,
        );
      case AppRoutes.badges:
      case AppRoutes.coinMilestones:
        final userId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => CoinMilestonesScreen(userId: userId),
          settings: settings,
        );
      case AppRoutes.lifeImpact:
      case AppRoutes.impactScore:
        final initialTab = settings.arguments is int ? settings.arguments as int : 0;
        return MaterialPageRoute(
          builder: (_) => LifeImpactScreen(initialTabIndex: initialTab),
          settings: settings,
        );
      case AppRoutes.topCommunityBuilders:
        final initialTab =
            settings.arguments is int ? settings.arguments as int : 0;
        return MaterialPageRoute(
          builder: (_) => TopCommunityBuildersScreen(initialTabIndex: initialTab),
          settings: settings,
        );
      case AppRoutes.events:
        return MaterialPageRoute(
          builder: (_) => const EventsScreen(),
          settings: settings,
        );
      case AppRoutes.eventDetail:
        final event = settings.arguments as EventEntity?;
        if (event != null) {
          return MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const EventsScreen(),
          settings: settings,
        );
      case AppRoutes.myEvents:
        return MaterialPageRoute(
          builder: (_) => const MyEventsScreen(),
          settings: settings,
        );
      case AppRoutes.eventQrTicket:
        EventRegistrationEntity? ticket;
        if (settings.arguments is EventRegistrationEntity) {
          ticket = settings.arguments as EventRegistrationEntity;
        } else if (settings.arguments is UserRegistrationInfo) {
          final u = settings.arguments as UserRegistrationInfo;
          ticket = EventRegistrationEntity(
            registrationId: u.registrationId ?? '',
            eventId: u.eventId,
            occurrenceId: u.occurrenceId,
            qrToken: u.qrToken,
            qrCodeUrl: u.qrCodeUrl,
            status: u.status ?? 'confirmed',
            attendeeName: u.attendeeName,
            startAt: u.startAt,
            location: u.location,
            eventTitle: u.eventTitle,
          );
        } else if (settings.arguments is EventEntity) {
          final e = settings.arguments as EventEntity;
          final u = e.userRegistration;
          ticket = EventRegistrationEntity(
            registrationId: u?.registrationId ?? '',
            eventId: e.eventId,
            occurrenceId: e.occurrenceId,
            qrToken: u?.qrToken,
            qrCodeUrl: u?.qrCodeUrl,
            status: u?.status ?? 'confirmed',
            attendeeName: u?.attendeeName,
            startAt: e.startAt,
            location: e.location,
            eventTitle: e.title,
          );
        }
        if (ticket != null) {
          return MaterialPageRoute(
            builder: (_) => EventQrTicketScreen(ticket: ticket!),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const MyEventsScreen(),
          settings: settings,
        );
      case AppRoutes.eventVideos:
        return MaterialPageRoute(
          builder: (_) => const EventVideosScreen(),
          settings: settings,
        );
      case AppRoutes.myNetwork:
        return MaterialPageRoute(
          builder: (_) => const MyNetworkScreen(),
          settings: settings,
        );
      case AppRoutes.gratitudeScript:
        return MaterialPageRoute(
          builder: (_) => const GratitudeScriptScreen(),
          settings: settings,
        );
      case AppRoutes.lastMonthActivity:
        return MaterialPageRoute(
          builder: (_) => const LastMonthActivityScreen(),
          settings: settings,
        );
      case AppRoutes.becomeMentor:
        return MaterialPageRoute(
          builder: (_) => const BecomeMentorScreen(),
          settings: settings,
        );
      case AppRoutes.becomeSpeaker:
        return MaterialPageRoute(
          builder: (_) => const BecomeSpeakerScreen(),
          settings: settings,
        );
      case AppRoutes.leadershipRole:
        return MaterialPageRoute(
          builder: (_) => const LeadershipRoleScreen(),
          settings: settings,
        );
      case AppRoutes.tutorials:
        return MaterialPageRoute(
          builder: (_) => const TutorialsScreen(),
          settings: settings,
        );
      case AppRoutes.circulars:
        return MaterialPageRoute(
          builder: (_) => const CircularsScreen(),
          settings: settings,
        );
      case AppRoutes.partnerWithUs:
        return MaterialPageRoute(
          builder: (_) => const PartnerWithUsScreen(),
          settings: settings,
        );
      case AppRoutes.registerVisitor:
        return MaterialPageRoute(
          builder: (_) => const RegisterVisitorScreen(),
          settings: settings,
        );
      case AppRoutes.shorts:
        return MaterialPageRoute(
          builder: (_) => const ShortsScreen(showBackButton: true),
          settings: settings,
        );
      case AppRoutes.highlights:
        return MaterialPageRoute(
          builder: (_) => const HighlightsScreen(),
          settings: settings,
        );
      case AppRoutes.editProfileOverview:
        return MaterialPageRoute(
          builder: (_) => const EditProfileOverviewScreen(),
          settings: settings,
        );
      case AppRoutes.editPersonalInfo:
        return MaterialPageRoute(
          builder: (ctx) {
            final profile = settings.arguments as ProfileEntity? ??
                ctx.read<ProfileBloc>().state.profile;
            if (profile != null) return EditPersonalInfoScreen(profile: profile);
            return const EditProfileOverviewScreen();
          },
          settings: settings,
        );
      case AppRoutes.editBusinessInfo:
        return MaterialPageRoute(
          builder: (ctx) {
            final profile = settings.arguments as ProfileEntity? ??
                ctx.read<ProfileBloc>().state.profile;
            if (profile != null) return EditBusinessInfoScreen(profile: profile);
            return const EditProfileOverviewScreen();
          },
          settings: settings,
        );
      case AppRoutes.editInterestsGoals:
        return MaterialPageRoute(
          builder: (ctx) {
            final profile = settings.arguments as ProfileEntity? ??
                ctx.read<ProfileBloc>().state.profile;
            if (profile != null) return EditInterestsGoalsScreen(profile: profile);
            return const EditProfileOverviewScreen();
          },
          settings: settings,
        );
      case AppRoutes.editSocialLinks:
        return MaterialPageRoute(
          builder: (ctx) {
            final profile = settings.arguments as ProfileEntity? ??
                ctx.read<ProfileBloc>().state.profile;
            if (profile != null) return EditSocialLinksScreen(profile: profile);
            return const EditProfileOverviewScreen();
          },
          settings: settings,
        );
      case AppRoutes.editMediaPortfolio:
        return MaterialPageRoute(
          builder: (ctx) {
            final profile = settings.arguments as ProfileEntity? ??
                ctx.read<ProfileBloc>().state.profile;
            if (profile != null) return EditMediaPortfolioScreen(profile: profile);
            return const EditProfileOverviewScreen();
          },
          settings: settings,
        );
      case AppRoutes.editProfessionalJourney:
        return MaterialPageRoute(
          builder: (ctx) {
            final profile = settings.arguments as ProfileEntity? ??
                ctx.read<ProfileBloc>().state.profile;
            if (profile != null) return EditProfessionalJourneyScreen(profile: profile);
            return const EditProfileOverviewScreen();
          },
          settings: settings,
        );
      case AppRoutes.editCircleMembership:
        return MaterialPageRoute(
          builder: (ctx) {
            final profile = settings.arguments as ProfileEntity? ??
                ctx.read<ProfileBloc>().state.profile;
            if (profile != null) return EditCircleMembershipScreen(profile: profile);
            return const EditProfileOverviewScreen();
          },
          settings: settings,
        );
      case AppRoutes.editAdditionalInfo:
        return MaterialPageRoute(
          builder: (ctx) {
            final profile = settings.arguments as ProfileEntity? ??
                ctx.read<ProfileBloc>().state.profile;
            if (profile != null) return EditAdditionalInfoScreen(profile: profile);
            return const EditProfileOverviewScreen();
          },
          settings: settings,
        );
      case AppRoutes.chatList:
        return MaterialPageRoute(
          builder: (_) => const ChatHubScreen(),
          settings: settings,
        );
      case AppRoutes.directChat:
        String? chatId;
        String? peerUserId;
        String? peerName;
        String? peerAvatar;
        if (settings.arguments is String) {
          chatId = settings.arguments as String;
        } else if (settings.arguments is Map) {
          final args = settings.arguments as Map;
          chatId = args['chat_id']?.toString();
          peerUserId = args['peer_id']?.toString() ?? args['user_id']?.toString();
          peerName = args['peer_name']?.toString() ?? args['user_name']?.toString();
          peerAvatar = args['peer_avatar']?.toString() ?? args['avatar_url']?.toString();
        } else if (settings.arguments is PeerEntity) {
          final p = settings.arguments as PeerEntity;
          peerUserId = p.id;
          peerName = p.displayName;
          peerAvatar = p.profilePhotoUrl;
        }
        return MaterialPageRoute(
          builder: (_) => DirectChatScreen(
            chatId: chatId,
            peerUserId: peerUserId,
            peerName: peerName,
            peerAvatar: peerAvatar,
          ),
          settings: settings,
        );
      case AppRoutes.circleChat:
        String circleId = '';
        String? circleName;
        if (settings.arguments is String) {
          circleId = settings.arguments as String;
        } else if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          circleId = (args['circle_id'] ?? '').toString();
          circleName = args['circle_name']?.toString();
        }
        return MaterialPageRoute(
          builder: (_) => CircleChatScreen(
            circleId: circleId,
            circleName: circleName,
          ),
          settings: settings,
        );
      case AppRoutes.circleLeadershipChat:
        String circleId = '';
        String? circleName;
        if (settings.arguments is String) {
          circleId = settings.arguments as String;
        } else if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          circleId = (args['circle_id'] ?? '').toString();
          circleName = args['circle_name']?.toString();
        }
        return MaterialPageRoute(
          builder: (_) => CircleLeadershipChatScreen(
            circleId: circleId,
            circleName: circleName,
          ),
          settings: settings,
        );
      case AppRoutes.brandPartnerDetails:
        if (settings.arguments is BrandPartnerEntity) {
          return MaterialPageRoute(
            builder: (_) => BrandPartnerDetailsScreen(
              partner: settings.arguments as BrandPartnerEntity,
            ),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
    }
  }
}
