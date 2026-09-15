import 'package:lottie/lottie.dart';
import 'package:unity_app/features/circles/domain/usecases/cancel_circle_join_request_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_category_subcategories_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_closed_categories_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_join_request_status_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_members_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_open_categories_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_my_join_requests_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/submit_circle_join_usecase.dart';
import '../../features/highlights/data/datasources/highlights_local_datasource.dart';
import '../../features/highlights/data/repositories_impl/highlights_repository_impl.dart';
import '../../features/highlights/domain/repositories/highlights_repository.dart';
import '../../features/highlights/domain/usecases/get_highlight_sections_usecase.dart';

import '../../core/cache/hive_cache_store.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/contacts_sync_service.dart';
import '../../core/services/deep_link_service.dart';
import '../../core/services/location_sync_service.dart';
import '../../core/services/network_connectivity_service.dart';
import '../../core/services/peers_realtime_sync_service.dart';
import '../../core/services/user_presence_service.dart';
import '../../features/membership/data/datasources/membership_remote_datasource.dart';
import '../../features/membership/data/repositories_impl/membership_repository_impl.dart';
import '../../features/membership/domain/repositories/membership_repository.dart';
import '../../features/membership/domain/usecases/get_membership_plans_usecase.dart';
import '../../features/membership/domain/usecases/get_subscription_history_usecase.dart';
import '../../features/membership/domain/usecases/initiate_plan_checkout_usecase.dart';
import '../../features/membership/domain/usecases/verify_checkout_status_usecase.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/clear_registration_draft_usecase.dart';
import '../../features/auth/domain/usecases/get_cached_auth_usecase.dart';
import '../../features/auth/domain/usecases/get_main_categories_usecase.dart';
import '../../features/auth/domain/usecases/get_registration_draft_usecase.dart';
import '../../features/auth/domain/usecases/get_subcategories_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/request_otp_usecase.dart';
import '../../features/auth/domain/usecases/save_registration_draft_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/home/data/datasources/home_local_datasource.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories_impl/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/add_post_comment_usecase.dart';
import '../../features/home/domain/usecases/create_post_usecase.dart';
import '../../features/home/domain/usecases/delete_post_usecase.dart';
import '../../features/home/domain/usecases/get_brand_partners_usecase.dart';
import '../../features/home/domain/usecases/get_cached_brand_partners_usecase.dart';
import '../../features/home/domain/usecases/get_cached_timeline_feed_usecase.dart';
import '../../features/home/domain/usecases/get_post_comments_usecase.dart';
import '../../features/home/domain/usecases/get_post_likes_usecase.dart';
import '../../features/home/domain/usecases/get_timeline_feed_usecase.dart';
import '../../features/home/domain/usecases/toggle_post_like_usecase.dart';
import '../../features/home/domain/usecases/toggle_post_save_usecase.dart';
import '../../features/home/domain/usecases/update_post_usecase.dart';
import '../../features/peers/data/datasources/peers_local_datasource.dart';
import '../../features/peers/data/datasources/peers_remote_datasource.dart';
import '../../features/peers/data/repositories_impl/peers_repository_impl.dart';
import '../../features/peers/domain/repositories/peers_repository.dart';
import '../../features/peers/domain/usecases/accept_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/cancel_sent_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/decline_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/follow_user_usecase.dart';
import '../../features/peers/domain/usecases/get_all_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_connection_requests_usecase.dart';
import '../../features/peers/domain/usecases/get_match_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_member_posts_usecase.dart';
import '../../features/peers/domain/usecases/get_member_profile_usecase.dart';
import '../../features/peers/domain/usecases/get_my_connections_usecase.dart';
import '../../features/peers/domain/usecases/get_nearby_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_sent_connection_requests_usecase.dart';
import '../../features/peers/domain/usecases/remove_connection_usecase.dart';
import '../../features/peers/domain/usecases/send_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../features/peers/domain/usecases/unfollow_user_usecase.dart';
import '../../features/profile/data/datasources/profile_local_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories_impl/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/get_saved_posts_usecase.dart';
import '../../features/profile/domain/usecases/get_user_posts_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/domain/usecases/upload_file_usecase.dart';
import '../../features/notifications/data/datasources/notifications_local_datasource.dart';
import '../../features/notifications/data/datasources/notifications_remote_datasource.dart';
import '../../features/notifications/data/repositories_impl/notifications_repository_impl.dart';
import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/domain/usecases/get_cached_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../../features/circles/data/datasources/circles_local_datasource.dart';
import '../../features/circles/data/datasources/circles_remote_datasource.dart';
import '../../features/circles/data/repositories_impl/circles_repository_impl.dart';
import '../../features/circles/domain/repositories/circles_repository.dart';
import '../../features/circles/domain/usecases/get_cached_circles_usecase.dart';
import '../../features/circles/domain/usecases/get_circle_categories_usecase.dart';
import '../../features/circles/domain/usecases/get_circle_detail_usecase.dart';
import '../../features/circles/domain/usecases/get_my_circles_usecase.dart';

class AppDependencies {
  // Core
  final HiveCacheStore cacheStore;
  final DioClient dioClient;

  // Repositories
  final AuthRepository authRepository;
  final HomeRepository homeRepository;
  final PeersRepository peersRepository;
  final ProfileRepository profileRepository;
  final NotificationsRepository notificationsRepository;
  final CirclesRepository circlesRepository;
  final HighlightsRepository highlightsRepository;
  final MembershipRepository membershipRepository;

  // Highlights UseCases
  final GetHighlightSectionsUseCase getHighlightSectionsUseCase;

  // Membership UseCases
  final GetMembershipPlansUseCase getMembershipPlansUseCase;
  final InitiatePlanCheckoutUseCase initiatePlanCheckoutUseCase;
  final VerifyCheckoutStatusUseCase verifyCheckoutStatusUseCase;
  final GetSubscriptionHistoryUseCase getSubscriptionHistoryUseCase;

  // Circles UseCases
  final GetMyCirclesUseCase getMyCirclesUseCase;
  final GetCircleCategoriesUseCase getCircleCategoriesUseCase;
  final GetCircleDetailUseCase getCircleDetailUseCase;
  final GetCachedCirclesUseCase getCachedCirclesUseCase;
  final GetCircleMembersUseCase getCircleMembersUseCase;
  final GetCategorySubcategoriesUseCase getCategorySubcategoriesUseCase;
  final GetCircleOpenCategoriesUseCase getCircleOpenCategoriesUseCase;
  final GetCircleClosedCategoriesUseCase getCircleClosedCategoriesUseCase;
  final SubmitCircleJoinUseCase submitCircleJoinUseCase;
  final GetMyJoinRequestsUseCase getMyJoinRequestsUseCase;
  final GetCircleJoinRequestStatusUseCase getCircleJoinRequestStatusUseCase;
  final CancelCircleJoinRequestUseCase cancelCircleJoinRequestUseCase;


  // Notifications UseCases
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final MarkAllNotificationsReadUseCase markAllNotificationsReadUseCase;
  final GetCachedNotificationsUseCase getCachedNotificationsUseCase;

  // Auth UseCases
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final GetCachedAuthUseCase getCachedAuthUseCase;
  final RegisterUseCase registerUseCase;
  final GetMainCategoriesUseCase getMainCategoriesUseCase;
  final GetSubcategoriesUseCase getSubcategoriesUseCase;
  final SaveRegistrationDraftUseCase saveRegistrationDraftUseCase;
  final GetRegistrationDraftUseCase getRegistrationDraftUseCase;
  final ClearRegistrationDraftUseCase clearRegistrationDraftUseCase;

  // Home UseCases
  final GetTimelineFeedUseCase getTimelineFeedUseCase;
  final GetBrandPartnersUseCase getBrandPartnersUseCase;
  final GetCachedTimelineFeedUseCase getCachedTimelineFeedUseCase;
  final GetCachedBrandPartnersUseCase getCachedBrandPartnersUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final TogglePostSaveUseCase togglePostSaveUseCase;
  final GetPostLikesUseCase getPostLikesUseCase;
  final GetPostCommentsUseCase getPostCommentsUseCase;
  final AddPostCommentUseCase addPostCommentUseCase;
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final UpdatePostUseCase updatePostUseCase;

  // Peers UseCases
  final GetAllPeersUseCase getAllPeersUseCase;
  final GetMyConnectionsUseCase getMyConnectionsUseCase;
  final GetConnectionRequestsUseCase getConnectionRequestsUseCase;
  final GetSentConnectionRequestsUseCase getSentConnectionRequestsUseCase;
  final GetNearbyPeersUseCase getNearbyPeersUseCase;
  final GetMatchPeersUseCase getMatchPeersUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;
  final AcceptConnectionRequestUseCase acceptConnectionRequestUseCase;
  final DeclineConnectionRequestUseCase declineConnectionRequestUseCase;
  final CancelSentConnectionRequestUseCase cancelSentConnectionRequestUseCase;
  final TogglePeerBookmarkUseCase togglePeerBookmarkUseCase;
  final GetMemberProfileUseCase getMemberProfileUseCase;
  final GetMemberPostsUseCase getMemberPostsUseCase;
  final FollowUserUseCase followUserUseCase;
  final UnfollowUserUseCase unfollowUserUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;

  // Profile UseCases
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetUserPostsUseCase getUserPostsUseCase;
  final GetSavedPostsUseCase getSavedPostsUseCase;
  final UploadProfileMediaUseCase uploadProfileMediaUseCase;

  AppDependencies({
    required this.cacheStore,
    required this.dioClient,
    required this.authRepository,
    required this.homeRepository,
    required this.peersRepository,
    required this.profileRepository,
    required this.notificationsRepository,
    required this.circlesRepository,
    required this.membershipRepository,
    required this.getMembershipPlansUseCase,
    required this.initiatePlanCheckoutUseCase,
    required this.verifyCheckoutStatusUseCase,
    required this.getSubscriptionHistoryUseCase,
    required this.getMyCirclesUseCase,
    required this.getCircleCategoriesUseCase,
    required this.getCircleDetailUseCase,
    required this.getCachedCirclesUseCase,
    required this.getCircleMembersUseCase,
    required this.getCategorySubcategoriesUseCase,
    required this.getCircleOpenCategoriesUseCase,
    required this.getCircleClosedCategoriesUseCase,
    required this.submitCircleJoinUseCase,
    required this.getMyJoinRequestsUseCase,
    required this.getCircleJoinRequestStatusUseCase,
    required this.cancelCircleJoinRequestUseCase,
    required this.getNotificationsUseCase,

    required this.markNotificationReadUseCase,
    required this.markAllNotificationsReadUseCase,
    required this.getCachedNotificationsUseCase,
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.getCachedAuthUseCase,
    required this.registerUseCase,
    required this.getMainCategoriesUseCase,
    required this.getSubcategoriesUseCase,
    required this.saveRegistrationDraftUseCase,
    required this.getRegistrationDraftUseCase,
    required this.clearRegistrationDraftUseCase,
    required this.getTimelineFeedUseCase,
    required this.getBrandPartnersUseCase,
    required this.getCachedTimelineFeedUseCase,
    required this.getCachedBrandPartnersUseCase,
    required this.togglePostLikeUseCase,
    required this.togglePostSaveUseCase,
    required this.getPostLikesUseCase,
    required this.getPostCommentsUseCase,
    required this.addPostCommentUseCase,
    required this.createPostUseCase,
    required this.deletePostUseCase,
    required this.updatePostUseCase,
    required this.getAllPeersUseCase,
    required this.getMyConnectionsUseCase,
    required this.getConnectionRequestsUseCase,
    required this.getSentConnectionRequestsUseCase,
    required this.getNearbyPeersUseCase,
    required this.getMatchPeersUseCase,
    required this.sendConnectionRequestUseCase,
    required this.acceptConnectionRequestUseCase,
    required this.declineConnectionRequestUseCase,
    required this.cancelSentConnectionRequestUseCase,
    required this.togglePeerBookmarkUseCase,
    required this.getMemberProfileUseCase,
    required this.getMemberPostsUseCase,
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
    required this.removeConnectionUseCase,
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.getUserPostsUseCase,
    required this.getSavedPostsUseCase,
    required this.uploadProfileMediaUseCase,
    required this.highlightsRepository,
    required this.getHighlightSectionsUseCase,
  });

  static Future<AppDependencies> initialize() async {
    // Initialize deep linking service and network connectivity listener
    await Future.wait([
      DeepLinkService.instance.init(),
      NetworkConnectivityService.instance.init(),
    ]);

    // Initialize offline cache store and pre-load splash animation concurrently
    final cacheStore = HiveCacheStore();
    await Future.wait([
      cacheStore.init(),
      AssetLottie('assets/animationes/splash.json').load(),
    ]);

    // Network Client
    final dioClient = DioClient(cacheStore: cacheStore);

    // Contacts Sync Service
    ContactsSyncService.instance.init(
      dioClient: dioClient,
      cacheStore: cacheStore,
    );

    // Auth Data Sources & Repositories
    final authRemoteDataSource = AuthRemoteDataSourceImpl(dioClient: dioClient);
    final authLocalDataSource = AuthLocalDataSourceImpl(cacheStore: cacheStore);
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
    );

    // Home Data Sources & Repositories
    final homeRemoteDataSource = HomeRemoteDataSourceImpl(dioClient: dioClient);
    final homeLocalDataSource = HomeLocalDataSourceImpl(cacheStore: cacheStore);
    final homeRepository = HomeRepositoryImpl(
      remoteDataSource: homeRemoteDataSource,
      localDataSource: homeLocalDataSource,
    );

    // Peers Data Sources & Repositories
    final peersRemoteDataSource = PeersRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final peersLocalDataSource = PeersLocalDataSourceImpl(
      cacheStore: cacheStore,
    );
    final peersRepository = PeersRepositoryImpl(
      remoteDataSource: peersRemoteDataSource,
      localDataSource: peersLocalDataSource,
    );

    // Profile Data Sources & Repositories
    final profileRemoteDataSource = ProfileRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final profileLocalDataSource = ProfileLocalDataSourceImpl(
      cacheStore: cacheStore,
    );
    final profileRepository = ProfileRepositoryImpl(
      remoteDataSource: profileRemoteDataSource,
      localDataSource: profileLocalDataSource,
    );

    // Notifications Data Sources & Repositories
    final notificationsRemoteDataSource = NotificationsRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final notificationsLocalDataSource = NotificationsLocalDataSourceImpl(
      cacheStore: cacheStore,
    );
    final notificationsRepository = NotificationsRepositoryImpl(
      remoteDataSource: notificationsRemoteDataSource,
      localDataSource: notificationsLocalDataSource,
    );

    // Circles Data Sources & Repositories
    final circlesRemoteDataSource = CirclesRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final circlesLocalDataSource = CirclesLocalDataSourceImpl(
      cacheStore: cacheStore,
    );
    final circlesRepository = CirclesRepositoryImpl(
      remoteDataSource: circlesRemoteDataSource,
      localDataSource: circlesLocalDataSource,
    );

    // Circles UseCases
    final getMyCirclesUseCase = GetMyCirclesUseCase(circlesRepository);
    final getCircleCategoriesUseCase = GetCircleCategoriesUseCase(
      circlesRepository,
    );
    final getCircleDetailUseCase = GetCircleDetailUseCase(circlesRepository);
    final getCachedCirclesUseCase = GetCachedCirclesUseCase(circlesRepository);
    final getCircleMembersUseCase = GetCircleMembersUseCase(circlesRepository);
    final getCategorySubcategoriesUseCase = GetCategorySubcategoriesUseCase(
      circlesRepository,
    );
    final getCircleOpenCategoriesUseCase = GetCircleOpenCategoriesUseCase(
      circlesRepository,
    );
    final getCircleClosedCategoriesUseCase = GetCircleClosedCategoriesUseCase(
      circlesRepository,
    );
    final submitCircleJoinUseCase = SubmitCircleJoinUseCase(circlesRepository);
    final getMyJoinRequestsUseCase = GetMyJoinRequestsUseCase(
      circlesRepository,
    );
    final getCircleJoinRequestStatusUseCase = GetCircleJoinRequestStatusUseCase(
      circlesRepository,
    );
    final cancelCircleJoinRequestUseCase = CancelCircleJoinRequestUseCase(
      circlesRepository,
    );

    // Highlights Data Sources & Repositories
    final highlightsLocalDataSource = HighlightsLocalDataSourceImpl();
    final highlightsRepository = HighlightsRepositoryImpl(highlightsLocalDataSource);
    final getHighlightSectionsUseCase = GetHighlightSectionsUseCase(highlightsRepository);

    // Membership Data Sources & Repositories
    final membershipRemoteDataSource = MembershipRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final membershipRepository = MembershipRepositoryImpl(
      remoteDataSource: membershipRemoteDataSource,
    );
    final getMembershipPlansUseCase = GetMembershipPlansUseCase(
      membershipRepository,
    );
    final initiatePlanCheckoutUseCase = InitiatePlanCheckoutUseCase(
      membershipRepository,
    );
    final verifyCheckoutStatusUseCase = VerifyCheckoutStatusUseCase(
      membershipRepository,
    );
    final getSubscriptionHistoryUseCase = GetSubscriptionHistoryUseCase(
      membershipRepository,
    );

    // Notifications UseCases
    final getNotificationsUseCase = GetNotificationsUseCase(
      notificationsRepository,
    );
    final markNotificationReadUseCase = MarkNotificationReadUseCase(
      notificationsRepository,
    );
    final markAllNotificationsReadUseCase = MarkAllNotificationsReadUseCase(
      notificationsRepository,
    );
    final getCachedNotificationsUseCase = GetCachedNotificationsUseCase(
      notificationsRepository,
    );

    // Auth UseCases
    final requestOtpUseCase = RequestOtpUseCase(authRepository);
    final verifyOtpUseCase = VerifyOtpUseCase(authRepository);
    final getCachedAuthUseCase = GetCachedAuthUseCase(authRepository);
    final registerUseCase = RegisterUseCase(authRepository);
    final getMainCategoriesUseCase = GetMainCategoriesUseCase(authRepository);
    final getSubcategoriesUseCase = GetSubcategoriesUseCase(authRepository);
    final saveRegistrationDraftUseCase = SaveRegistrationDraftUseCase(
      authRepository,
    );
    final getRegistrationDraftUseCase = GetRegistrationDraftUseCase(
      authRepository,
    );
    final clearRegistrationDraftUseCase = ClearRegistrationDraftUseCase(
      authRepository,
    );

    // Home UseCases
    final getTimelineFeedUseCase = GetTimelineFeedUseCase(homeRepository);
    final getBrandPartnersUseCase = GetBrandPartnersUseCase(homeRepository);
    final getCachedTimelineFeedUseCase = GetCachedTimelineFeedUseCase(
      homeRepository,
    );
    final getCachedBrandPartnersUseCase = GetCachedBrandPartnersUseCase(
      homeRepository,
    );
    final togglePostLikeUseCase = TogglePostLikeUseCase(homeRepository);
    final togglePostSaveUseCase = TogglePostSaveUseCase(homeRepository);
    final getPostLikesUseCase = GetPostLikesUseCase(homeRepository);
    final getPostCommentsUseCase = GetPostCommentsUseCase(homeRepository);
    final addPostCommentUseCase = AddPostCommentUseCase(homeRepository);
    final createPostUseCase = CreatePostUseCase(homeRepository);
    final deletePostUseCase = DeletePostUseCase(homeRepository);
    final updatePostUseCase = UpdatePostUseCase(homeRepository);

    // Peers UseCases
    final getAllPeersUseCase = GetAllPeersUseCase(peersRepository);
    final getMyConnectionsUseCase = GetMyConnectionsUseCase(peersRepository);
    final getConnectionRequestsUseCase = GetConnectionRequestsUseCase(
      peersRepository,
    );
    final getSentConnectionRequestsUseCase = GetSentConnectionRequestsUseCase(
      peersRepository,
    );
    final getNearbyPeersUseCase = GetNearbyPeersUseCase(peersRepository);
    final getMatchPeersUseCase = GetMatchPeersUseCase(peersRepository);
    final sendConnectionRequestUseCase = SendConnectionRequestUseCase(
      peersRepository,
    );
    final acceptConnectionRequestUseCase = AcceptConnectionRequestUseCase(
      peersRepository,
    );
    final declineConnectionRequestUseCase = DeclineConnectionRequestUseCase(
      peersRepository,
    );
    final cancelSentConnectionRequestUseCase =
        CancelSentConnectionRequestUseCase(peersRepository);
    final togglePeerBookmarkUseCase = TogglePeerBookmarkUseCase(
      peersRepository,
    );
    final getMemberProfileUseCase = GetMemberProfileUseCase(peersRepository);
    final getMemberPostsUseCase = GetMemberPostsUseCase(peersRepository);
    final followUserUseCase = FollowUserUseCase(peersRepository);
    final unfollowUserUseCase = UnfollowUserUseCase(peersRepository);
    final removeConnectionUseCase = RemoveConnectionUseCase(peersRepository);

    // Profile UseCases
    final getProfileUseCase = GetProfileUseCase(profileRepository);
    final updateProfileUseCase = UpdateProfileUseCase(profileRepository);
    final getUserPostsUseCase = GetUserPostsUseCase(profileRepository);
    final getSavedPostsUseCase = GetSavedPostsUseCase(profileRepository);
    final uploadProfileMediaUseCase = UploadProfileMediaUseCase(
      profileRepository,
    );

    // Realtime Sync Service for Connection Requests & Peers
    PeersRealtimeSyncService.instance.init(
      getConnectionRequestsUseCase: getConnectionRequestsUseCase,
      getMyConnectionsUseCase: getMyConnectionsUseCase,
    );

    // Location & Presence Sync Services
    LocationSyncService.instance.init(
      dioClient: dioClient,
      authLocalDataSource: authLocalDataSource,
    );
    UserPresenceService.instance.init(
      dioClient: dioClient,
      authLocalDataSource: authLocalDataSource,
    );
    // Non-blocking location check on startup if permission is active
    LocationSyncService.instance.syncLocationIfPermitted();

    return AppDependencies(
      cacheStore: cacheStore,
      dioClient: dioClient,
      authRepository: authRepository,
      homeRepository: homeRepository,
      peersRepository: peersRepository,
      profileRepository: profileRepository,
      notificationsRepository: notificationsRepository,
      circlesRepository: circlesRepository,
      getMyCirclesUseCase: getMyCirclesUseCase,
      getCircleCategoriesUseCase: getCircleCategoriesUseCase,
      getCircleDetailUseCase: getCircleDetailUseCase,
      getCachedCirclesUseCase: getCachedCirclesUseCase,
      getCircleMembersUseCase: getCircleMembersUseCase,
      getCategorySubcategoriesUseCase: getCategorySubcategoriesUseCase,
      getCircleOpenCategoriesUseCase: getCircleOpenCategoriesUseCase,
      getCircleClosedCategoriesUseCase: getCircleClosedCategoriesUseCase,
      submitCircleJoinUseCase: submitCircleJoinUseCase,
      getMyJoinRequestsUseCase: getMyJoinRequestsUseCase,
      getNotificationsUseCase: getNotificationsUseCase,

      markNotificationReadUseCase: markNotificationReadUseCase,
      markAllNotificationsReadUseCase: markAllNotificationsReadUseCase,
      getCachedNotificationsUseCase: getCachedNotificationsUseCase,
      requestOtpUseCase: requestOtpUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      getCachedAuthUseCase: getCachedAuthUseCase,
      registerUseCase: registerUseCase,
      getMainCategoriesUseCase: getMainCategoriesUseCase,
      getSubcategoriesUseCase: getSubcategoriesUseCase,
      saveRegistrationDraftUseCase: saveRegistrationDraftUseCase,
      getRegistrationDraftUseCase: getRegistrationDraftUseCase,
      clearRegistrationDraftUseCase: clearRegistrationDraftUseCase,
      getTimelineFeedUseCase: getTimelineFeedUseCase,
      getBrandPartnersUseCase: getBrandPartnersUseCase,
      getCachedTimelineFeedUseCase: getCachedTimelineFeedUseCase,
      getCachedBrandPartnersUseCase: getCachedBrandPartnersUseCase,
      togglePostLikeUseCase: togglePostLikeUseCase,
      togglePostSaveUseCase: togglePostSaveUseCase,
      getPostLikesUseCase: getPostLikesUseCase,
      getPostCommentsUseCase: getPostCommentsUseCase,
      addPostCommentUseCase: addPostCommentUseCase,
      createPostUseCase: createPostUseCase,
      deletePostUseCase: deletePostUseCase,
      updatePostUseCase: updatePostUseCase,
      getAllPeersUseCase: getAllPeersUseCase,
      getMyConnectionsUseCase: getMyConnectionsUseCase,
      getConnectionRequestsUseCase: getConnectionRequestsUseCase,
      getSentConnectionRequestsUseCase: getSentConnectionRequestsUseCase,
      getNearbyPeersUseCase: getNearbyPeersUseCase,
      getMatchPeersUseCase: getMatchPeersUseCase,
      sendConnectionRequestUseCase: sendConnectionRequestUseCase,
      acceptConnectionRequestUseCase: acceptConnectionRequestUseCase,
      declineConnectionRequestUseCase: declineConnectionRequestUseCase,
      cancelSentConnectionRequestUseCase: cancelSentConnectionRequestUseCase,
      togglePeerBookmarkUseCase: togglePeerBookmarkUseCase,
      getMemberProfileUseCase: getMemberProfileUseCase,
      getMemberPostsUseCase: getMemberPostsUseCase,
      followUserUseCase: followUserUseCase,
      unfollowUserUseCase: unfollowUserUseCase,
      removeConnectionUseCase: removeConnectionUseCase,
      getProfileUseCase: getProfileUseCase,
      updateProfileUseCase: updateProfileUseCase,
      getUserPostsUseCase: getUserPostsUseCase,
      getSavedPostsUseCase: getSavedPostsUseCase,
      uploadProfileMediaUseCase: uploadProfileMediaUseCase,
      highlightsRepository: highlightsRepository,
      getHighlightSectionsUseCase: getHighlightSectionsUseCase,
      membershipRepository: membershipRepository,
      getMembershipPlansUseCase: getMembershipPlansUseCase,
      initiatePlanCheckoutUseCase: initiatePlanCheckoutUseCase,
      verifyCheckoutStatusUseCase: verifyCheckoutStatusUseCase,
      getSubscriptionHistoryUseCase: getSubscriptionHistoryUseCase,
      getCircleJoinRequestStatusUseCase: getCircleJoinRequestStatusUseCase,
      cancelCircleJoinRequestUseCase: cancelCircleJoinRequestUseCase,
    );
  }
}
