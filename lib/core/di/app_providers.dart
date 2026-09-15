import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/register_bloc.dart';
import '../../features/home/domain/usecases/add_post_comment_usecase.dart';
import '../../features/home/domain/usecases/create_post_usecase.dart';
import '../../features/home/domain/usecases/delete_post_usecase.dart';
import '../../features/home/domain/usecases/get_post_comments_usecase.dart';
import '../../features/home/domain/usecases/get_post_likes_usecase.dart';
import '../../features/home/domain/usecases/toggle_post_like_usecase.dart';
import '../../features/home/domain/usecases/toggle_post_save_usecase.dart';
import '../../features/home/domain/usecases/update_post_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/peers/domain/usecases/cancel_sent_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/follow_user_usecase.dart';
import '../../features/peers/domain/usecases/get_member_posts_usecase.dart';
import '../../features/peers/domain/usecases/get_member_profile_usecase.dart';
import '../../features/peers/domain/usecases/remove_connection_usecase.dart';
import '../../features/peers/domain/usecases/send_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../features/peers/domain/usecases/unfollow_user_usecase.dart';
import '../../features/peers/presentation/bloc/connections_bloc.dart';
import '../../features/peers/presentation/bloc/matches_bloc.dart';
import '../../features/peers/presentation/bloc/near_me_bloc.dart';
import '../../features/peers/presentation/bloc/peer_requests_bloc.dart';
import '../../features/peers/presentation/bloc/peers_bloc.dart';
import '../../features/profile/domain/usecases/get_saved_posts_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_edit_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/bloc/profile_posts_bloc.dart';
import '../../features/profile/presentation/bloc/profile_saved_posts_bloc.dart';
import '../../features/notifications/domain/usecases/get_cached_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/mark_notification_read_usecase.dart';
import '../../features/notifications/domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_event.dart';
import '../../features/circles/domain/usecases/get_cached_circles_usecase.dart';
import '../../features/circles/domain/usecases/get_category_subcategories_usecase.dart';
import '../../features/circles/domain/usecases/get_circle_categories_usecase.dart';
import '../../features/circles/domain/usecases/get_circle_closed_categories_usecase.dart';
import '../../features/circles/domain/usecases/get_circle_detail_usecase.dart';
import '../../features/circles/domain/usecases/get_circle_members_usecase.dart';
import '../../features/circles/domain/usecases/get_circle_open_categories_usecase.dart';
import '../../features/circles/domain/usecases/get_my_circles_usecase.dart';
import '../../features/circles/domain/usecases/get_my_join_requests_usecase.dart';
import '../../features/circles/domain/usecases/submit_circle_join_usecase.dart';

import '../../features/circles/presentation/bloc/circles_bloc.dart';
import 'app_dependencies.dart';

class AppProviders extends StatelessWidget {
  final AppDependencies dependencies;
  final Widget child;

  const AppProviders({
    super.key,
    required this.dependencies,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GetMemberProfileUseCase>.value(
          value: dependencies.getMemberProfileUseCase,
        ),
        RepositoryProvider<GetMemberPostsUseCase>.value(
          value: dependencies.getMemberPostsUseCase,
        ),
        RepositoryProvider<FollowUserUseCase>.value(
          value: dependencies.followUserUseCase,
        ),
        RepositoryProvider<UnfollowUserUseCase>.value(
          value: dependencies.unfollowUserUseCase,
        ),
        RepositoryProvider<SendConnectionRequestUseCase>.value(
          value: dependencies.sendConnectionRequestUseCase,
        ),
        RepositoryProvider<RemoveConnectionUseCase>.value(
          value: dependencies.removeConnectionUseCase,
        ),
        RepositoryProvider<CancelSentConnectionRequestUseCase>.value(
          value: dependencies.cancelSentConnectionRequestUseCase,
        ),
        RepositoryProvider<TogglePeerBookmarkUseCase>.value(
          value: dependencies.togglePeerBookmarkUseCase,
        ),
        RepositoryProvider<TogglePostLikeUseCase>.value(
          value: dependencies.togglePostLikeUseCase,
        ),
        RepositoryProvider<TogglePostSaveUseCase>.value(
          value: dependencies.togglePostSaveUseCase,
        ),
        RepositoryProvider<GetPostLikesUseCase>.value(
          value: dependencies.getPostLikesUseCase,
        ),
        RepositoryProvider<GetPostCommentsUseCase>.value(
          value: dependencies.getPostCommentsUseCase,
        ),
        RepositoryProvider<AddPostCommentUseCase>.value(
          value: dependencies.addPostCommentUseCase,
        ),
        RepositoryProvider<CreatePostUseCase>.value(
          value: dependencies.createPostUseCase,
        ),
        RepositoryProvider<DeletePostUseCase>.value(
          value: dependencies.deletePostUseCase,
        ),
        RepositoryProvider<UpdatePostUseCase>.value(
          value: dependencies.updatePostUseCase,
        ),
        RepositoryProvider<GetSavedPostsUseCase>.value(
          value: dependencies.getSavedPostsUseCase,
        ),
        RepositoryProvider<GetNotificationsUseCase>.value(
          value: dependencies.getNotificationsUseCase,
        ),
        RepositoryProvider<MarkNotificationReadUseCase>.value(
          value: dependencies.markNotificationReadUseCase,
        ),
        RepositoryProvider<MarkAllNotificationsReadUseCase>.value(
          value: dependencies.markAllNotificationsReadUseCase,
        ),
        RepositoryProvider<GetCachedNotificationsUseCase>.value(
          value: dependencies.getCachedNotificationsUseCase,
        ),
        RepositoryProvider<GetMyCirclesUseCase>.value(
          value: dependencies.getMyCirclesUseCase,
        ),
        RepositoryProvider<GetCircleCategoriesUseCase>.value(
          value: dependencies.getCircleCategoriesUseCase,
        ),
        RepositoryProvider<GetCircleDetailUseCase>.value(
          value: dependencies.getCircleDetailUseCase,
        ),
        RepositoryProvider<GetCachedCirclesUseCase>.value(
          value: dependencies.getCachedCirclesUseCase,
        ),
        RepositoryProvider<GetCircleMembersUseCase>.value(
          value: dependencies.getCircleMembersUseCase,
        ),
        RepositoryProvider<GetCategorySubcategoriesUseCase>.value(
          value: dependencies.getCategorySubcategoriesUseCase,
        ),
        RepositoryProvider<GetCircleOpenCategoriesUseCase>.value(
          value: dependencies.getCircleOpenCategoriesUseCase,
        ),
        RepositoryProvider<GetCircleClosedCategoriesUseCase>.value(
          value: dependencies.getCircleClosedCategoriesUseCase,
        ),
        RepositoryProvider<SubmitCircleJoinUseCase>.value(
          value: dependencies.submitCircleJoinUseCase,
        ),

        RepositoryProvider<GetMyJoinRequestsUseCase>.value(
          value: dependencies.getMyJoinRequestsUseCase,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CirclesBloc>(
            create: (_) => CirclesBloc(
              getMyCirclesUseCase: dependencies.getMyCirclesUseCase,
              getCircleCategoriesUseCase: dependencies.getCircleCategoriesUseCase,
              getCircleDetailUseCase: dependencies.getCircleDetailUseCase,
              getCachedCirclesUseCase: dependencies.getCachedCirclesUseCase,
            ),
          ),
          BlocProvider<NotificationsBloc>(
            create: (_) => NotificationsBloc(
              getNotificationsUseCase: dependencies.getNotificationsUseCase,
              markNotificationReadUseCase: dependencies.markNotificationReadUseCase,
              markAllNotificationsReadUseCase: dependencies.markAllNotificationsReadUseCase,
              getCachedNotificationsUseCase: dependencies.getCachedNotificationsUseCase,
            )..add(const NotificationsFetchRequested()),
          ),
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              requestOtpUseCase: dependencies.requestOtpUseCase,
              verifyOtpUseCase: dependencies.verifyOtpUseCase,
              getCachedAuthUseCase: dependencies.getCachedAuthUseCase,
            ),
          ),
          BlocProvider<RegisterBloc>(
            create: (_) => RegisterBloc(
              registerUseCase: dependencies.registerUseCase,
              getMainCategoriesUseCase: dependencies.getMainCategoriesUseCase,
              getSubcategoriesUseCase: dependencies.getSubcategoriesUseCase,
              saveRegistrationDraftUseCase: dependencies.saveRegistrationDraftUseCase,
              getRegistrationDraftUseCase: dependencies.getRegistrationDraftUseCase,
              clearRegistrationDraftUseCase: dependencies.clearRegistrationDraftUseCase,
            ),
          ),
          BlocProvider<HomeBloc>(
            create: (_) => HomeBloc(
              getTimelineFeedUseCase: dependencies.getTimelineFeedUseCase,
              getBrandPartnersUseCase: dependencies.getBrandPartnersUseCase,
              togglePostLikeUseCase: dependencies.togglePostLikeUseCase,
              togglePostSaveUseCase: dependencies.togglePostSaveUseCase,
              deletePostUseCase: dependencies.deletePostUseCase,
              updatePostUseCase: dependencies.updatePostUseCase,
              getCachedTimelineFeedUseCase: dependencies.getCachedTimelineFeedUseCase,
              getCachedBrandPartnersUseCase: dependencies.getCachedBrandPartnersUseCase,
            ),
          ),
          BlocProvider<PeersBloc>(
            create: (_) => PeersBloc(
              getAllPeersUseCase: dependencies.getAllPeersUseCase,
              sendConnectionRequestUseCase: dependencies.sendConnectionRequestUseCase,
              togglePeerBookmarkUseCase: dependencies.togglePeerBookmarkUseCase,
              followUserUseCase: dependencies.followUserUseCase,
              unfollowUserUseCase: dependencies.unfollowUserUseCase,
            ),
          ),
          BlocProvider<ConnectionsBloc>(
            create: (_) => ConnectionsBloc(
              getMyConnectionsUseCase: dependencies.getMyConnectionsUseCase,
              togglePeerBookmarkUseCase: dependencies.togglePeerBookmarkUseCase,
              followUserUseCase: dependencies.followUserUseCase,
              unfollowUserUseCase: dependencies.unfollowUserUseCase,
            ),
          ),
          BlocProvider<PeerRequestsBloc>(
            create: (_) => PeerRequestsBloc(
              getConnectionRequestsUseCase: dependencies.getConnectionRequestsUseCase,
              getSentConnectionRequestsUseCase: dependencies.getSentConnectionRequestsUseCase,
              acceptConnectionRequestUseCase: dependencies.acceptConnectionRequestUseCase,
              declineConnectionRequestUseCase: dependencies.declineConnectionRequestUseCase,
              cancelSentConnectionRequestUseCase: dependencies.cancelSentConnectionRequestUseCase,
            ),
          ),
          BlocProvider<NearMeBloc>(
            create: (_) => NearMeBloc(
              getNearbyPeersUseCase: dependencies.getNearbyPeersUseCase,
              followUserUseCase: dependencies.followUserUseCase,
              unfollowUserUseCase: dependencies.unfollowUserUseCase,
              sendConnectionRequestUseCase: dependencies.sendConnectionRequestUseCase,
              togglePeerBookmarkUseCase: dependencies.togglePeerBookmarkUseCase,
            ),
          ),
          BlocProvider<MatchesBloc>(
            create: (_) => MatchesBloc(
              getMatchPeersUseCase: dependencies.getMatchPeersUseCase,
              sendConnectionRequestUseCase: dependencies.sendConnectionRequestUseCase,
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (_) => ProfileBloc(
              getProfileUseCase: dependencies.getProfileUseCase,
            )..add(const ProfileFetchRequested()),
          ),
          BlocProvider<ProfileEditBloc>(
            create: (context) => ProfileEditBloc(
              updateProfileUseCase: dependencies.updateProfileUseCase,
              uploadFileUseCase: dependencies.uploadProfileMediaUseCase,
              profileBloc: context.read<ProfileBloc>(),
            ),
          ),
          BlocProvider<ProfilePostsBloc>(
            create: (_) => ProfilePostsBloc(
              getUserPostsUseCase: dependencies.getUserPostsUseCase,
              togglePostLikeUseCase: dependencies.togglePostLikeUseCase,
              togglePostSaveUseCase: dependencies.togglePostSaveUseCase,
              deletePostUseCase: dependencies.deletePostUseCase,
              updatePostUseCase: dependencies.updatePostUseCase,
            ),
          ),
          BlocProvider<ProfileSavedPostsBloc>(
            create: (_) => ProfileSavedPostsBloc(
              getSavedPostsUseCase: dependencies.getSavedPostsUseCase,
              togglePostLikeUseCase: dependencies.togglePostLikeUseCase,
              togglePostSaveUseCase: dependencies.togglePostSaveUseCase,
            ),
          ),
        ],
        child: child,
      ),
    );
  }
}
