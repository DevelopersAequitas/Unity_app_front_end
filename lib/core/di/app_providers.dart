import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/features/circles/domain/usecases/cancel_circle_join_request_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_join_request_status_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_package_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_checkout_url_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_joined_circles_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/leave_circle_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/mark_circle_join_request_paid_usecase.dart';
import 'package:unity_app/features/profile/domain/usecases/upload_file_usecase.dart';
import '../../features/events/domain/repositories/events_repository.dart';
import '../../features/events/domain/usecases/check_payment_status_usecase.dart';
import '../../features/events/domain/usecases/get_event_detail_usecase.dart';
import '../../features/events/domain/usecases/get_events_usecase.dart' as events_uc;
import '../../features/events/domain/usecases/get_my_events_with_qr_usecase.dart';
import '../../features/events/domain/usecases/register_event_usecase.dart';
import '../../features/events/domain/usecases/register_visitor_event_usecase.dart';
import '../../features/events/presentation/bloc/events_bloc.dart';
import '../../features/events/presentation/bloc/events_event.dart';
import '../../features/events/presentation/bloc/event_detail_bloc.dart';
import '../../features/events/presentation/bloc/my_events_bloc.dart';
import '../../features/events/presentation/bloc/my_events_event.dart';
import '../../features/membership/domain/usecases/get_membership_plans_usecase.dart';
import '../../features/menu/domain/repositories/menu_repository.dart';
import '../../features/menu/domain/usecases/get_menu_summary_usecase.dart';
import '../../features/menu/presentation/bloc/menu_bloc.dart';
import '../../features/menu/presentation/bloc/menu_event.dart';
import '../../features/membership/domain/usecases/get_subscription_history_usecase.dart';
import '../../features/membership/domain/usecases/initiate_plan_checkout_usecase.dart';
import '../../features/membership/domain/usecases/verify_checkout_status_usecase.dart';
import '../../features/asks/data/datasources/asks_remote_datasource.dart';
import '../../features/asks/presentation/bloc/ask_flows_bloc.dart';
import '../../features/asks/presentation/bloc/ask_flows_event.dart';
import '../../features/asks/presentation/bloc/ask_types/ask_types_bloc.dart';
import '../../features/asks/presentation/bloc/ask_form_config/ask_form_config_bloc.dart';
import '../../features/asks/presentation/bloc/ask_submission/ask_submission_bloc.dart';
import '../../features/asks/presentation/bloc/ask_matches/ask_matches_bloc.dart';
import '../../features/asks/presentation/bloc/ask_response/ask_response_bloc.dart';
import '../../features/asks/presentation/bloc/ask_responses/ask_responses_bloc.dart';
import '../../features/asks/presentation/bloc/my_asks/my_asks_bloc.dart';
import '../../features/asks/presentation/bloc/my_asks/my_asks_event.dart';
import '../../features/asks/presentation/bloc/peers_feed/peers_feed_bloc.dart';
import '../../features/asks/presentation/bloc/peers_feed/peers_feed_event.dart';
import '../../features/asks/domain/usecases/get_ask_history_usecase.dart';
import '../../features/asks/domain/usecases/update_ask_status_usecase.dart';
import '../../features/testimonials/domain/usecases/create_testimonial_usecase.dart';
import '../../features/testimonials/domain/usecases/get_given_testimonials_usecase.dart';
import '../../features/testimonials/domain/usecases/get_received_testimonials_usecase.dart';
import '../../features/testimonials/domain/usecases/get_testimonials_leaderboard_usecase.dart';
import '../../features/testimonials/domain/usecases/get_user_testimonials_usecase.dart';
import '../../features/business_deal/domain/usecases/create_business_deal_usecase.dart';
import '../../features/business_deal/domain/usecases/upload_business_deal_creative_usecase.dart';
import '../../features/business_deal/domain/usecases/get_business_deal_detail_usecase.dart';
import '../../features/business_deal/domain/usecases/get_business_deals_leaderboard_usecase.dart';
import '../../features/business_deal/domain/usecases/get_given_business_deals_usecase.dart';
import '../../features/business_deal/domain/usecases/get_received_business_deals_usecase.dart';
import '../../features/business_deal/domain/usecases/get_user_business_deals_usecase.dart';
import '../../features/referrals/domain/usecases/create_referral_usecase.dart';
import '../../features/referrals/domain/usecases/get_given_referrals_usecase.dart';
import '../../features/referrals/domain/usecases/get_received_referrals_usecase.dart';
import '../../features/referrals/domain/usecases/get_referral_statuses_usecase.dart';
import '../../features/referrals/domain/usecases/get_referrals_leaderboard_usecase.dart';
import '../../features/referrals/domain/usecases/get_referrals_stats_usecase.dart';
import '../../features/referrals/domain/usecases/submit_peer_referral_usecase.dart';
import '../../features/referrals/domain/usecases/update_referral_status_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/accept_p2p_meeting_request_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/approve_reschedule_request_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/cancel_p2p_meeting_request_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/get_p2p_meeting_requests_inbox_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/get_p2p_meeting_requests_sent_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/get_p2p_meetings_history_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/get_p2p_meetings_leaderboard_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/get_pending_reschedule_requests_received_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/get_single_p2p_meeting_request_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/get_single_p2p_meeting_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/get_user_p2p_meetings_summary_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/log_p2p_meeting_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/reject_p2p_meeting_request_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/reject_reschedule_request_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/request_reschedule_p2p_meeting_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/send_p2p_meeting_request_usecase.dart';
import '../../features/p2p_meetings/domain/usecases/upload_activity_creative_usecase.dart';
import '../../features/leaderboard/domain/usecases/get_coins_leaderboard_usecase.dart';
import '../../features/leaderboard/domain/usecases/get_impacts_leaderboard_usecase.dart';
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
import '../../features/home/domain/usecases/report_post_usecase.dart';
import '../../features/home/domain/usecases/get_post_report_reasons_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/peers/domain/usecases/block_peer_usecase.dart';
import '../../features/peers/domain/usecases/cancel_sent_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/follow_user_usecase.dart';
import '../../features/peers/domain/usecases/get_all_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_blocked_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_member_introduced_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_member_posts_usecase.dart';
import '../../features/peers/domain/usecases/get_member_profile_usecase.dart';
import '../../features/peers/domain/usecases/get_my_connections_usecase.dart';
import '../../features/peers/domain/usecases/get_peer_block_status_usecase.dart';
import '../../features/peers/domain/usecases/remove_connection_usecase.dart';
import '../../features/peers/domain/usecases/send_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../features/peers/domain/usecases/unblock_peer_usecase.dart';
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
import '../../features/highlights/domain/usecases/get_highlight_sections_usecase.dart';
import '../../features/highlights/presentation/bloc/highlights_bloc.dart';
import '../../features/highlights/presentation/bloc/highlights_event.dart';
import '../../features/highlights/presentation/bloc/my_network/my_network_bloc.dart';
import '../../features/highlights/presentation/bloc/my_network/my_network_event.dart';
import '../../features/highlights/presentation/bloc/top_builders/top_builders_bloc.dart';
import '../../features/highlights/presentation/bloc/top_builders/top_builders_event.dart';
import '../../features/highlights/presentation/bloc/last_month_activity/last_month_activity_bloc.dart';
import '../../features/highlights/presentation/bloc/last_month_activity/last_month_activity_event.dart';
import '../../features/highlights/presentation/bloc/gratitude_script/gratitude_script_bloc.dart';
import '../../features/highlights/presentation/bloc/gratitude_script/gratitude_script_event.dart';
import '../../features/highlights/presentation/bloc/life_impact/life_impact_bloc.dart';
import '../../features/highlights/presentation/bloc/life_impact/life_impact_event.dart';
import '../../features/highlights/presentation/bloc/coins/coins_bloc.dart';
import '../../features/highlights/presentation/bloc/coins/coins_event.dart';
import '../../features/milestones/presentation/bloc/milestone_bloc.dart';
import '../../features/highlights/presentation/bloc/leadership_certification/leadership_certification_bloc.dart';
import '../../features/highlights/presentation/bloc/leadership_certification/leadership_certification_event.dart';
import '../../features/highlights/presentation/bloc/entrepreneur_certification/entrepreneur_certification_bloc.dart';
import '../../features/highlights/presentation/bloc/entrepreneur_certification/entrepreneur_certification_event.dart';
import '../../features/highlights/presentation/bloc/leadership_role/leadership_role_bloc.dart';
import '../../features/highlights/presentation/bloc/recommend_peer/recommend_peer_bloc.dart';
import '../../features/highlights/presentation/bloc/recommend_peer/recommend_peer_event.dart';
import '../../features/highlights/presentation/bloc/mentor/mentor_bloc.dart';
import '../../features/highlights/presentation/bloc/mentor/mentor_event.dart';
import '../../features/highlights/presentation/bloc/speaker/speaker_bloc.dart';
import '../../features/highlights/presentation/bloc/speaker/speaker_event.dart';
import '../../features/highlights/presentation/bloc/partner_with_us/partner_with_us_bloc.dart';
import '../../features/highlights/presentation/bloc/partner_with_us/partner_with_us_event.dart';
import '../../features/highlights/presentation/bloc/vyapaar_jagat/vyapaar_jagat_bloc.dart';
import '../../features/highlights/presentation/bloc/vyapaar_jagat/vyapaar_jagat_event.dart';
import '../../features/highlights/presentation/bloc/post_ask/post_ask_bloc.dart';
import '../../features/highlights/presentation/bloc/post_ask/post_ask_event.dart';
import '../../features/highlights/presentation/bloc/register_visitor/register_visitor_bloc.dart';
import '../../features/highlights/presentation/bloc/register_visitor/register_visitor_event.dart';
import '../../features/highlights/domain/usecases/upload_claim_proof_usecase.dart';
import '../../features/menu/presentation/bloc/settings/settings_bloc.dart';
import '../../features/menu/presentation/bloc/settings/settings_event.dart';

// Chat BLoCs
import '../../features/chat/presentation/bloc/chat_list/chat_list_bloc.dart';
import '../../features/chat/presentation/bloc/direct_chat/direct_chat_bloc.dart';
import '../../features/chat/presentation/bloc/circle_chat/circle_chat_bloc.dart';
import '../../features/chat/presentation/bloc/leadership_chat/leadership_chat_bloc.dart';
import '../../features/shorts/domain/repositories/shorts_repository.dart';
import '../../features/shorts/domain/usecases/get_intro_videos_usecase.dart';
import '../../features/shorts/presentation/bloc/shorts_bloc.dart';
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
        RepositoryProvider<AppDependencies>.value(
          value: dependencies,
        ),
        RepositoryProvider<AsksRemoteDataSource>.value(
          value: dependencies.asksRemoteDataSource,
        ),
        RepositoryProvider<GetAskHistoryUseCase>.value(
          value: dependencies.getAskHistoryUseCase,
        ),
        RepositoryProvider<UpdateAskStatusUseCase>.value(
          value: dependencies.updateAskStatusUseCase,
        ),
        RepositoryProvider<GetMemberProfileUseCase>.value(
          value: dependencies.getMemberProfileUseCase,
        ),
        RepositoryProvider<GetMemberPostsUseCase>.value(
          value: dependencies.getMemberPostsUseCase,
        ),
        RepositoryProvider<GetMemberIntroducedPeersUseCase>.value(
          value: dependencies.getMemberIntroducedPeersUseCase,
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
        RepositoryProvider<BlockPeerUseCase>.value(
          value: dependencies.blockPeerUseCase,
        ),
        RepositoryProvider<UnblockPeerUseCase>.value(
          value: dependencies.unblockPeerUseCase,
        ),
        RepositoryProvider<GetBlockedPeersUseCase>.value(
          value: dependencies.getBlockedPeersUseCase,
        ),
        RepositoryProvider<GetPeerBlockStatusUseCase>.value(
          value: dependencies.getPeerBlockStatusUseCase,
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
        RepositoryProvider<ReportPostUseCase>.value(
          value: dependencies.reportPostUseCase,
        ),
        RepositoryProvider<GetPostReportReasonsUseCase>.value(
          value: dependencies.getPostReportReasonsUseCase,
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
        RepositoryProvider<GetHighlightSectionsUseCase>.value(
          value: dependencies.getHighlightSectionsUseCase,
        ),
        RepositoryProvider<UploadClaimProofUseCase>.value(
          value: dependencies.uploadClaimProofUseCase,
        ),
        RepositoryProvider<GetMyJoinRequestsUseCase>.value(
          value: dependencies.getMyJoinRequestsUseCase,
        ),
        RepositoryProvider<GetCircleJoinRequestStatusUseCase>.value(
          value: dependencies.getCircleJoinRequestStatusUseCase,
        ),
        RepositoryProvider<CancelCircleJoinRequestUseCase>.value(
          value: dependencies.cancelCircleJoinRequestUseCase,
        ),
        RepositoryProvider<GetCirclePackageUseCase>.value(
          value: dependencies.getCirclePackageUseCase,
        ),
        RepositoryProvider<GetCircleCheckoutUrlUseCase>.value(
          value: dependencies.getCircleCheckoutUrlUseCase,
        ),
        RepositoryProvider<GetJoinedCirclesUseCase>.value(
          value: dependencies.getJoinedCirclesUseCase,
        ),
        RepositoryProvider<MarkCircleJoinRequestPaidUseCase>.value(
          value: dependencies.markCircleJoinRequestPaidUseCase,
        ),
        RepositoryProvider<LeaveCircleUseCase>.value(
          value: dependencies.leaveCircleUseCase,
        ),
        RepositoryProvider<GetMembershipPlansUseCase>.value(
          value: dependencies.getMembershipPlansUseCase,
        ),
        RepositoryProvider<MenuRepository>.value(
          value: dependencies.menuRepository,
        ),
        RepositoryProvider<GetMenuSummaryUseCase>.value(
          value: dependencies.getMenuSummaryUseCase,
        ),
        RepositoryProvider<InitiatePlanCheckoutUseCase>.value(
          value: dependencies.initiatePlanCheckoutUseCase,
        ),
        RepositoryProvider<VerifyCheckoutStatusUseCase>.value(
          value: dependencies.verifyCheckoutStatusUseCase,
        ),
        RepositoryProvider<GetSubscriptionHistoryUseCase>.value(
          value: dependencies.getSubscriptionHistoryUseCase,
        ),
        RepositoryProvider<GetUserTestimonialsUseCase>.value(
          value: dependencies.getUserTestimonialsUseCase,
        ),
        RepositoryProvider<GetReceivedTestimonialsUseCase>.value(
          value: dependencies.getReceivedTestimonialsUseCase,
        ),
        RepositoryProvider<GetGivenTestimonialsUseCase>.value(
          value: dependencies.getGivenTestimonialsUseCase,
        ),
        RepositoryProvider<CreateTestimonialUseCase>.value(
          value: dependencies.createTestimonialUseCase,
        ),
        RepositoryProvider<GetTestimonialsLeaderboardUseCase>.value(
          value: dependencies.getTestimonialsLeaderboardUseCase,
        ),
        RepositoryProvider<GetUserBusinessDealsUseCase>.value(
          value: dependencies.getUserBusinessDealsUseCase,
        ),
        RepositoryProvider<GetReceivedBusinessDealsUseCase>.value(
          value: dependencies.getReceivedBusinessDealsUseCase,
        ),
        RepositoryProvider<GetGivenBusinessDealsUseCase>.value(
          value: dependencies.getGivenBusinessDealsUseCase,
        ),
        RepositoryProvider<GetBusinessDealDetailUseCase>.value(
          value: dependencies.getBusinessDealDetailUseCase,
        ),
        RepositoryProvider<CreateBusinessDealUseCase>.value(
          value: dependencies.createBusinessDealUseCase,
        ),
        RepositoryProvider<UploadBusinessDealCreativeUseCase>.value(
          value: dependencies.uploadBusinessDealCreativeUseCase,
        ),
        RepositoryProvider<GetBusinessDealsLeaderboardUseCase>.value(
          value: dependencies.getBusinessDealsLeaderboardUseCase,
        ),
        RepositoryProvider<GetReceivedReferralsUseCase>.value(
          value: dependencies.getReceivedReferralsUseCase,
        ),
        RepositoryProvider<GetGivenReferralsUseCase>.value(
          value: dependencies.getGivenReferralsUseCase,
        ),
        RepositoryProvider<GetReferralsStatsUseCase>.value(
          value: dependencies.getReferralsStatsUseCase,
        ),
        RepositoryProvider<GetReferralStatusesUseCase>.value(
          value: dependencies.getReferralStatusesUseCase,
        ),
        RepositoryProvider<CreateReferralUseCase>.value(
          value: dependencies.createReferralUseCase,
        ),
        RepositoryProvider<UpdateReferralStatusUseCase>.value(
          value: dependencies.updateReferralStatusUseCase,
        ),
        RepositoryProvider<SubmitPeerReferralUseCase>.value(
          value: dependencies.submitPeerReferralUseCase,
        ),
        RepositoryProvider<GetReferralsLeaderboardUseCase>.value(
          value: dependencies.getReferralsLeaderboardUseCase,
        ),
        RepositoryProvider<GetCoinsLeaderboardUseCase>.value(
          value: dependencies.getCoinsLeaderboardUseCase,
        ),
        RepositoryProvider<GetImpactsLeaderboardUseCase>.value(
          value: dependencies.getImpactsLeaderboardUseCase,
        ),
        RepositoryProvider<LogP2pMeetingUseCase>.value(
          value: dependencies.logP2pMeetingUseCase,
        ),
        RepositoryProvider<UploadActivityCreativeUseCase>.value(
          value: dependencies.uploadActivityCreativeUseCase,
        ),
        RepositoryProvider<GetP2pMeetingsHistoryUseCase>.value(
          value: dependencies.getP2pMeetingsHistoryUseCase,
        ),
        RepositoryProvider<GetSingleP2pMeetingUseCase>.value(
          value: dependencies.getSingleP2pMeetingUseCase,
        ),
        RepositoryProvider<GetUserP2pMeetingsSummaryUseCase>.value(
          value: dependencies.getUserP2pMeetingsSummaryUseCase,
        ),
        RepositoryProvider<SendP2pMeetingRequestUseCase>.value(
          value: dependencies.sendP2pMeetingRequestUseCase,
        ),
        RepositoryProvider<GetP2pMeetingRequestsInboxUseCase>.value(
          value: dependencies.getP2pMeetingRequestsInboxUseCase,
        ),
        RepositoryProvider<GetP2pMeetingRequestsSentUseCase>.value(
          value: dependencies.getP2pMeetingRequestsSentUseCase,
        ),
        RepositoryProvider<GetSingleP2pMeetingRequestUseCase>.value(
          value: dependencies.getSingleP2pMeetingRequestUseCase,
        ),
        RepositoryProvider<GetP2pMeetingsLeaderboardUseCase>.value(
          value: dependencies.getP2pMeetingsLeaderboardUseCase,
        ),
        RepositoryProvider<AcceptP2pMeetingRequestUseCase>.value(
          value: dependencies.acceptP2pMeetingRequestUseCase,
        ),
        RepositoryProvider<RejectP2pMeetingRequestUseCase>.value(
          value: dependencies.rejectP2pMeetingRequestUseCase,
        ),
        RepositoryProvider<CancelP2pMeetingRequestUseCase>.value(
          value: dependencies.cancelP2pMeetingRequestUseCase,
        ),
        RepositoryProvider<RequestRescheduleP2pMeetingUseCase>.value(
          value: dependencies.requestRescheduleP2pMeetingUseCase,
        ),
        RepositoryProvider<GetPendingRescheduleRequestsReceivedUseCase>.value(
          value: dependencies.getPendingRescheduleRequestsReceivedUseCase,
        ),
        RepositoryProvider<ApproveRescheduleRequestUseCase>.value(
          value: dependencies.approveRescheduleRequestUseCase,
        ),
        RepositoryProvider<RejectRescheduleRequestUseCase>.value(
          value: dependencies.rejectRescheduleRequestUseCase,
        ),
        RepositoryProvider<GetAllPeersUseCase>.value(
          value: dependencies.getAllPeersUseCase,
        ),
        RepositoryProvider<GetMyConnectionsUseCase>.value(
          value: dependencies.getMyConnectionsUseCase,
        ),
        RepositoryProvider<UploadProfileMediaUseCase>.value(
          value: dependencies.uploadProfileMediaUseCase,
        ),
        RepositoryProvider<EventsRepository>.value(
          value: dependencies.eventsRepository,
        ),
        RepositoryProvider<events_uc.GetEventsUseCase>.value(
          value: dependencies.getEventsAllUseCase,
        ),
        RepositoryProvider<GetEventDetailUseCase>.value(
          value: dependencies.getEventDetailUseCase,
        ),
        RepositoryProvider<RegisterEventUseCase>.value(
          value: dependencies.registerEventUseCase,
        ),
        RepositoryProvider<RegisterVisitorEventUseCase>.value(
          value: dependencies.registerVisitorEventUseCase,
        ),
        RepositoryProvider<CheckPaymentStatusUseCase>.value(
          value: dependencies.checkPaymentStatusUseCase,
        ),
        RepositoryProvider<GetMyEventsWithQrUseCase>.value(
          value: dependencies.getMyEventsWithQrUseCase,
        ),
        RepositoryProvider<ShortsRepository>.value(
          value: dependencies.shortsRepository,
        ),
        RepositoryProvider<GetIntroVideosUseCase>.value(
          value: dependencies.getIntroVideosUseCase,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CirclesBloc>(
            create: (_) => CirclesBloc(
              getMyCirclesUseCase: dependencies.getMyCirclesUseCase,
              getCircleCategoriesUseCase:
                  dependencies.getCircleCategoriesUseCase,
              getCircleDetailUseCase: dependencies.getCircleDetailUseCase,
              getCachedCirclesUseCase: dependencies.getCachedCirclesUseCase,
              getMyJoinRequestsUseCase: dependencies.getMyJoinRequestsUseCase,
            ),
          ),
          BlocProvider<NotificationsBloc>(
            create: (_) => NotificationsBloc(
              getNotificationsUseCase: dependencies.getNotificationsUseCase,
              markNotificationReadUseCase:
                  dependencies.markNotificationReadUseCase,
              markAllNotificationsReadUseCase:
                  dependencies.markAllNotificationsReadUseCase,
              getCachedNotificationsUseCase:
                  dependencies.getCachedNotificationsUseCase,
            )..add(const NotificationsFetchRequested()),
          ),
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              requestOtpUseCase: dependencies.requestOtpUseCase,
              requestWhatsappOtpUseCase: dependencies.requestWhatsappOtpUseCase,
              verifyOtpUseCase: dependencies.verifyOtpUseCase,
              verifyWhatsappOtpUseCase: dependencies.verifyWhatsappOtpUseCase,
              getCachedAuthUseCase: dependencies.getCachedAuthUseCase,
              logoutUseCase: dependencies.logoutUseCase,
            ),
          ),
          BlocProvider<RegisterBloc>(
            create: (_) => RegisterBloc(
              registerUseCase: dependencies.registerUseCase,
              getMainCategoriesUseCase: dependencies.getMainCategoriesUseCase,
              getSubcategoriesUseCase: dependencies.getSubcategoriesUseCase,
              saveRegistrationDraftUseCase:
                  dependencies.saveRegistrationDraftUseCase,
              getRegistrationDraftUseCase:
                  dependencies.getRegistrationDraftUseCase,
              clearRegistrationDraftUseCase:
                  dependencies.clearRegistrationDraftUseCase,
              validateReferralCodeUseCase:
                  dependencies.validateReferralCodeUseCase,
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
              reportPostUseCase: dependencies.reportPostUseCase,
              getCachedTimelineFeedUseCase:
                  dependencies.getCachedTimelineFeedUseCase,
              getCachedBrandPartnersUseCase:
                  dependencies.getCachedBrandPartnersUseCase,
            ),
          ),
          BlocProvider<AskFlowsBloc>(
            create: (_) => AskFlowsBloc(
              getAskFlowsUseCase: dependencies.getAskFlowsUseCase,
            )..add(const AskFlowsFetchRequested()),
          ),
          BlocProvider<AskTypesBloc>(
            create: (_) => AskTypesBloc(
              getAskTypesUseCase: dependencies.getAskTypesUseCase,
            ),
          ),
          BlocProvider<AskFormConfigBloc>(
            create: (_) => AskFormConfigBloc(
              getAskFormConfigUseCase: dependencies.getAskFormConfigUseCase,
            ),
          ),
          BlocProvider<PeersBloc>(
            create: (_) => PeersBloc(
              getAllPeersUseCase: dependencies.getAllPeersUseCase,
              sendConnectionRequestUseCase:
                  dependencies.sendConnectionRequestUseCase,
              togglePeerBookmarkUseCase: dependencies.togglePeerBookmarkUseCase,
              getBookmarkedPeersUseCase: dependencies.getBookmarkedPeersUseCase,
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
              getConnectionRequestsUseCase:
                  dependencies.getConnectionRequestsUseCase,
              getSentConnectionRequestsUseCase:
                  dependencies.getSentConnectionRequestsUseCase,
              acceptConnectionRequestUseCase:
                  dependencies.acceptConnectionRequestUseCase,
              declineConnectionRequestUseCase:
                  dependencies.declineConnectionRequestUseCase,
              cancelSentConnectionRequestUseCase:
                  dependencies.cancelSentConnectionRequestUseCase,
            ),
          ),
          BlocProvider<NearMeBloc>(
            create: (_) => NearMeBloc(
              getNearbyPeersUseCase: dependencies.getNearbyPeersUseCase,
              followUserUseCase: dependencies.followUserUseCase,
              unfollowUserUseCase: dependencies.unfollowUserUseCase,
              sendConnectionRequestUseCase:
                  dependencies.sendConnectionRequestUseCase,
              togglePeerBookmarkUseCase: dependencies.togglePeerBookmarkUseCase,
            ),
          ),
          BlocProvider<MatchesBloc>(
            create: (_) => MatchesBloc(
              getMatchPeersUseCase: dependencies.getMatchPeersUseCase,
              sendConnectionRequestUseCase:
                  dependencies.sendConnectionRequestUseCase,
            ),
          ),
          BlocProvider<ProfileBloc>(
            create: (_) =>
                ProfileBloc(getProfileUseCase: dependencies.getProfileUseCase)
                  ..add(const ProfileFetchRequested()),
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
          BlocProvider<HighlightsBloc>(
            create: (_) => HighlightsBloc(
              getHighlightSectionsUseCase:
                  dependencies.getHighlightSectionsUseCase,
            )..add(const HighlightsFetchRequested()),
          ),
          BlocProvider<MyNetworkBloc>(
            create: (_) => MyNetworkBloc(
              getNetworkStatsUseCase: dependencies.getNetworkStatsUseCase,
              getNetworkMembersUseCase: dependencies.getNetworkMembersUseCase,
              generateInviteCodeUseCase: dependencies.generateInviteCodeUseCase,
            )..add(const FetchMyNetworkDataEvent()),
          ),
          BlocProvider<TopBuildersBloc>(
            create: (_) => TopBuildersBloc(
              getTopBuildersUseCase: dependencies.getTopBuildersUseCase,
              getMyIntroducedPeersUseCase:
                  dependencies.getMyIntroducedPeersUseCase,
            )..add(const FetchTopBuildersDataEvent()),
          ),
          BlocProvider<LastMonthActivityBloc>(
            create: (_) => LastMonthActivityBloc(
              getLastMonthActivityUseCase:
                  dependencies.getLastMonthActivityUseCase,
            )..add(const FetchLastMonthActivityEvent()),
          ),
          BlocProvider<GratitudeScriptBloc>(
            create: (_) => GratitudeScriptBloc(
              getGratitudeScriptUseCase: dependencies.getGratitudeScriptUseCase,
              saveGratitudeScriptUseCase:
                  dependencies.saveGratitudeScriptUseCase,
            )..add(const FetchGratitudeScriptEvent()),
          ),
          BlocProvider<LifeImpactBloc>(
            create: (_) => LifeImpactBloc(
              getLifeImpactHistoryUseCase:
                  dependencies.getLifeImpactHistoryUseCase,
              getLifeImpactActionsUseCase:
                  dependencies.getLifeImpactActionsUseCase,
              submitLifeImpactUseCase: dependencies.submitLifeImpactUseCase,
            )
              ..add(const FetchLifeImpactHistoryEvent())
              ..add(const FetchLifeImpactActionsEvent()),
          ),
          BlocProvider<CoinsBloc>(
            create: (_) => CoinsBloc(
              getCoinWalletDataUseCase: dependencies.getCoinWalletDataUseCase,
              getCoinClaimActivitiesUseCase: dependencies.getCoinClaimActivitiesUseCase,
              submitCoinClaimUseCase: dependencies.submitCoinClaimUseCase,
              getCoinClaimsUseCase: dependencies.getCoinClaimsUseCase,
            )
              ..add(const FetchCoinsWalletEvent())
              ..add(const FetchCoinClaimActivitiesEvent())
              ..add(const FetchCoinClaimsEvent()),
          ),
          BlocProvider<MilestoneBloc>(
            create: (_) => MilestoneBloc(
              getLatestMilestoneUseCase: dependencies.getLatestMilestoneUseCase,
              getMilestoneHistoryUseCase: dependencies.getMilestoneHistoryUseCase,
            ),
          ),
          BlocProvider<MenuBloc>(
            create: (_) => MenuBloc(
              getMenuSummaryUseCase: dependencies.getMenuSummaryUseCase,
            )..add(const MenuFetchSummaryRequested()),
          ),
          BlocProvider<SettingsBloc>(
            create: (_) => SettingsBloc(
              getNotificationPreferencesUseCase:
                  dependencies.getNotificationPreferencesUseCase,
              updateNotificationPreferencesUseCase:
                  dependencies.updateNotificationPreferencesUseCase,
            )..add(const FetchSettingsEvent()),
          ),
          BlocProvider<LeadershipCertificationBloc>(
            create: (_) => LeadershipCertificationBloc(
              getQuestionsUseCase:
                  dependencies.getLeadershipCertificationQuestionsUseCase,
              getSubmissionsUseCase:
                  dependencies.getLeadershipCertificationSubmissionsUseCase,
              submitCertificationUseCase:
                  dependencies.submitLeadershipCertificationUseCase,
            )..add(const LoadLeadershipInitialDataEvent()),
          ),
          BlocProvider<EntrepreneurCertificationBloc>(
            create: (_) => EntrepreneurCertificationBloc(
              getQuestionsUseCase:
                  dependencies.getEntrepreneurCertificationQuestionsUseCase,
              getSubmissionsUseCase:
                  dependencies.getEntrepreneurCertificationSubmissionsUseCase,
              submitCertificationUseCase:
                  dependencies.submitEntrepreneurCertificationUseCase,
            )..add(const LoadEntrepreneurInitialDataEvent()),
          ),
          BlocProvider<LeadershipRoleBloc>(
            create: (_) => LeadershipRoleBloc(
              submitLeadershipInterestUseCase:
                  dependencies.submitLeadershipInterestUseCase,
            ),
          ),
          BlocProvider<RecommendPeerBloc>(
            create: (_) => RecommendPeerBloc(
              submitPeerRecommendationUseCase:
                  dependencies.submitPeerRecommendationUseCase,
              getPeerRecommendationsHistoryUseCase:
                  dependencies.getPeerRecommendationsHistoryUseCase,
            )..add(const FetchPeerRecommendationsHistoryEvent()),
          ),
          BlocProvider<MentorBloc>(
            create: (_) => MentorBloc(
              submitMentorApplicationUseCase:
                  dependencies.submitMentorApplicationUseCase,
              getMentorSubmissionsUseCase:
                  dependencies.getMentorSubmissionsUseCase,
            )..add(const FetchMentorHistoryEvent()),
          ),
          BlocProvider<SpeakerBloc>(
            create: (_) => SpeakerBloc(
              submitSpeakerApplicationUseCase:
                  dependencies.submitSpeakerApplicationUseCase,
              getSpeakerSubmissionsUseCase:
                  dependencies.getSpeakerSubmissionsUseCase,
            )..add(const FetchSpeakerHistoryEvent()),
          ),
          BlocProvider<PartnerWithUsBloc>(
            create: (_) => PartnerWithUsBloc(
              submitPartnerWithUsUseCase:
                  dependencies.submitPartnerWithUsUseCase,
              getPartnerWithUsSubmissionsUseCase:
                  dependencies.getPartnerWithUsSubmissionsUseCase,
            )..add(const FetchPartnerWithUsHistoryEvent()),
          ),
          BlocProvider<VyapaarJagatBloc>(
            create: (_) => VyapaarJagatBloc(
              submitStoryUseCase: dependencies.submitVyapaarJagatStoryUseCase,
              getStoryStatusUseCase:
                  dependencies.getVyapaarJagatStoryStatusUseCase,
            )..add(const FetchStoryStatusEvent()),
          ),
          BlocProvider<PostAskBloc>(
            create: (_) => PostAskBloc(
              getMyAsksUseCase: dependencies.getMyAsksUseCase,
              submitPostAskUseCase: dependencies.submitPostAskUseCase,
              completeAskUseCase: dependencies.completeAskUseCase,
              uploadProfileMediaUseCase: dependencies.uploadProfileMediaUseCase,
            )..add(const FetchMyAsksEvent()),
          ),
          BlocProvider<RegisterVisitorBloc>(
            create: (_) => RegisterVisitorBloc(
              submitRegisterVisitorUseCase: dependencies.submitRegisterVisitorUseCase,
              getRegisterVisitorSubmissionsUseCase: dependencies.getRegisterVisitorSubmissionsUseCase,
              getEventsUseCase: dependencies.getEventsUseCase,
            )
              ..add(const FetchRegisterVisitorHistoryEvent())
              ..add(const FetchEventsEvent()),
          ),
          BlocProvider<ChatListBloc>(
            create: (_) => ChatListBloc(
              getDirectChatsUseCase: dependencies.getDirectChatsUseCase,
            ),
          ),
          BlocProvider<DirectChatBloc>(
            create: (_) => DirectChatBloc(
              getOrCreateDirectChatUseCase:
                  dependencies.getOrCreateDirectChatUseCase,
              getDirectChatDetailUseCase:
                  dependencies.getDirectChatDetailUseCase,
              getDirectMessagesUseCase: dependencies.getDirectMessagesUseCase,
              sendDirectMessageUseCase: dependencies.sendDirectMessageUseCase,
              markDirectChatReadUseCase:
                  dependencies.markDirectChatReadUseCase,
              setTypingStatusUseCase: dependencies.setTypingStatusUseCase,
              deleteDirectMessageUseCase:
                  dependencies.deleteDirectMessageUseCase,
            ),
          ),
          BlocProvider<CircleChatBloc>(
            create: (_) => CircleChatBloc(
              getCircleMessagesUseCase: dependencies.getCircleMessagesUseCase,
              sendCircleMessageUseCase: dependencies.sendCircleMessageUseCase,
              markCircleMessagesReadUseCase:
                  dependencies.markCircleMessagesReadUseCase,
              getCircleMessageReadsUseCase:
                  dependencies.getCircleMessageReadsUseCase,
              deleteCircleMessageUseCase:
                  dependencies.deleteCircleMessageUseCase,
            ),
          ),
          BlocProvider<LeadershipChatBloc>(
            create: (_) => LeadershipChatBloc(
              getLeadershipRosterUseCase:
                  dependencies.getLeadershipRosterUseCase,
              getLeadershipMessagesUseCase:
                  dependencies.getLeadershipMessagesUseCase,
              sendLeadershipMessageUseCase:
                  dependencies.sendLeadershipMessageUseCase,
              markLeadershipMessagesReadUseCase:
                  dependencies.markLeadershipMessagesReadUseCase,
              deleteLeadershipMessageUseCase:
                  dependencies.deleteLeadershipMessageUseCase,
            ),
          ),
          BlocProvider<EventsBloc>(
            create: (_) => EventsBloc(
              getEventsUseCase: dependencies.getEventsAllUseCase,
            )..add(const FetchAllEventsEvent()),
          ),
          BlocProvider<EventDetailBloc>(
            create: (_) => EventDetailBloc(
              getEventDetailUseCase: dependencies.getEventDetailUseCase,
              registerEventUseCase: dependencies.registerEventUseCase,
              registerVisitorEventUseCase: dependencies.registerVisitorEventUseCase,
              checkPaymentStatusUseCase: dependencies.checkPaymentStatusUseCase,
            ),
          ),
          BlocProvider<MyEventsBloc>(
            create: (_) => MyEventsBloc(
              getMyEventsWithQrUseCase: dependencies.getMyEventsWithQrUseCase,
            )..add(const FetchMyEventsEvent()),
          ),
          BlocProvider<ShortsBloc>(
            create: (_) => ShortsBloc(
              getIntroVideosUseCase: dependencies.getIntroVideosUseCase,
              repository: dependencies.shortsRepository,
            ),
          ),
          BlocProvider<AskSubmissionBloc>(
            create: (_) => AskSubmissionBloc(
              createAndPublishAskUseCase: dependencies.createAndPublishAskUseCase,
            ),
          ),
          BlocProvider<AskMatchesBloc>(
            create: (_) => AskMatchesBloc(
              getAskMatchesUseCase: dependencies.getAskMatchesUseCase,
            ),
          ),
          BlocProvider<AskResponseBloc>(
            create: (_) => AskResponseBloc(
              submitAskResponseUseCase: dependencies.submitAskResponseUseCase,
            ),
          ),
          BlocProvider<AskResponsesBloc>(
            create: (_) => AskResponsesBloc(
              getAskResponsesUseCase: dependencies.getAskResponsesUseCase,
            ),
          ),
          BlocProvider<MyAsksBloc>(
            create: (_) => MyAsksBloc(
              getMyAsksUseCase: dependencies.getMyAsksListUseCase,
              updateAskStatusUseCase: dependencies.updateAskStatusUseCase,
            )..add(const MyAsksFetchRequested()),
          ),
          BlocProvider<PeersFeedBloc>(
            create: (_) => PeersFeedBloc(
              getPeersFeedUseCase: dependencies.getPeersFeedUseCase,
              congratulateAskUseCase: dependencies.congratulateAskUseCase,
              toggleSaveAskUseCase: dependencies.toggleSaveAskUseCase,
            )..add(const PeersFeedFetchRequested()),
          ),
        ],
        child: child,
      ),
    );
  }
}
