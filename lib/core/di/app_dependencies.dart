import 'package:lottie/lottie.dart';
import '../services/local_notification_service.dart';
import 'package:unity_app/features/circles/domain/usecases/cancel_circle_join_request_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_category_subcategories_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_closed_categories_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_join_request_status_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_members_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_circle_open_categories_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/get_my_join_requests_usecase.dart';
import 'package:unity_app/features/circles/domain/usecases/submit_circle_join_usecase.dart';
import '../../features/events/data/datasources/events_remote_datasource.dart';
import '../../features/events/data/repositories_impl/events_repository_impl.dart';
import '../../features/events/domain/repositories/events_repository.dart';
import '../../features/events/domain/usecases/check_payment_status_usecase.dart';
import '../../features/events/domain/usecases/get_event_detail_usecase.dart';
import '../../features/events/domain/usecases/get_events_usecase.dart' as events_uc;
import '../../features/events/domain/usecases/get_my_events_with_qr_usecase.dart';
import '../../features/events/domain/usecases/register_event_usecase.dart';
import '../../features/events/domain/usecases/register_visitor_event_usecase.dart';
import '../../features/highlights/data/datasources/highlights_local_datasource.dart';
import '../../features/highlights/data/repositories_impl/highlights_repository_impl.dart';
import '../../features/highlights/domain/repositories/highlights_repository.dart';
import '../../features/highlights/domain/usecases/get_highlight_sections_usecase.dart';
import '../../features/highlights/data/datasources/my_network_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/my_network_repository_impl.dart';
import '../../features/highlights/domain/repositories/my_network_repository.dart';
import '../../features/highlights/domain/usecases/get_network_stats_usecase.dart';
import '../../features/highlights/domain/usecases/get_network_members_usecase.dart';
import '../../features/highlights/domain/usecases/generate_invite_code_usecase.dart';
import '../../features/highlights/data/datasources/top_builders_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/top_builders_repository_impl.dart';
import '../../features/highlights/domain/repositories/top_builders_repository.dart';
import '../../features/highlights/domain/usecases/get_top_builders_usecase.dart';
import '../../features/highlights/domain/usecases/get_my_introduced_peers_usecase.dart';
import '../../features/highlights/data/datasources/last_month_activity_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/last_month_activity_repository_impl.dart';
import '../../features/highlights/domain/repositories/last_month_activity_repository.dart';
import '../../features/highlights/domain/usecases/get_last_month_activity_usecase.dart';
import '../../features/highlights/data/datasources/gratitude_script_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/gratitude_script_repository_impl.dart';
import '../../features/highlights/domain/repositories/gratitude_script_repository.dart';
import '../../features/highlights/domain/usecases/get_gratitude_script_usecase.dart';
import '../../features/highlights/domain/usecases/save_gratitude_script_usecase.dart';
import '../../features/highlights/data/datasources/life_impact_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/life_impact_repository_impl.dart';
import '../../features/highlights/domain/repositories/life_impact_repository.dart';
import '../../features/highlights/domain/usecases/get_life_impact_actions_usecase.dart';
import '../../features/highlights/domain/usecases/get_life_impact_history_usecase.dart';
import '../../features/highlights/domain/usecases/submit_life_impact_usecase.dart';
import '../../features/highlights/data/datasources/coins_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/coins_repository_impl.dart';
import '../../features/highlights/domain/repositories/coins_repository.dart';
import '../../features/highlights/domain/usecases/get_coin_wallet_data_usecase.dart';
import '../../features/highlights/domain/usecases/get_coin_claim_activities_usecase.dart';
import '../../features/highlights/domain/usecases/submit_coin_claim_usecase.dart';
import '../../features/highlights/domain/usecases/get_coin_claims_usecase.dart';
import '../../features/highlights/domain/usecases/upload_claim_proof_usecase.dart';
import '../../features/milestones/data/datasources/milestone_remote_datasource.dart';
import '../../features/milestones/data/repositories_impl/milestone_repository_impl.dart';
import '../../features/milestones/domain/repositories/milestone_repository.dart';
import '../../features/milestones/domain/usecases/get_latest_milestone_usecase.dart';
import '../../features/milestones/domain/usecases/get_milestone_history_usecase.dart';
import '../../features/highlights/data/datasources/leadership_certification_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/leadership_certification_repository_impl.dart';
import '../../features/highlights/domain/repositories/leadership_certification_repository.dart';
import '../../features/highlights/domain/usecases/get_leadership_certification_questions_usecase.dart';
import '../../features/highlights/domain/usecases/get_leadership_certification_submissions_usecase.dart';
import '../../features/highlights/domain/usecases/submit_leadership_certification_usecase.dart';
import '../../features/highlights/data/datasources/entrepreneur_certification_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/entrepreneur_certification_repository_impl.dart';
import '../../features/highlights/domain/repositories/entrepreneur_certification_repository.dart';
import '../../features/highlights/domain/usecases/get_entrepreneur_certification_questions_usecase.dart';
import '../../features/highlights/domain/usecases/get_entrepreneur_certification_submissions_usecase.dart';
import '../../features/highlights/domain/usecases/submit_entrepreneur_certification_usecase.dart';
import '../../features/highlights/data/datasources/leadership_role_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/leadership_role_repository_impl.dart';
import '../../features/highlights/domain/repositories/leadership_role_repository.dart';
import '../../features/highlights/domain/usecases/submit_leadership_interest_usecase.dart';
import '../../features/highlights/data/datasources/recommend_peer_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/recommend_peer_repository_impl.dart';
import '../../features/highlights/domain/repositories/recommend_peer_repository.dart';
import '../../features/highlights/domain/usecases/submit_peer_recommendation_usecase.dart';
import '../../features/highlights/data/datasources/mentor_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/mentor_repository_impl.dart';
import '../../features/highlights/domain/repositories/mentor_repository.dart';
import '../../features/highlights/domain/usecases/get_mentor_submissions_usecase.dart';
import '../../features/highlights/domain/usecases/submit_mentor_application_usecase.dart';
import '../../features/highlights/data/datasources/speaker_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/speaker_repository_impl.dart';
import '../../features/highlights/domain/repositories/speaker_repository.dart';
import '../../features/highlights/domain/usecases/get_speaker_submissions_usecase.dart';
import '../../features/highlights/domain/usecases/submit_speaker_application_usecase.dart';
import '../../features/highlights/data/datasources/partner_with_us_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/partner_with_us_repository_impl.dart';
import '../../features/highlights/domain/repositories/partner_with_us_repository.dart';
import '../../features/highlights/domain/usecases/get_partner_with_us_submissions_usecase.dart';
import '../../features/highlights/domain/usecases/submit_partner_with_us_usecase.dart';
import '../../features/highlights/data/datasources/vyapaar_jagat_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/vyapaar_jagat_repository_impl.dart';
import '../../features/highlights/domain/repositories/vyapaar_jagat_repository.dart';
import '../../features/highlights/domain/usecases/get_vyapaar_jagat_story_status_usecase.dart';
import '../../features/highlights/domain/usecases/submit_vyapaar_jagat_story_usecase.dart';
import '../../features/highlights/data/datasources/register_visitor_remote_datasource.dart';
import '../../features/highlights/data/repositories_impl/register_visitor_repository_impl.dart';
import '../../features/highlights/domain/repositories/register_visitor_repository.dart';
import '../../features/highlights/domain/usecases/get_register_visitor_submissions_usecase.dart';
import '../../features/highlights/domain/usecases/submit_register_visitor_usecase.dart';
import '../../features/highlights/domain/usecases/get_events_usecase.dart';
import '../../features/collaborations/data/datasources/collaborations_remote_datasource.dart';
import '../../features/collaborations/data/repositories/collaborations_repository_impl.dart';
import '../../features/collaborations/domain/repositories/collaborations_repository.dart';
import '../../features/collaborations/domain/usecases/get_industries_tree_usecase.dart';
import '../../features/collaborations/domain/usecases/get_collaboration_types_usecase.dart';
import '../../features/collaborations/domain/usecases/submit_collaboration_usecase.dart';
import '../../features/collaborations/domain/usecases/get_collaboration_history_usecase.dart';
import '../../features/collaborations/domain/usecases/accept_collaboration_usecase.dart';
import '../../features/requirements/data/datasources/requirements_remote_datasource.dart';
import '../../features/requirements/data/repositories_impl/requirements_repository_impl.dart';
import '../../features/requirements/domain/repositories/requirements_repository.dart';
import '../../features/requirements/domain/usecases/requirements_usecases.dart';
import '../../features/menu/data/datasources/menu_remote_datasource.dart';
import '../../features/menu/data/repositories_impl/menu_repository_impl.dart';
import '../../features/menu/domain/repositories/menu_repository.dart';
import '../../features/menu/domain/usecases/get_menu_summary_usecase.dart';
import '../../features/menu/domain/usecases/get_notification_preferences_usecase.dart';
import '../../features/menu/domain/usecases/update_notification_preferences_usecase.dart';


import '../../features/peers/domain/usecases/block_peer_usecase.dart';
import '../../features/peers/domain/usecases/unblock_peer_usecase.dart';
import '../../features/peers/domain/usecases/get_blocked_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_peer_block_status_usecase.dart';
import '../../core/cache/hive_cache_store.dart';
import '../../core/network/dio_client.dart';
import '../../features/testimonials/data/datasources/testimonials_remote_datasource.dart';
import '../../features/testimonials/data/repositories_impl/testimonials_repository_impl.dart';
import '../../features/testimonials/domain/repositories/testimonials_repository.dart';
import '../../features/testimonials/domain/usecases/create_testimonial_usecase.dart';
import '../../features/testimonials/domain/usecases/get_given_testimonials_usecase.dart';
import '../../features/testimonials/domain/usecases/get_received_testimonials_usecase.dart';
import '../../features/testimonials/domain/usecases/get_testimonials_leaderboard_usecase.dart';
import '../../features/testimonials/domain/usecases/get_user_testimonials_usecase.dart';
import '../../features/business_deal/data/datasources/business_deals_remote_datasource.dart';
import '../../features/business_deal/data/repositories_impl/business_deals_repository_impl.dart';
import '../../features/business_deal/domain/repositories/business_deals_repository.dart';
import '../../features/business_deal/domain/usecases/create_business_deal_usecase.dart';
import '../../features/business_deal/domain/usecases/get_business_deal_detail_usecase.dart';
import '../../features/business_deal/domain/usecases/get_business_deals_leaderboard_usecase.dart';
import '../../features/business_deal/domain/usecases/get_given_business_deals_usecase.dart';
import '../../features/business_deal/domain/usecases/get_received_business_deals_usecase.dart';
import '../../features/business_deal/domain/usecases/get_user_business_deals_usecase.dart';
import '../../features/business_deal/domain/usecases/upload_business_deal_creative_usecase.dart';
import '../../features/referrals/data/datasources/referrals_remote_datasource.dart';
import '../../features/referrals/data/repositories_impl/referrals_repository_impl.dart';
import '../../features/referrals/domain/repositories/referrals_repository.dart';
import '../../features/referrals/domain/usecases/create_referral_usecase.dart';
import '../../features/referrals/domain/usecases/get_given_referrals_usecase.dart';
import '../../features/referrals/domain/usecases/get_received_referrals_usecase.dart';
import '../../features/referrals/domain/usecases/get_referral_statuses_usecase.dart';
import '../../features/referrals/domain/usecases/get_referrals_leaderboard_usecase.dart';
import '../../features/referrals/domain/usecases/get_referrals_stats_usecase.dart';
import '../../features/referrals/domain/usecases/submit_peer_referral_usecase.dart';
import '../../features/referrals/domain/usecases/update_referral_status_usecase.dart';
import '../../features/p2p_meetings/data/datasources/p2p_meetings_remote_datasource.dart';
import '../../features/p2p_meetings/data/repositories_impl/p2p_meetings_repository_impl.dart';
import '../../features/p2p_meetings/domain/repositories/p2p_meetings_repository.dart';
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
import '../../features/leaderboard/data/datasources/leaderboard_local_datasource.dart';
import '../../features/leaderboard/data/datasources/leaderboard_remote_datasource.dart';
import '../../features/leaderboard/data/repositories_impl/leaderboard_repository_impl.dart';
import '../../features/leaderboard/domain/repositories/leaderboard_repository.dart';
import '../../features/leaderboard/domain/usecases/get_coins_leaderboard_usecase.dart';
import '../../features/leaderboard/domain/usecases/get_impacts_leaderboard_usecase.dart';
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
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/request_otp_usecase.dart';
import '../../features/auth/domain/usecases/request_whatsapp_otp_usecase.dart';
import '../../features/auth/domain/usecases/save_registration_draft_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_whatsapp_otp_usecase.dart';
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
import '../../features/peers/domain/usecases/get_member_introduced_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_member_posts_usecase.dart';
import '../../features/peers/domain/usecases/get_member_profile_usecase.dart';
import '../../features/peers/domain/usecases/get_my_connections_usecase.dart';
import '../../features/peers/domain/usecases/get_nearby_peers_usecase.dart';
import '../../features/peers/domain/usecases/get_sent_connection_requests_usecase.dart';
import '../../features/peers/domain/usecases/remove_connection_usecase.dart';
import '../../features/peers/domain/usecases/send_connection_request_usecase.dart';
import '../../features/peers/domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../features/peers/domain/usecases/get_bookmarked_peers_usecase.dart';
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
import '../../features/highlights/data/datasources/post_ask_remote_datasource.dart';
import '../../features/highlights/data/repositories/post_ask_repository_impl.dart';
import '../../features/highlights/domain/repositories/post_ask_repository.dart';
import '../../features/highlights/domain/usecases/complete_ask_usecase.dart';
import '../../features/highlights/domain/usecases/get_my_asks_usecase.dart';
import '../../features/highlights/domain/usecases/submit_post_ask_usecase.dart';

// Chat Feature
import '../../features/chat/data/datasources/chat_local_datasource.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/repositories_impl/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/get_direct_chats_usecase.dart';
import '../../features/chat/domain/usecases/get_or_create_direct_chat_usecase.dart';
import '../../features/chat/domain/usecases/get_direct_chat_detail_usecase.dart';
import '../../features/chat/domain/usecases/get_direct_messages_usecase.dart';
import '../../features/chat/domain/usecases/send_direct_message_usecase.dart';
import '../../features/chat/domain/usecases/mark_direct_chat_read_usecase.dart';
import '../../features/chat/domain/usecases/set_typing_status_usecase.dart';
import '../../features/chat/domain/usecases/delete_direct_message_usecase.dart';
import '../../features/chat/domain/usecases/get_circle_messages_usecase.dart';
import '../../features/chat/domain/usecases/send_circle_message_usecase.dart';
import '../../features/chat/domain/usecases/mark_circle_messages_read_usecase.dart';
import '../../features/chat/domain/usecases/get_circle_message_reads_usecase.dart';
import '../../features/chat/domain/usecases/delete_circle_message_usecase.dart';
import '../../features/chat/domain/usecases/get_leadership_roster_usecase.dart';
import '../../features/chat/domain/usecases/get_leadership_messages_usecase.dart';
import '../../features/chat/domain/usecases/send_leadership_message_usecase.dart';
import '../../features/chat/domain/usecases/mark_leadership_messages_read_usecase.dart';
import '../../features/chat/domain/usecases/delete_leadership_message_usecase.dart';
import '../../features/shorts/data/datasources/shorts_local_datasource.dart';
import '../../features/shorts/data/datasources/shorts_remote_datasource.dart';
import '../../features/shorts/data/repositories_impl/shorts_repository_impl.dart';
import '../../features/shorts/domain/repositories/shorts_repository.dart';
import '../../features/shorts/domain/usecases/get_intro_videos_usecase.dart';

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
  final MembershipRepository membershipRepository;
  final ShortsRepository shortsRepository;
  final GetIntroVideosUseCase getIntroVideosUseCase;
  // Highlights Repositories & UseCases
  final HighlightsRepository highlightsRepository;
  final GetHighlightSectionsUseCase getHighlightSectionsUseCase;
  final MyNetworkRepository myNetworkRepository;
  final GetNetworkStatsUseCase getNetworkStatsUseCase;
  final GetNetworkMembersUseCase getNetworkMembersUseCase;
  final GenerateInviteCodeUseCase generateInviteCodeUseCase;
  final TopBuildersRepository topBuildersRepository;
  final GetTopBuildersUseCase getTopBuildersUseCase;
  final GetMyIntroducedPeersUseCase getMyIntroducedPeersUseCase;
  final LastMonthActivityRepository lastMonthActivityRepository;
  final GetLastMonthActivityUseCase getLastMonthActivityUseCase;
  final GratitudeScriptRepository gratitudeScriptRepository;
  final GetGratitudeScriptUseCase getGratitudeScriptUseCase;
  final SaveGratitudeScriptUseCase saveGratitudeScriptUseCase;
  final LifeImpactRepository lifeImpactRepository;
  final GetLifeImpactHistoryUseCase getLifeImpactHistoryUseCase;
  final GetLifeImpactActionsUseCase getLifeImpactActionsUseCase;
  final SubmitLifeImpactUseCase submitLifeImpactUseCase;
  final CoinsRepository coinsRepository;
  final GetCoinWalletDataUseCase getCoinWalletDataUseCase;
  final GetCoinClaimActivitiesUseCase getCoinClaimActivitiesUseCase;
  final SubmitCoinClaimUseCase submitCoinClaimUseCase;
  final GetCoinClaimsUseCase getCoinClaimsUseCase;
  final UploadClaimProofUseCase uploadClaimProofUseCase;
  final MilestoneRepository milestoneRepository;
  final GetLatestMilestoneUseCase getLatestMilestoneUseCase;
  final GetMilestoneHistoryUseCase getMilestoneHistoryUseCase;
  final LeadershipCertificationRepository leadershipCertificationRepository;
  final GetLeadershipCertificationQuestionsUseCase getLeadershipCertificationQuestionsUseCase;
  final GetLeadershipCertificationSubmissionsUseCase getLeadershipCertificationSubmissionsUseCase;
  final SubmitLeadershipCertificationUseCase submitLeadershipCertificationUseCase;
  final EntrepreneurCertificationRepository entrepreneurCertificationRepository;
  final GetEntrepreneurCertificationQuestionsUseCase getEntrepreneurCertificationQuestionsUseCase;
  final GetEntrepreneurCertificationSubmissionsUseCase getEntrepreneurCertificationSubmissionsUseCase;
  final SubmitEntrepreneurCertificationUseCase submitEntrepreneurCertificationUseCase;
  final LeadershipRoleRepository leadershipRoleRepository;
  final SubmitLeadershipInterestUseCase submitLeadershipInterestUseCase;
  final RecommendPeerRepository recommendPeerRepository;
  final SubmitPeerRecommendationUseCase submitPeerRecommendationUseCase;
  final MentorRepository mentorRepository;
  final GetMentorSubmissionsUseCase getMentorSubmissionsUseCase;
  final SubmitMentorApplicationUseCase submitMentorApplicationUseCase;
  final SpeakerRepository speakerRepository;
  final GetSpeakerSubmissionsUseCase getSpeakerSubmissionsUseCase;
  final SubmitSpeakerApplicationUseCase submitSpeakerApplicationUseCase;
  final PartnerWithUsRepository partnerWithUsRepository;
  final GetPartnerWithUsSubmissionsUseCase getPartnerWithUsSubmissionsUseCase;
  final SubmitPartnerWithUsUseCase submitPartnerWithUsUseCase;
  final VyapaarJagatRepository vyapaarJagatRepository;
  final GetVyapaarJagatStoryStatusUseCase getVyapaarJagatStoryStatusUseCase;
  final SubmitVyapaarJagatStoryUseCase submitVyapaarJagatStoryUseCase;
  final PostAskRepository postAskRepository;
  final GetMyAsksUseCase getMyAsksUseCase;
  final SubmitPostAskUseCase submitPostAskUseCase;
  final CompleteAskUseCase completeAskUseCase;
  final RegisterVisitorRepository registerVisitorRepository;
  final GetRegisterVisitorSubmissionsUseCase getRegisterVisitorSubmissionsUseCase;
  final SubmitRegisterVisitorUseCase submitRegisterVisitorUseCase;
  final GetEventsUseCase getEventsUseCase;

  // Collaborations
  final CollaborationsRepository collaborationsRepository;
  final GetIndustriesTreeUseCase getIndustriesTreeUseCase;
  final GetCollaborationTypesUseCase getCollaborationTypesUseCase;
  final SubmitCollaborationUseCase submitCollaborationUseCase;
  final GetCollaborationHistoryUseCase getCollaborationHistoryUseCase;
  final AcceptCollaborationUseCase acceptCollaborationUseCase;

  // Requirements
  final RequirementsRepository requirementsRepository;
  final GetOpenRequirementsUseCase getOpenRequirementsUseCase;
  final GetMyRequirementsUseCase getMyRequirementsUseCase;
  final CreateRequirementUseCase createRequirementUseCase;
  final CompleteRequirementUseCase completeRequirementUseCase;
  final FulfillRequirementUseCase fulfillRequirementUseCase;

  // Events Feature
  final EventsRepository eventsRepository;
  final events_uc.GetEventsUseCase getEventsAllUseCase;
  final GetEventDetailUseCase getEventDetailUseCase;
  final RegisterEventUseCase registerEventUseCase;
  final RegisterVisitorEventUseCase registerVisitorEventUseCase;
  final CheckPaymentStatusUseCase checkPaymentStatusUseCase;
  final GetMyEventsWithQrUseCase getMyEventsWithQrUseCase;

  // Menu
  final MenuRepository menuRepository;
  final GetMenuSummaryUseCase getMenuSummaryUseCase;
  final GetNotificationPreferencesUseCase getNotificationPreferencesUseCase;
  final UpdateNotificationPreferencesUseCase updateNotificationPreferencesUseCase;

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
  final RequestWhatsappOtpUseCase requestWhatsappOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final VerifyWhatsappOtpUseCase verifyWhatsappOtpUseCase;
  final GetCachedAuthUseCase getCachedAuthUseCase;
  final LogoutUseCase logoutUseCase;
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
  final GetBookmarkedPeersUseCase getBookmarkedPeersUseCase;
  final GetMemberProfileUseCase getMemberProfileUseCase;
  final GetMemberPostsUseCase getMemberPostsUseCase;
  final GetMemberIntroducedPeersUseCase getMemberIntroducedPeersUseCase;
  final FollowUserUseCase followUserUseCase;
  final UnfollowUserUseCase unfollowUserUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;
  final BlockPeerUseCase blockPeerUseCase;
  final UnblockPeerUseCase unblockPeerUseCase;
  final GetBlockedPeersUseCase getBlockedPeersUseCase;
  final GetPeerBlockStatusUseCase getPeerBlockStatusUseCase;

  // Profile UseCases
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final GetUserPostsUseCase getUserPostsUseCase;
  final GetSavedPostsUseCase getSavedPostsUseCase;
  final UploadProfileMediaUseCase uploadProfileMediaUseCase;

  // Testimonials
  final TestimonialsRepository testimonialsRepository;
  final GetUserTestimonialsUseCase getUserTestimonialsUseCase;
  final GetReceivedTestimonialsUseCase getReceivedTestimonialsUseCase;
  final GetGivenTestimonialsUseCase getGivenTestimonialsUseCase;
  final CreateTestimonialUseCase createTestimonialUseCase;
  final GetTestimonialsLeaderboardUseCase getTestimonialsLeaderboardUseCase;

  // Business Deals
  final BusinessDealsRepository businessDealsRepository;
  final GetUserBusinessDealsUseCase getUserBusinessDealsUseCase;
  final GetReceivedBusinessDealsUseCase getReceivedBusinessDealsUseCase;
  final GetGivenBusinessDealsUseCase getGivenBusinessDealsUseCase;
  final GetBusinessDealDetailUseCase getBusinessDealDetailUseCase;
  final CreateBusinessDealUseCase createBusinessDealUseCase;
  final UploadBusinessDealCreativeUseCase uploadBusinessDealCreativeUseCase;
  final GetBusinessDealsLeaderboardUseCase getBusinessDealsLeaderboardUseCase;

  // Referrals
  final ReferralsRepository referralsRepository;
  final GetReceivedReferralsUseCase getReceivedReferralsUseCase;
  final GetGivenReferralsUseCase getGivenReferralsUseCase;
  final GetReferralsStatsUseCase getReferralsStatsUseCase;
  final GetReferralStatusesUseCase getReferralStatusesUseCase;
  final CreateReferralUseCase createReferralUseCase;
  final UpdateReferralStatusUseCase updateReferralStatusUseCase;
  final SubmitPeerReferralUseCase submitPeerReferralUseCase;
  final GetReferralsLeaderboardUseCase getReferralsLeaderboardUseCase;

  // Leaderboard
  final LeaderboardRepository leaderboardRepository;
  final GetCoinsLeaderboardUseCase getCoinsLeaderboardUseCase;
  final GetImpactsLeaderboardUseCase getImpactsLeaderboardUseCase;

  // P2P / 121 Meetings
  final P2pMeetingsRepository p2pMeetingsRepository;
  final LogP2pMeetingUseCase logP2pMeetingUseCase;
  final GetP2pMeetingsHistoryUseCase getP2pMeetingsHistoryUseCase;
  final GetSingleP2pMeetingUseCase getSingleP2pMeetingUseCase;
  final GetUserP2pMeetingsSummaryUseCase getUserP2pMeetingsSummaryUseCase;
  final SendP2pMeetingRequestUseCase sendP2pMeetingRequestUseCase;
  final GetP2pMeetingRequestsInboxUseCase getP2pMeetingRequestsInboxUseCase;
  final GetP2pMeetingRequestsSentUseCase getP2pMeetingRequestsSentUseCase;
  final GetSingleP2pMeetingRequestUseCase getSingleP2pMeetingRequestUseCase;
  final AcceptP2pMeetingRequestUseCase acceptP2pMeetingRequestUseCase;
  final RejectP2pMeetingRequestUseCase rejectP2pMeetingRequestUseCase;
  final CancelP2pMeetingRequestUseCase cancelP2pMeetingRequestUseCase;
  final RequestRescheduleP2pMeetingUseCase requestRescheduleP2pMeetingUseCase;
  final GetPendingRescheduleRequestsReceivedUseCase
  getPendingRescheduleRequestsReceivedUseCase;
  final GetP2pMeetingsLeaderboardUseCase getP2pMeetingsLeaderboardUseCase;
  final ApproveRescheduleRequestUseCase approveRescheduleRequestUseCase;
  final RejectRescheduleRequestUseCase rejectRescheduleRequestUseCase;
  final UploadActivityCreativeUseCase uploadActivityCreativeUseCase;

  // Chat
  final ChatRepository chatRepository;
  final GetDirectChatsUseCase getDirectChatsUseCase;
  final GetOrCreateDirectChatUseCase getOrCreateDirectChatUseCase;
  final GetDirectChatDetailUseCase getDirectChatDetailUseCase;
  final GetDirectMessagesUseCase getDirectMessagesUseCase;
  final SendDirectMessageUseCase sendDirectMessageUseCase;
  final MarkDirectChatReadUseCase markDirectChatReadUseCase;
  final SetTypingStatusUseCase setTypingStatusUseCase;
  final DeleteDirectMessageUseCase deleteDirectMessageUseCase;
  final GetCircleMessagesUseCase getCircleMessagesUseCase;
  final SendCircleMessageUseCase sendCircleMessageUseCase;
  final MarkCircleMessagesReadUseCase markCircleMessagesReadUseCase;
  final GetCircleMessageReadsUseCase getCircleMessageReadsUseCase;
  final DeleteCircleMessageUseCase deleteCircleMessageUseCase;
  final GetLeadershipRosterUseCase getLeadershipRosterUseCase;
  final GetLeadershipMessagesUseCase getLeadershipMessagesUseCase;
  final SendLeadershipMessageUseCase sendLeadershipMessageUseCase;
  final MarkLeadershipMessagesReadUseCase markLeadershipMessagesReadUseCase;
  final DeleteLeadershipMessageUseCase deleteLeadershipMessageUseCase;

  AppDependencies({
    required this.menuRepository,
    required this.getMenuSummaryUseCase,
    required this.getNotificationPreferencesUseCase,
    required this.updateNotificationPreferencesUseCase,
    required this.p2pMeetingsRepository,
    required this.logP2pMeetingUseCase,
    required this.uploadActivityCreativeUseCase,
    required this.getP2pMeetingsHistoryUseCase,
    required this.getSingleP2pMeetingUseCase,
    required this.getUserP2pMeetingsSummaryUseCase,
    required this.sendP2pMeetingRequestUseCase,
    required this.getP2pMeetingRequestsInboxUseCase,
    required this.getP2pMeetingRequestsSentUseCase,
    required this.getSingleP2pMeetingRequestUseCase,
    required this.acceptP2pMeetingRequestUseCase,
    required this.rejectP2pMeetingRequestUseCase,
    required this.cancelP2pMeetingRequestUseCase,
    required this.requestRescheduleP2pMeetingUseCase,
    required this.getPendingRescheduleRequestsReceivedUseCase,
    required this.getP2pMeetingsLeaderboardUseCase,
    required this.approveRescheduleRequestUseCase,
    required this.rejectRescheduleRequestUseCase,
    required this.referralsRepository,
    required this.getReceivedReferralsUseCase,
    required this.getGivenReferralsUseCase,
    required this.getReferralsStatsUseCase,
    required this.getReferralStatusesUseCase,
    required this.createReferralUseCase,
    required this.updateReferralStatusUseCase,
    required this.submitPeerReferralUseCase,
    required this.getReferralsLeaderboardUseCase,
    required this.leaderboardRepository,
    required this.getCoinsLeaderboardUseCase,
    required this.getImpactsLeaderboardUseCase,
    required this.testimonialsRepository,
    required this.getUserTestimonialsUseCase,
    required this.getReceivedTestimonialsUseCase,
    required this.getGivenTestimonialsUseCase,
    required this.createTestimonialUseCase,
    required this.getTestimonialsLeaderboardUseCase,
    required this.businessDealsRepository,
    required this.getUserBusinessDealsUseCase,
    required this.getReceivedBusinessDealsUseCase,
    required this.getGivenBusinessDealsUseCase,
    required this.getBusinessDealDetailUseCase,
    required this.createBusinessDealUseCase,
    required this.uploadBusinessDealCreativeUseCase,
    required this.getBusinessDealsLeaderboardUseCase,
    required this.cacheStore,
    required this.dioClient,
    required this.authRepository,
    required this.homeRepository,
    required this.peersRepository,
    required this.profileRepository,
    required this.notificationsRepository,
    required this.circlesRepository,
    required this.membershipRepository,
    required this.shortsRepository,
    required this.getIntroVideosUseCase,
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
    required this.requestWhatsappOtpUseCase,
    required this.verifyOtpUseCase,
    required this.verifyWhatsappOtpUseCase,
    required this.getCachedAuthUseCase,
    required this.logoutUseCase,
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
    required this.getBookmarkedPeersUseCase,
    required this.getMemberProfileUseCase,
    required this.getMemberPostsUseCase,
    required this.getMemberIntroducedPeersUseCase,
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
    required this.removeConnectionUseCase,
    required this.blockPeerUseCase,
    required this.unblockPeerUseCase,
    required this.getBlockedPeersUseCase,
    required this.getPeerBlockStatusUseCase,
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.getUserPostsUseCase,
    required this.getSavedPostsUseCase,
    required this.uploadProfileMediaUseCase,
    required this.highlightsRepository,
    required this.getHighlightSectionsUseCase,
    required this.myNetworkRepository,
    required this.getNetworkStatsUseCase,
    required this.getNetworkMembersUseCase,
    required this.generateInviteCodeUseCase,
    required this.topBuildersRepository,
    required this.getTopBuildersUseCase,
    required this.getMyIntroducedPeersUseCase,
    required this.lastMonthActivityRepository,
    required this.getLastMonthActivityUseCase,
    required this.gratitudeScriptRepository,
    required this.getGratitudeScriptUseCase,
    required this.saveGratitudeScriptUseCase,
    required this.lifeImpactRepository,
    required this.getLifeImpactHistoryUseCase,
    required this.getLifeImpactActionsUseCase,
    required this.submitLifeImpactUseCase,
    required this.coinsRepository,
    required this.getCoinWalletDataUseCase,
    required this.getCoinClaimActivitiesUseCase,
    required this.submitCoinClaimUseCase,
    required this.getCoinClaimsUseCase,
    required this.uploadClaimProofUseCase,
    required this.milestoneRepository,
    required this.getLatestMilestoneUseCase,
    required this.getMilestoneHistoryUseCase,
    required this.leadershipCertificationRepository,
    required this.getLeadershipCertificationQuestionsUseCase,
    required this.getLeadershipCertificationSubmissionsUseCase,
    required this.submitLeadershipCertificationUseCase,
    required this.entrepreneurCertificationRepository,
    required this.getEntrepreneurCertificationQuestionsUseCase,
    required this.getEntrepreneurCertificationSubmissionsUseCase,
    required this.submitEntrepreneurCertificationUseCase,
    required this.leadershipRoleRepository,
    required this.submitLeadershipInterestUseCase,
    required this.recommendPeerRepository,
    required this.submitPeerRecommendationUseCase,
    required this.mentorRepository,
    required this.getMentorSubmissionsUseCase,
    required this.submitMentorApplicationUseCase,
    required this.speakerRepository,
    required this.getSpeakerSubmissionsUseCase,
    required this.submitSpeakerApplicationUseCase,
    required this.partnerWithUsRepository,
    required this.getPartnerWithUsSubmissionsUseCase,
    required this.submitPartnerWithUsUseCase,
    required this.vyapaarJagatRepository,
    required this.getVyapaarJagatStoryStatusUseCase,
    required this.submitVyapaarJagatStoryUseCase,
    required this.postAskRepository,
    required this.getMyAsksUseCase,
    required this.submitPostAskUseCase,
    required this.completeAskUseCase,
    required this.registerVisitorRepository,
    required this.getRegisterVisitorSubmissionsUseCase,
    required this.submitRegisterVisitorUseCase,
    required this.getEventsUseCase,
    required this.collaborationsRepository,
    required this.getIndustriesTreeUseCase,
    required this.getCollaborationTypesUseCase,
    required this.submitCollaborationUseCase,
    required this.getCollaborationHistoryUseCase,
    required this.acceptCollaborationUseCase,
    required this.requirementsRepository,
    required this.getOpenRequirementsUseCase,
    required this.getMyRequirementsUseCase,
    required this.createRequirementUseCase,
    required this.completeRequirementUseCase,
    required this.fulfillRequirementUseCase,
    required this.eventsRepository,
    required this.getEventsAllUseCase,
    required this.getEventDetailUseCase,
    required this.registerEventUseCase,
    required this.registerVisitorEventUseCase,
    required this.checkPaymentStatusUseCase,
    required this.getMyEventsWithQrUseCase,
    required this.chatRepository,
    required this.getDirectChatsUseCase,
    required this.getOrCreateDirectChatUseCase,
    required this.getDirectChatDetailUseCase,
    required this.getDirectMessagesUseCase,
    required this.sendDirectMessageUseCase,
    required this.markDirectChatReadUseCase,
    required this.setTypingStatusUseCase,
    required this.deleteDirectMessageUseCase,
    required this.getCircleMessagesUseCase,
    required this.sendCircleMessageUseCase,
    required this.markCircleMessagesReadUseCase,
    required this.getCircleMessageReadsUseCase,
    required this.deleteCircleMessageUseCase,
    required this.getLeadershipRosterUseCase,
    required this.getLeadershipMessagesUseCase,
    required this.sendLeadershipMessageUseCase,
    required this.markLeadershipMessagesReadUseCase,
    required this.deleteLeadershipMessageUseCase,
  });

  static Future<AppDependencies> initialize() async {
    // Initialize deep linking service, local notification service, and network connectivity listener
    await Future.wait([
      DeepLinkService.instance.init(),
      LocalNotificationService.instance.init(),
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
    final highlightsRepository = HighlightsRepositoryImpl(
      highlightsLocalDataSource,
    );
    final getHighlightSectionsUseCase = GetHighlightSectionsUseCase(
      highlightsRepository,
    );

    final myNetworkRemoteDataSource = MyNetworkRemoteDataSourceImpl(dioClient: dioClient);
    final myNetworkRepository = MyNetworkRepositoryImpl(remoteDataSource: myNetworkRemoteDataSource);
    final getNetworkStatsUseCase = GetNetworkStatsUseCase(myNetworkRepository);
    final getNetworkMembersUseCase = GetNetworkMembersUseCase(myNetworkRepository);
    final generateInviteCodeUseCase = GenerateInviteCodeUseCase(myNetworkRepository);

    final topBuildersRemoteDataSource = TopBuildersRemoteDataSourceImpl(dioClient: dioClient);
    final topBuildersRepository = TopBuildersRepositoryImpl(remoteDataSource: topBuildersRemoteDataSource);
    final getTopBuildersUseCase = GetTopBuildersUseCase(topBuildersRepository);
    final getMyIntroducedPeersUseCase = GetMyIntroducedPeersUseCase(topBuildersRepository);

    final lastMonthActivityRemoteDataSource = LastMonthActivityRemoteDataSourceImpl(dioClient: dioClient);
    final lastMonthActivityRepository = LastMonthActivityRepositoryImpl(remoteDataSource: lastMonthActivityRemoteDataSource);
    final getLastMonthActivityUseCase = GetLastMonthActivityUseCase(lastMonthActivityRepository);

    final gratitudeScriptRemoteDataSource = GratitudeScriptRemoteDataSourceImpl(dioClient: dioClient);
    final gratitudeScriptRepository = GratitudeScriptRepositoryImpl(remoteDataSource: gratitudeScriptRemoteDataSource);
    final getGratitudeScriptUseCase = GetGratitudeScriptUseCase(gratitudeScriptRepository);
    final saveGratitudeScriptUseCase = SaveGratitudeScriptUseCase(gratitudeScriptRepository);

    final lifeImpactRemoteDataSource = LifeImpactRemoteDataSourceImpl(dioClient: dioClient);
    final lifeImpactRepository = LifeImpactRepositoryImpl(remoteDataSource: lifeImpactRemoteDataSource);
    final getLifeImpactHistoryUseCase = GetLifeImpactHistoryUseCase(lifeImpactRepository);
    final getLifeImpactActionsUseCase = GetLifeImpactActionsUseCase(lifeImpactRepository);
    final submitLifeImpactUseCase = SubmitLifeImpactUseCase(lifeImpactRepository);

    final coinsRemoteDataSource = CoinsRemoteDataSourceImpl(dioClient: dioClient);
    final coinsRepository = CoinsRepositoryImpl(remoteDataSource: coinsRemoteDataSource);
    final getCoinWalletDataUseCase = GetCoinWalletDataUseCase(coinsRepository);
    final getCoinClaimActivitiesUseCase = GetCoinClaimActivitiesUseCase(coinsRepository);
    final submitCoinClaimUseCase = SubmitCoinClaimUseCase(coinsRepository);
    final getCoinClaimsUseCase = GetCoinClaimsUseCase(coinsRepository);
    final uploadClaimProofUseCase = UploadClaimProofUseCase(coinsRepository);

    // Milestones & Badges
    final milestoneRemoteDataSource = MilestoneRemoteDataSourceImpl(dioClient: dioClient);
    final milestoneRepository = MilestoneRepositoryImpl(remoteDataSource: milestoneRemoteDataSource);
    final getLatestMilestoneUseCase = GetLatestMilestoneUseCase(milestoneRepository);
    final getMilestoneHistoryUseCase = GetMilestoneHistoryUseCase(milestoneRepository);

    // Certifications Data Sources & Repositories
    final leadershipCertificationRemoteDataSource = LeadershipCertificationRemoteDataSourceImpl(dioClient: dioClient);
    final leadershipCertificationRepository = LeadershipCertificationRepositoryImpl(remoteDataSource: leadershipCertificationRemoteDataSource);
    final getLeadershipCertificationQuestionsUseCase = GetLeadershipCertificationQuestionsUseCase(leadershipCertificationRepository);
    final getLeadershipCertificationSubmissionsUseCase = GetLeadershipCertificationSubmissionsUseCase(leadershipCertificationRepository);
    final submitLeadershipCertificationUseCase = SubmitLeadershipCertificationUseCase(leadershipCertificationRepository);

    final entrepreneurCertificationRemoteDataSource = EntrepreneurCertificationRemoteDataSourceImpl(dioClient: dioClient);
    final entrepreneurCertificationRepository = EntrepreneurCertificationRepositoryImpl(remoteDataSource: entrepreneurCertificationRemoteDataSource);
    final getEntrepreneurCertificationQuestionsUseCase = GetEntrepreneurCertificationQuestionsUseCase(entrepreneurCertificationRepository);
    final getEntrepreneurCertificationSubmissionsUseCase = GetEntrepreneurCertificationSubmissionsUseCase(entrepreneurCertificationRepository);
    final submitEntrepreneurCertificationUseCase = SubmitEntrepreneurCertificationUseCase(entrepreneurCertificationRepository);

    // Leadership Role & Recommend Peer
    final leadershipRoleRemoteDataSource = LeadershipRoleRemoteDataSourceImpl(dioClient: dioClient);
    final leadershipRoleRepository = LeadershipRoleRepositoryImpl(remoteDataSource: leadershipRoleRemoteDataSource);
    final submitLeadershipInterestUseCase = SubmitLeadershipInterestUseCase(leadershipRoleRepository);

    final recommendPeerRemoteDataSource = RecommendPeerRemoteDataSourceImpl(dioClient: dioClient);
    final recommendPeerRepository = RecommendPeerRepositoryImpl(remoteDataSource: recommendPeerRemoteDataSource);
    final submitPeerRecommendationUseCase = SubmitPeerRecommendationUseCase(recommendPeerRepository);

    // Mentor & Speaker
    final mentorRemoteDataSource = MentorRemoteDataSourceImpl(dioClient: dioClient);
    final mentorRepository = MentorRepositoryImpl(remoteDataSource: mentorRemoteDataSource);
    final getMentorSubmissionsUseCase = GetMentorSubmissionsUseCase(mentorRepository);
    final submitMentorApplicationUseCase = SubmitMentorApplicationUseCase(mentorRepository);

    final speakerRemoteDataSource = SpeakerRemoteDataSourceImpl(dioClient: dioClient);
    final speakerRepository = SpeakerRepositoryImpl(remoteDataSource: speakerRemoteDataSource);
    final getSpeakerSubmissionsUseCase = GetSpeakerSubmissionsUseCase(speakerRepository);
    final submitSpeakerApplicationUseCase = SubmitSpeakerApplicationUseCase(speakerRepository);

    // Partner With Us & Vyapaar Jagat Story
    final partnerWithUsRemoteDataSource = PartnerWithUsRemoteDataSourceImpl(dioClient: dioClient);
    final partnerWithUsRepository = PartnerWithUsRepositoryImpl(remoteDataSource: partnerWithUsRemoteDataSource);
    final getPartnerWithUsSubmissionsUseCase = GetPartnerWithUsSubmissionsUseCase(partnerWithUsRepository);
    final submitPartnerWithUsUseCase = SubmitPartnerWithUsUseCase(partnerWithUsRepository);

    final vyapaarJagatRemoteDataSource = VyapaarJagatRemoteDataSourceImpl(dioClient: dioClient);
    final vyapaarJagatRepository = VyapaarJagatRepositoryImpl(remoteDataSource: vyapaarJagatRemoteDataSource);
    final getVyapaarJagatStoryStatusUseCase = GetVyapaarJagatStoryStatusUseCase(vyapaarJagatRepository);
    final submitVyapaarJagatStoryUseCase = SubmitVyapaarJagatStoryUseCase(vyapaarJagatRepository);

    final postAskRemoteDataSource = PostAskRemoteDataSourceImpl(dioClient: dioClient);
    final postAskRepository = PostAskRepositoryImpl(remoteDataSource: postAskRemoteDataSource);
    final getMyAsksUseCase = GetMyAsksUseCase(postAskRepository);
    final submitPostAskUseCase = SubmitPostAskUseCase(postAskRepository);
    final completeAskUseCase = CompleteAskUseCase(postAskRepository);

    final registerVisitorRemoteDataSource = RegisterVisitorRemoteDataSourceImpl(dioClient: dioClient);
    final registerVisitorRepository = RegisterVisitorRepositoryImpl(remoteDataSource: registerVisitorRemoteDataSource);
    final getRegisterVisitorSubmissionsUseCase = GetRegisterVisitorSubmissionsUseCase(registerVisitorRepository);
    final submitRegisterVisitorUseCase = SubmitRegisterVisitorUseCase(registerVisitorRepository);
    final getEventsUseCase = GetEventsUseCase(registerVisitorRepository);

    // Events Feature System
    final eventsRemoteDataSource = EventsRemoteDataSourceImpl(dioClient: dioClient);
    final eventsRepository = EventsRepositoryImpl(remoteDataSource: eventsRemoteDataSource);
    final getEventsAllUseCase = events_uc.GetEventsUseCase(eventsRepository);
    final getEventDetailUseCase = GetEventDetailUseCase(eventsRepository);
    final registerEventUseCase = RegisterEventUseCase(eventsRepository);
    final registerVisitorEventUseCase = RegisterVisitorEventUseCase(eventsRepository);
    final checkPaymentStatusUseCase = CheckPaymentStatusUseCase(eventsRepository);
    final getMyEventsWithQrUseCase = GetMyEventsWithQrUseCase(eventsRepository);

    // Collaborations Data Sources & Repositories
    final collaborationsRemoteDataSource = CollaborationsRemoteDataSourceImpl(dioClient: dioClient);
    final collaborationsRepository = CollaborationsRepositoryImpl(remoteDataSource: collaborationsRemoteDataSource);
    final getIndustriesTreeUseCase = GetIndustriesTreeUseCase(collaborationsRepository);
    final getCollaborationTypesUseCase = GetCollaborationTypesUseCase(collaborationsRepository);
    final submitCollaborationUseCase = SubmitCollaborationUseCase(collaborationsRepository);
    final getCollaborationHistoryUseCase = GetCollaborationHistoryUseCase(collaborationsRepository);
    final acceptCollaborationUseCase = AcceptCollaborationUseCase(collaborationsRepository);

    // Requirements Data Sources & Repositories
    final requirementsRemoteDataSource = RequirementsRemoteDataSourceImpl(dioClient: dioClient);
    final requirementsRepository = RequirementsRepositoryImpl(remoteDataSource: requirementsRemoteDataSource);
    final getOpenRequirementsUseCase = GetOpenRequirementsUseCase(requirementsRepository);
    final getMyRequirementsUseCase = GetMyRequirementsUseCase(requirementsRepository);
    final createRequirementUseCase = CreateRequirementUseCase(requirementsRepository);
    final completeRequirementUseCase = CompleteRequirementUseCase(requirementsRepository);
    final fulfillRequirementUseCase = FulfillRequirementUseCase(requirementsRepository);

    // Menu Data Sources & Repositories
    final menuRemoteDataSource = MenuRemoteDataSourceImpl(dioClient);
    final menuRepository = MenuRepositoryImpl(menuRemoteDataSource);
    final getMenuSummaryUseCase = GetMenuSummaryUseCase(menuRepository);
    final getNotificationPreferencesUseCase = GetNotificationPreferencesUseCase(menuRepository);
    final updateNotificationPreferencesUseCase = UpdateNotificationPreferencesUseCase(menuRepository);

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

    // Chat Data Sources & Repositories
    final chatLocalDataSource = ChatLocalDataSourceImpl(cacheStore: cacheStore);
    final chatRemoteDataSource = ChatRemoteDataSourceImpl(
      dioClient: dioClient,
      authLocalDataSource: authLocalDataSource,
    );
    final chatRepository = ChatRepositoryImpl(
      remoteDataSource: chatRemoteDataSource,
      localDataSource: chatLocalDataSource,
    );
    final getDirectChatsUseCase = GetDirectChatsUseCase(chatRepository);
    final getOrCreateDirectChatUseCase =
        GetOrCreateDirectChatUseCase(chatRepository);
    final getDirectChatDetailUseCase =
        GetDirectChatDetailUseCase(chatRepository);
    final getDirectMessagesUseCase = GetDirectMessagesUseCase(chatRepository);
    final sendDirectMessageUseCase = SendDirectMessageUseCase(chatRepository);
    final markDirectChatReadUseCase =
        MarkDirectChatReadUseCase(chatRepository);
    final setTypingStatusUseCase = SetTypingStatusUseCase(chatRepository);
    final deleteDirectMessageUseCase =
        DeleteDirectMessageUseCase(chatRepository);
    final getCircleMessagesUseCase = GetCircleMessagesUseCase(chatRepository);
    final sendCircleMessageUseCase = SendCircleMessageUseCase(chatRepository);
    final markCircleMessagesReadUseCase =
        MarkCircleMessagesReadUseCase(chatRepository);
    final getCircleMessageReadsUseCase =
        GetCircleMessageReadsUseCase(chatRepository);
    final deleteCircleMessageUseCase =
        DeleteCircleMessageUseCase(chatRepository);
    final getLeadershipRosterUseCase =
        GetLeadershipRosterUseCase(chatRepository);
    final getLeadershipMessagesUseCase =
        GetLeadershipMessagesUseCase(chatRepository);
    final sendLeadershipMessageUseCase =
        SendLeadershipMessageUseCase(chatRepository);
    final markLeadershipMessagesReadUseCase =
        MarkLeadershipMessagesReadUseCase(chatRepository);
    final deleteLeadershipMessageUseCase =
        DeleteLeadershipMessageUseCase(chatRepository);

    // Shorts Data Sources & Repositories
    final shortsLocalDataSource = ShortsLocalDataSourceImpl(
      cacheStore: cacheStore,
    );
    final shortsRemoteDataSource = ShortsRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final shortsRepository = ShortsRepositoryImpl(
      remoteDataSource: shortsRemoteDataSource,
      localDataSource: shortsLocalDataSource,
    );
    final getIntroVideosUseCase = GetIntroVideosUseCase(shortsRepository);

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
    final requestWhatsappOtpUseCase = RequestWhatsappOtpUseCase(authRepository);
    final verifyOtpUseCase = VerifyOtpUseCase(authRepository);
    final verifyWhatsappOtpUseCase = VerifyWhatsappOtpUseCase(authRepository);
    final getCachedAuthUseCase = GetCachedAuthUseCase(authRepository);
    final logoutUseCase = LogoutUseCase(authRepository);
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
    final getBookmarkedPeersUseCase =
        GetBookmarkedPeersUseCase(peersRepository);
    final getMemberProfileUseCase = GetMemberProfileUseCase(peersRepository);
    final getMemberPostsUseCase = GetMemberPostsUseCase(peersRepository);
    final getMemberIntroducedPeersUseCase =
        GetMemberIntroducedPeersUseCase(peersRepository);
    final followUserUseCase = FollowUserUseCase(peersRepository);
    final unfollowUserUseCase = UnfollowUserUseCase(peersRepository);
    final removeConnectionUseCase = RemoveConnectionUseCase(peersRepository);
    final blockPeerUseCase = BlockPeerUseCase(peersRepository);
    final unblockPeerUseCase = UnblockPeerUseCase(peersRepository);
    final getBlockedPeersUseCase = GetBlockedPeersUseCase(peersRepository);
    final getPeerBlockStatusUseCase = GetPeerBlockStatusUseCase(peersRepository);

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

    // Testimonials
    final testimonialsRemoteDataSource = TestimonialsRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final testimonialsRepository = TestimonialsRepositoryImpl(
      remoteDataSource: testimonialsRemoteDataSource,
    );
    final getUserTestimonialsUseCase = GetUserTestimonialsUseCase(
      testimonialsRepository,
    );
    final getReceivedTestimonialsUseCase = GetReceivedTestimonialsUseCase(
      testimonialsRepository,
    );
    final getGivenTestimonialsUseCase = GetGivenTestimonialsUseCase(
      testimonialsRepository,
    );
    final createTestimonialUseCase = CreateTestimonialUseCase(
      testimonialsRepository,
    );
    final getTestimonialsLeaderboardUseCase = GetTestimonialsLeaderboardUseCase(
      testimonialsRepository,
    );

    // Business Deals
    final businessDealsRemoteDataSource = BusinessDealsRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final businessDealsRepository = BusinessDealsRepositoryImpl(
      remoteDataSource: businessDealsRemoteDataSource,
    );
    final getUserBusinessDealsUseCase = GetUserBusinessDealsUseCase(
      businessDealsRepository,
    );
    final getReceivedBusinessDealsUseCase = GetReceivedBusinessDealsUseCase(
      businessDealsRepository,
    );
    final getGivenBusinessDealsUseCase = GetGivenBusinessDealsUseCase(
      businessDealsRepository,
    );
    final getBusinessDealDetailUseCase = GetBusinessDealDetailUseCase(
      businessDealsRepository,
    );
    final createBusinessDealUseCase = CreateBusinessDealUseCase(
      businessDealsRepository,
    );
    final uploadBusinessDealCreativeUseCase = UploadBusinessDealCreativeUseCase(
      businessDealsRepository,
    );
    final getBusinessDealsLeaderboardUseCase = GetBusinessDealsLeaderboardUseCase(
      businessDealsRepository,
    );

    // Referrals
    final referralsRemoteDataSource = ReferralsRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final referralsRepository = ReferralsRepositoryImpl(
      remoteDataSource: referralsRemoteDataSource,
    );
    final getReceivedReferralsUseCase = GetReceivedReferralsUseCase(
      referralsRepository,
    );
    final getGivenReferralsUseCase = GetGivenReferralsUseCase(
      referralsRepository,
    );
    final getReferralsStatsUseCase = GetReferralsStatsUseCase(
      referralsRepository,
    );
    final getReferralStatusesUseCase = GetReferralStatusesUseCase(
      referralsRepository,
    );
    final createReferralUseCase = CreateReferralUseCase(referralsRepository);
    final updateReferralStatusUseCase = UpdateReferralStatusUseCase(
      referralsRepository,
    );
    final submitPeerReferralUseCase = SubmitPeerReferralUseCase(
      referralsRepository,
    );
    final getReferralsLeaderboardUseCase = GetReferralsLeaderboardUseCase(
      referralsRepository,
    );

    // Leaderboard
    final leaderboardRemoteDataSource = LeaderboardRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final leaderboardLocalDataSource = LeaderboardLocalDataSourceImpl(
      cacheStore: cacheStore,
    );
    final leaderboardRepository = LeaderboardRepositoryImpl(
      remoteDataSource: leaderboardRemoteDataSource,
      localDataSource: leaderboardLocalDataSource,
    );
    final getCoinsLeaderboardUseCase = GetCoinsLeaderboardUseCase(
      leaderboardRepository,
    );
    final getImpactsLeaderboardUseCase = GetImpactsLeaderboardUseCase(
      leaderboardRepository,
    );

    // P2P Meetings
    final p2pMeetingsRemoteDataSource = P2pMeetingsRemoteDataSourceImpl(
      dioClient: dioClient,
    );
    final p2pMeetingsRepository = P2pMeetingsRepositoryImpl(
      remoteDataSource: p2pMeetingsRemoteDataSource,
    );
    final logP2pMeetingUseCase = LogP2pMeetingUseCase(p2pMeetingsRepository);
    final getP2pMeetingsHistoryUseCase = GetP2pMeetingsHistoryUseCase(
      p2pMeetingsRepository,
    );
    final getSingleP2pMeetingUseCase = GetSingleP2pMeetingUseCase(
      p2pMeetingsRepository,
    );
    final getUserP2pMeetingsSummaryUseCase = GetUserP2pMeetingsSummaryUseCase(
      p2pMeetingsRepository,
    );
    final sendP2pMeetingRequestUseCase = SendP2pMeetingRequestUseCase(
      p2pMeetingsRepository,
    );
    final getP2pMeetingRequestsInboxUseCase = GetP2pMeetingRequestsInboxUseCase(
      p2pMeetingsRepository,
    );
    final getP2pMeetingRequestsSentUseCase = GetP2pMeetingRequestsSentUseCase(
      p2pMeetingsRepository,
    );
    final getSingleP2pMeetingRequestUseCase = GetSingleP2pMeetingRequestUseCase(
      p2pMeetingsRepository,
    );
    final acceptP2pMeetingRequestUseCase = AcceptP2pMeetingRequestUseCase(
      p2pMeetingsRepository,
    );
    final rejectP2pMeetingRequestUseCase = RejectP2pMeetingRequestUseCase(
      p2pMeetingsRepository,
    );
    final cancelP2pMeetingRequestUseCase = CancelP2pMeetingRequestUseCase(
      p2pMeetingsRepository,
    );
    final requestRescheduleP2pMeetingUseCase =
        RequestRescheduleP2pMeetingUseCase(p2pMeetingsRepository);
    final getPendingRescheduleRequestsReceivedUseCase =
        GetPendingRescheduleRequestsReceivedUseCase(p2pMeetingsRepository);
    final getP2pMeetingsLeaderboardUseCase = GetP2pMeetingsLeaderboardUseCase(
      p2pMeetingsRepository,
    );
    final approveRescheduleRequestUseCase = ApproveRescheduleRequestUseCase(
      p2pMeetingsRepository,
    );
    final rejectRescheduleRequestUseCase = RejectRescheduleRequestUseCase(
      p2pMeetingsRepository,
    );
    final uploadActivityCreativeUseCase = UploadActivityCreativeUseCase(
      p2pMeetingsRepository,
    );

    return AppDependencies(
      menuRepository: menuRepository,
      getMenuSummaryUseCase: getMenuSummaryUseCase,
      getNotificationPreferencesUseCase: getNotificationPreferencesUseCase,
      updateNotificationPreferencesUseCase: updateNotificationPreferencesUseCase,
      p2pMeetingsRepository: p2pMeetingsRepository,
      logP2pMeetingUseCase: logP2pMeetingUseCase,
      uploadActivityCreativeUseCase: uploadActivityCreativeUseCase,
      getP2pMeetingsHistoryUseCase: getP2pMeetingsHistoryUseCase,
      getSingleP2pMeetingUseCase: getSingleP2pMeetingUseCase,
      getUserP2pMeetingsSummaryUseCase: getUserP2pMeetingsSummaryUseCase,
      sendP2pMeetingRequestUseCase: sendP2pMeetingRequestUseCase,
      getP2pMeetingRequestsInboxUseCase: getP2pMeetingRequestsInboxUseCase,
      getP2pMeetingRequestsSentUseCase: getP2pMeetingRequestsSentUseCase,
      getSingleP2pMeetingRequestUseCase: getSingleP2pMeetingRequestUseCase,
      acceptP2pMeetingRequestUseCase: acceptP2pMeetingRequestUseCase,
      rejectP2pMeetingRequestUseCase: rejectP2pMeetingRequestUseCase,
      cancelP2pMeetingRequestUseCase: cancelP2pMeetingRequestUseCase,
      requestRescheduleP2pMeetingUseCase: requestRescheduleP2pMeetingUseCase,
      getPendingRescheduleRequestsReceivedUseCase:
          getPendingRescheduleRequestsReceivedUseCase,
      getP2pMeetingsLeaderboardUseCase: getP2pMeetingsLeaderboardUseCase,
      approveRescheduleRequestUseCase: approveRescheduleRequestUseCase,
      rejectRescheduleRequestUseCase: rejectRescheduleRequestUseCase,
      referralsRepository: referralsRepository,
      getReceivedReferralsUseCase: getReceivedReferralsUseCase,
      getGivenReferralsUseCase: getGivenReferralsUseCase,
      getReferralsStatsUseCase: getReferralsStatsUseCase,
      getReferralStatusesUseCase: getReferralStatusesUseCase,
      createReferralUseCase: createReferralUseCase,
      updateReferralStatusUseCase: updateReferralStatusUseCase,
      submitPeerReferralUseCase: submitPeerReferralUseCase,
      getReferralsLeaderboardUseCase: getReferralsLeaderboardUseCase,
      leaderboardRepository: leaderboardRepository,
      getCoinsLeaderboardUseCase: getCoinsLeaderboardUseCase,
      getImpactsLeaderboardUseCase: getImpactsLeaderboardUseCase,
      testimonialsRepository: testimonialsRepository,
      getUserTestimonialsUseCase: getUserTestimonialsUseCase,
      getReceivedTestimonialsUseCase: getReceivedTestimonialsUseCase,
      getGivenTestimonialsUseCase: getGivenTestimonialsUseCase,
      createTestimonialUseCase: createTestimonialUseCase,
      getTestimonialsLeaderboardUseCase: getTestimonialsLeaderboardUseCase,
      businessDealsRepository: businessDealsRepository,
      getUserBusinessDealsUseCase: getUserBusinessDealsUseCase,
      getReceivedBusinessDealsUseCase: getReceivedBusinessDealsUseCase,
      getGivenBusinessDealsUseCase: getGivenBusinessDealsUseCase,
      getBusinessDealDetailUseCase: getBusinessDealDetailUseCase,
      createBusinessDealUseCase: createBusinessDealUseCase,
      uploadBusinessDealCreativeUseCase: uploadBusinessDealCreativeUseCase,
      getBusinessDealsLeaderboardUseCase: getBusinessDealsLeaderboardUseCase,
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
      requestWhatsappOtpUseCase: requestWhatsappOtpUseCase,
      verifyOtpUseCase: verifyOtpUseCase,
      verifyWhatsappOtpUseCase: verifyWhatsappOtpUseCase,
      getCachedAuthUseCase: getCachedAuthUseCase,
      logoutUseCase: logoutUseCase,
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
      getBookmarkedPeersUseCase: getBookmarkedPeersUseCase,
      getMemberProfileUseCase: getMemberProfileUseCase,
      getMemberPostsUseCase: getMemberPostsUseCase,
      getMemberIntroducedPeersUseCase: getMemberIntroducedPeersUseCase,
      followUserUseCase: followUserUseCase,
      unfollowUserUseCase: unfollowUserUseCase,
      removeConnectionUseCase: removeConnectionUseCase,
      blockPeerUseCase: blockPeerUseCase,
      unblockPeerUseCase: unblockPeerUseCase,
      getBlockedPeersUseCase: getBlockedPeersUseCase,
      getPeerBlockStatusUseCase: getPeerBlockStatusUseCase,
      getProfileUseCase: getProfileUseCase,
      updateProfileUseCase: updateProfileUseCase,
      getUserPostsUseCase: getUserPostsUseCase,
      getSavedPostsUseCase: getSavedPostsUseCase,
      uploadProfileMediaUseCase: uploadProfileMediaUseCase,
      highlightsRepository: highlightsRepository,
      getHighlightSectionsUseCase: getHighlightSectionsUseCase,
      myNetworkRepository: myNetworkRepository,
      getNetworkStatsUseCase: getNetworkStatsUseCase,
      getNetworkMembersUseCase: getNetworkMembersUseCase,
      generateInviteCodeUseCase: generateInviteCodeUseCase,
      topBuildersRepository: topBuildersRepository,
      getTopBuildersUseCase: getTopBuildersUseCase,
      getMyIntroducedPeersUseCase: getMyIntroducedPeersUseCase,
      lastMonthActivityRepository: lastMonthActivityRepository,
      getLastMonthActivityUseCase: getLastMonthActivityUseCase,
      gratitudeScriptRepository: gratitudeScriptRepository,
      getGratitudeScriptUseCase: getGratitudeScriptUseCase,
      saveGratitudeScriptUseCase: saveGratitudeScriptUseCase,
      lifeImpactRepository: lifeImpactRepository,
      getLifeImpactHistoryUseCase: getLifeImpactHistoryUseCase,
      getLifeImpactActionsUseCase: getLifeImpactActionsUseCase,
      submitLifeImpactUseCase: submitLifeImpactUseCase,
      coinsRepository: coinsRepository,
      getCoinWalletDataUseCase: getCoinWalletDataUseCase,
      getCoinClaimActivitiesUseCase: getCoinClaimActivitiesUseCase,
      submitCoinClaimUseCase: submitCoinClaimUseCase,
      getCoinClaimsUseCase: getCoinClaimsUseCase,
      uploadClaimProofUseCase: uploadClaimProofUseCase,
      milestoneRepository: milestoneRepository,
      getLatestMilestoneUseCase: getLatestMilestoneUseCase,
      getMilestoneHistoryUseCase: getMilestoneHistoryUseCase,
      leadershipCertificationRepository: leadershipCertificationRepository,
      getLeadershipCertificationQuestionsUseCase: getLeadershipCertificationQuestionsUseCase,
      getLeadershipCertificationSubmissionsUseCase: getLeadershipCertificationSubmissionsUseCase,
      submitLeadershipCertificationUseCase: submitLeadershipCertificationUseCase,
      entrepreneurCertificationRepository: entrepreneurCertificationRepository,
      getEntrepreneurCertificationQuestionsUseCase: getEntrepreneurCertificationQuestionsUseCase,
      getEntrepreneurCertificationSubmissionsUseCase: getEntrepreneurCertificationSubmissionsUseCase,
      submitEntrepreneurCertificationUseCase: submitEntrepreneurCertificationUseCase,
      leadershipRoleRepository: leadershipRoleRepository,
      submitLeadershipInterestUseCase: submitLeadershipInterestUseCase,
      recommendPeerRepository: recommendPeerRepository,
      submitPeerRecommendationUseCase: submitPeerRecommendationUseCase,
      mentorRepository: mentorRepository,
      getMentorSubmissionsUseCase: getMentorSubmissionsUseCase,
      submitMentorApplicationUseCase: submitMentorApplicationUseCase,
      speakerRepository: speakerRepository,
      getSpeakerSubmissionsUseCase: getSpeakerSubmissionsUseCase,
      submitSpeakerApplicationUseCase: submitSpeakerApplicationUseCase,
      partnerWithUsRepository: partnerWithUsRepository,
      getPartnerWithUsSubmissionsUseCase: getPartnerWithUsSubmissionsUseCase,
      submitPartnerWithUsUseCase: submitPartnerWithUsUseCase,
      vyapaarJagatRepository: vyapaarJagatRepository,
      getVyapaarJagatStoryStatusUseCase: getVyapaarJagatStoryStatusUseCase,
      submitVyapaarJagatStoryUseCase: submitVyapaarJagatStoryUseCase,
      postAskRepository: postAskRepository,
      getMyAsksUseCase: getMyAsksUseCase,
      submitPostAskUseCase: submitPostAskUseCase,
      completeAskUseCase: completeAskUseCase,
      registerVisitorRepository: registerVisitorRepository,
      getRegisterVisitorSubmissionsUseCase: getRegisterVisitorSubmissionsUseCase,
      submitRegisterVisitorUseCase: submitRegisterVisitorUseCase,
      getEventsUseCase: getEventsUseCase,
      collaborationsRepository: collaborationsRepository,
      getIndustriesTreeUseCase: getIndustriesTreeUseCase,
      getCollaborationTypesUseCase: getCollaborationTypesUseCase,
      submitCollaborationUseCase: submitCollaborationUseCase,
      getCollaborationHistoryUseCase: getCollaborationHistoryUseCase,
      acceptCollaborationUseCase: acceptCollaborationUseCase,
      requirementsRepository: requirementsRepository,
      getOpenRequirementsUseCase: getOpenRequirementsUseCase,
      getMyRequirementsUseCase: getMyRequirementsUseCase,
      createRequirementUseCase: createRequirementUseCase,
      completeRequirementUseCase: completeRequirementUseCase,
      fulfillRequirementUseCase: fulfillRequirementUseCase,
      eventsRepository: eventsRepository,
      getEventsAllUseCase: getEventsAllUseCase,
      getEventDetailUseCase: getEventDetailUseCase,
      registerEventUseCase: registerEventUseCase,
      registerVisitorEventUseCase: registerVisitorEventUseCase,
      checkPaymentStatusUseCase: checkPaymentStatusUseCase,
      getMyEventsWithQrUseCase: getMyEventsWithQrUseCase,
      membershipRepository: membershipRepository,
      getMembershipPlansUseCase: getMembershipPlansUseCase,
      initiatePlanCheckoutUseCase: initiatePlanCheckoutUseCase,
      verifyCheckoutStatusUseCase: verifyCheckoutStatusUseCase,
      getSubscriptionHistoryUseCase: getSubscriptionHistoryUseCase,
      getCircleJoinRequestStatusUseCase: getCircleJoinRequestStatusUseCase,
      cancelCircleJoinRequestUseCase: cancelCircleJoinRequestUseCase,
      chatRepository: chatRepository,
      getDirectChatsUseCase: getDirectChatsUseCase,
      getOrCreateDirectChatUseCase: getOrCreateDirectChatUseCase,
      getDirectChatDetailUseCase: getDirectChatDetailUseCase,
      getDirectMessagesUseCase: getDirectMessagesUseCase,
      sendDirectMessageUseCase: sendDirectMessageUseCase,
      markDirectChatReadUseCase: markDirectChatReadUseCase,
      setTypingStatusUseCase: setTypingStatusUseCase,
      deleteDirectMessageUseCase: deleteDirectMessageUseCase,
      getCircleMessagesUseCase: getCircleMessagesUseCase,
      sendCircleMessageUseCase: sendCircleMessageUseCase,
      markCircleMessagesReadUseCase: markCircleMessagesReadUseCase,
      getCircleMessageReadsUseCase: getCircleMessageReadsUseCase,
      deleteCircleMessageUseCase: deleteCircleMessageUseCase,
      getLeadershipRosterUseCase: getLeadershipRosterUseCase,
      getLeadershipMessagesUseCase: getLeadershipMessagesUseCase,
      sendLeadershipMessageUseCase: sendLeadershipMessageUseCase,
      markLeadershipMessagesReadUseCase: markLeadershipMessagesReadUseCase,
      deleteLeadershipMessageUseCase: deleteLeadershipMessageUseCase,
      shortsRepository: shortsRepository,
      getIntroVideosUseCase: getIntroVideosUseCase,
    );
  }
}
