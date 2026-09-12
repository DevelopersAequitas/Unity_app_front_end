import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:unity_app/features/profile/presentation/bloc/profile_event.dart';
import 'core/cache/hive_cache_store.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'core/services/contacts_sync_service.dart';
import 'core/services/peers_realtime_sync_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'features/auth/domain/usecases/clear_registration_draft_usecase.dart';
import 'features/auth/domain/usecases/get_cached_auth_usecase.dart';
import 'features/auth/domain/usecases/get_main_categories_usecase.dart';
import 'features/auth/domain/usecases/get_registration_draft_usecase.dart';
import 'features/auth/domain/usecases/get_subcategories_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/request_otp_usecase.dart';
import 'features/auth/domain/usecases/save_registration_draft_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/register_bloc.dart';
import 'features/home/data/datasources/home_local_datasource.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories_impl/home_repository_impl.dart';
import 'features/home/domain/usecases/get_brand_partners_usecase.dart';
import 'features/home/domain/usecases/get_timeline_feed_usecase.dart';
import 'features/home/domain/usecases/toggle_post_like_usecase.dart';
import 'features/home/domain/usecases/toggle_post_save_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

import 'features/peers/data/datasources/peers_local_datasource.dart';
import 'features/peers/data/datasources/peers_remote_datasource.dart';
import 'features/peers/data/repositories_impl/peers_repository_impl.dart';
import 'features/peers/domain/usecases/accept_connection_request_usecase.dart';
import 'features/peers/domain/usecases/cancel_sent_connection_request_usecase.dart';
import 'features/peers/domain/usecases/decline_connection_request_usecase.dart';
import 'features/peers/domain/usecases/get_all_peers_usecase.dart';
import 'features/peers/domain/usecases/get_connection_requests_usecase.dart';
import 'features/peers/domain/usecases/get_match_peers_usecase.dart';
import 'features/peers/domain/usecases/get_my_connections_usecase.dart';
import 'features/peers/domain/usecases/get_nearby_peers_usecase.dart';
import 'features/peers/domain/usecases/get_sent_connection_requests_usecase.dart';
import 'features/peers/domain/usecases/send_connection_request_usecase.dart';
import 'features/peers/domain/usecases/toggle_peer_bookmark_usecase.dart';
import 'features/peers/presentation/bloc/connections_bloc.dart';
import 'features/peers/presentation/bloc/matches_bloc.dart';
import 'features/peers/presentation/bloc/near_me_bloc.dart';
import 'features/peers/presentation/bloc/peer_requests_bloc.dart';
import 'features/peers/presentation/bloc/peers_bloc.dart';
import 'features/peers/domain/usecases/follow_user_usecase.dart';
import 'features/peers/domain/usecases/get_member_posts_usecase.dart';
import 'features/peers/domain/usecases/get_member_profile_usecase.dart';
import 'features/peers/domain/usecases/remove_connection_usecase.dart';
import 'features/peers/domain/usecases/unfollow_user_usecase.dart';
import 'features/profile/data/datasources/profile_local_datasource.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories_impl/profile_repository_impl.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/get_user_posts_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/domain/usecases/upload_file_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/profile/presentation/bloc/profile_edit_bloc.dart';
import 'features/profile/presentation/bloc/profile_posts_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  final peersRemoteDataSource = PeersRemoteDataSourceImpl(dioClient: dioClient);
  final peersLocalDataSource = PeersLocalDataSourceImpl(cacheStore: cacheStore);
  final peersRepository = PeersRepositoryImpl(
    remoteDataSource: peersRemoteDataSource,
    localDataSource: peersLocalDataSource,
  );

  // Profile Data Sources & Repositories
  final profileRemoteDataSource = ProfileRemoteDataSourceImpl(dioClient: dioClient);
  final profileLocalDataSource = ProfileLocalDataSourceImpl(cacheStore: cacheStore);
  final profileRepository = ProfileRepositoryImpl(
    remoteDataSource: profileRemoteDataSource,
    localDataSource: profileLocalDataSource,
  );

  // Auth UseCases
  final requestOtpUseCase = RequestOtpUseCase(authRepository);
  final verifyOtpUseCase = VerifyOtpUseCase(authRepository);
  final getCachedAuthUseCase = GetCachedAuthUseCase(authRepository);
  final registerUseCase = RegisterUseCase(authRepository);
  final getMainCategoriesUseCase = GetMainCategoriesUseCase(authRepository);
  final getSubcategoriesUseCase = GetSubcategoriesUseCase(authRepository);
  final saveRegistrationDraftUseCase = SaveRegistrationDraftUseCase(authRepository);
  final getRegistrationDraftUseCase = GetRegistrationDraftUseCase(authRepository);
  final clearRegistrationDraftUseCase = ClearRegistrationDraftUseCase(authRepository);

  // Home UseCases
  final getTimelineFeedUseCase = GetTimelineFeedUseCase(homeRepository);
  final getBrandPartnersUseCase = GetBrandPartnersUseCase(homeRepository);
  final togglePostLikeUseCase = TogglePostLikeUseCase(homeRepository);
  final togglePostSaveUseCase = TogglePostSaveUseCase(homeRepository);

  // Peers UseCases
  final getAllPeersUseCase = GetAllPeersUseCase(peersRepository);
  final getMyConnectionsUseCase = GetMyConnectionsUseCase(peersRepository);
  final getConnectionRequestsUseCase = GetConnectionRequestsUseCase(peersRepository);
  final getSentConnectionRequestsUseCase = GetSentConnectionRequestsUseCase(peersRepository);
  final getNearbyPeersUseCase = GetNearbyPeersUseCase(peersRepository);
  final getMatchPeersUseCase = GetMatchPeersUseCase(peersRepository);
  final sendConnectionRequestUseCase = SendConnectionRequestUseCase(peersRepository);
  final acceptConnectionRequestUseCase = AcceptConnectionRequestUseCase(peersRepository);
  final declineConnectionRequestUseCase = DeclineConnectionRequestUseCase(peersRepository);
  final cancelSentConnectionRequestUseCase = CancelSentConnectionRequestUseCase(peersRepository);
  final togglePeerBookmarkUseCase = TogglePeerBookmarkUseCase(peersRepository);
  final getMemberProfileUseCase = GetMemberProfileUseCase(peersRepository);
  final getMemberPostsUseCase = GetMemberPostsUseCase(peersRepository);
  final followUserUseCase = FollowUserUseCase(peersRepository);
  final unfollowUserUseCase = UnfollowUserUseCase(peersRepository);
  final removeConnectionUseCase = RemoveConnectionUseCase(peersRepository);

  // Profile UseCases
  final getProfileUseCase = GetProfileUseCase(profileRepository);
  final updateProfileUseCase = UpdateProfileUseCase(profileRepository);
  final getUserPostsUseCase = GetUserPostsUseCase(profileRepository);
  final uploadProfileMediaUseCase = UploadProfileMediaUseCase(profileRepository);

  // Realtime Sync Service for Connection Requests & Peers
  PeersRealtimeSyncService.instance.init(
    getConnectionRequestsUseCase: getConnectionRequestsUseCase,
    getMyConnectionsUseCase: getMyConnectionsUseCase,
  );

  runApp(
    MyApp(
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
      togglePostLikeUseCase: togglePostLikeUseCase,
      togglePostSaveUseCase: togglePostSaveUseCase,
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
      uploadProfileMediaUseCase: uploadProfileMediaUseCase,
    ),
  );
}

class MyApp extends StatelessWidget {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final GetCachedAuthUseCase getCachedAuthUseCase;
  final RegisterUseCase registerUseCase;
  final GetMainCategoriesUseCase getMainCategoriesUseCase;
  final GetSubcategoriesUseCase getSubcategoriesUseCase;
  final SaveRegistrationDraftUseCase saveRegistrationDraftUseCase;
  final GetRegistrationDraftUseCase getRegistrationDraftUseCase;
  final ClearRegistrationDraftUseCase clearRegistrationDraftUseCase;
  final GetTimelineFeedUseCase getTimelineFeedUseCase;
  final GetBrandPartnersUseCase getBrandPartnersUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final TogglePostSaveUseCase togglePostSaveUseCase;
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
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetUserPostsUseCase getUserPostsUseCase;
  final UploadProfileMediaUseCase uploadProfileMediaUseCase;

  const MyApp({
    super.key,
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
    required this.togglePostLikeUseCase,
    required this.togglePostSaveUseCase,
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
    required this.uploadProfileMediaUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GetMemberProfileUseCase>.value(value: getMemberProfileUseCase),
        RepositoryProvider<GetMemberPostsUseCase>.value(value: getMemberPostsUseCase),
        RepositoryProvider<FollowUserUseCase>.value(value: followUserUseCase),
        RepositoryProvider<UnfollowUserUseCase>.value(value: unfollowUserUseCase),
        RepositoryProvider<SendConnectionRequestUseCase>.value(value: sendConnectionRequestUseCase),
        RepositoryProvider<RemoveConnectionUseCase>.value(value: removeConnectionUseCase),
        RepositoryProvider<CancelSentConnectionRequestUseCase>.value(value: cancelSentConnectionRequestUseCase),
        RepositoryProvider<TogglePeerBookmarkUseCase>.value(value: togglePeerBookmarkUseCase),
      ],
      child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            requestOtpUseCase: requestOtpUseCase,
            verifyOtpUseCase: verifyOtpUseCase,
            getCachedAuthUseCase: getCachedAuthUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => RegisterBloc(
            registerUseCase: registerUseCase,
            getMainCategoriesUseCase: getMainCategoriesUseCase,
            getSubcategoriesUseCase: getSubcategoriesUseCase,
            saveRegistrationDraftUseCase: saveRegistrationDraftUseCase,
            getRegistrationDraftUseCase: getRegistrationDraftUseCase,
            clearRegistrationDraftUseCase: clearRegistrationDraftUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => HomeBloc(
            getTimelineFeedUseCase: getTimelineFeedUseCase,
            getBrandPartnersUseCase: getBrandPartnersUseCase,
            togglePostLikeUseCase: togglePostLikeUseCase,
            togglePostSaveUseCase: togglePostSaveUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => PeersBloc(
            getAllPeersUseCase: getAllPeersUseCase,
            sendConnectionRequestUseCase: sendConnectionRequestUseCase,
            togglePeerBookmarkUseCase: togglePeerBookmarkUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => ConnectionsBloc(
            getMyConnectionsUseCase: getMyConnectionsUseCase,
            togglePeerBookmarkUseCase: togglePeerBookmarkUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => PeerRequestsBloc(
            getConnectionRequestsUseCase: getConnectionRequestsUseCase,
            getSentConnectionRequestsUseCase: getSentConnectionRequestsUseCase,
            acceptConnectionRequestUseCase: acceptConnectionRequestUseCase,
            declineConnectionRequestUseCase: declineConnectionRequestUseCase,
            cancelSentConnectionRequestUseCase: cancelSentConnectionRequestUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => NearMeBloc(
            getNearbyPeersUseCase: getNearbyPeersUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => MatchesBloc(
            getMatchPeersUseCase: getMatchPeersUseCase,
            sendConnectionRequestUseCase: sendConnectionRequestUseCase,
          ),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(
            getProfileUseCase: getProfileUseCase,
          )..add(const ProfileFetchRequested()),
        ),
        BlocProvider(
          create: (context) => ProfileEditBloc(
            updateProfileUseCase: updateProfileUseCase,
            uploadFileUseCase: uploadProfileMediaUseCase,
            profileBloc: context.read<ProfileBloc>(),
          ),
        ),
        BlocProvider(
          create: (_) => ProfilePostsBloc(
            getUserPostsUseCase: getUserPostsUseCase,
            togglePostLikeUseCase: togglePostLikeUseCase,
            togglePostSaveUseCase: togglePostSaveUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Peers Global Unity',
        debugShowCheckedModeBanner: false,
        
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    ),
    );
  }
}
