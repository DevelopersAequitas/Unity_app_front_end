import 'package:flutter/material.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../features/home/presentation/screens/create_post_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/peers/presentation/screens/connections_screen.dart';
import '../../features/peers/presentation/screens/matches_screen.dart';
import '../../features/peers/presentation/screens/my_peers_screen.dart';
import '../../features/peers/presentation/screens/near_me_screen.dart';
import '../../features/peers/presentation/screens/peer_requests_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/home/domain/usecases/toggle_post_like_usecase.dart';
import '../../features/home/domain/usecases/toggle_post_save_usecase.dart';
import '../../features/peers/domain/usecases/cancel_sent_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/follow_user_usecase.dart';
import '../../features/peers/domain/usecases/get_member_posts_usecase.dart';
import '../../features/peers/domain/usecases/get_member_profile_usecase.dart';
import '../../features/peers/domain/usecases/remove_connection_usecase.dart';
import '../../features/peers/domain/usecases/send_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../features/peers/domain/usecases/unfollow_user_usecase.dart';
import '../../features/peers/presentation/bloc/peer_profile_bloc.dart';
import '../../features/peers/presentation/screens/peer_profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
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
  static const String wallet = '/wallet';
  static const String brandPartnerDetails = '/brand-partner-details';
  static const String lifeImpact = '/life-impact';
  static const String circulars = '/circulars';
  static const String supportTicketDetails = '/support-ticket-details';
}

class AppRouter {
  AppRouter._();

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
        String email = '';
        String channel = 'email';
        if (settings.arguments is Map<String, dynamic>) {
          final map = settings.arguments as Map<String, dynamic>;
          email = map['email'] as String? ?? '';
          channel = map['channel'] as String? ?? 'email';
        } else if (settings.arguments is String) {
          email = settings.arguments as String;
        }
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(email: email, channel: channel),
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
        } else if (settings.arguments is Map<String, dynamic>) {
          final map = settings.arguments as Map<String, dynamic>;
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
      case AppRoutes.lifeImpact:
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
      default:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
    }
  }
}
