import 'app_environment.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => AppEnvironment.baseUrl;

  // Ads
  static String get ads {
    final base = AppEnvironment.baseUrl.split('/api')[0];
    return '$base/api/ads';
  }

  // System & App Version
  static const String appVersion = '/app/version';
  static const String syncMobileVersion = '/user/mobile-version';

  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String requestWhatsappOtp = '/auth/request-whatsapp-otp';
  static const String verifyWhatsappOtp = '/auth/verify-whatsapp-otp';
  static const String register = '/auth/register';
  static const String countries = '/countries';
  static const String cities = '/cities';
  static const String mainBusinessCategories = '/business-categories/main';
  static String subcategories(dynamic parentId) =>
      '/business-categories/$parentId/children';
  static String categoryTree(dynamic idOrSlug) =>
      '/business-categories/$idOrSlug';
  static const String contactPosts = '/contact-posts';
  static const String contactsSync = '/contacts/sync';
  static const String userContactsPermission = '/user/contacts/permission';
  static const String geoUpdateLocation = '/geo/update-location';
  static const String geoNearbyPeers = '/geo/nearby-peers';
  static const String geoPeersCount500km = '/geo/peers-count-500km';
  static const String introVideos = '/intro-videos';

  // Home & Timeline Feed
  static const String timelineFeed = '/posts/feed';
  static const String createPost = '/posts';
  static String postDetail(String id) => '/posts/$id';
  static const String brandPartners = '/brand-partners';
  static String postLike(String id) => '/posts/$id/like';
  static String postLikes(String id) => '/posts/$id/likes';
  static String postComments(String id) => '/posts/$id/comments';
  static String postSave(String id) => '/posts/$id/save';
  static const String savedPosts = '/posts/saved';
  static String postReport(String id) => '/posts/$id/report';
  static const String postReportReasons = '/posts/report-reasons';

  // Peers & Connections
  static const String membersLimited = '/members/limited';
  static String member(String id) => '/members/$id';
  static String followUser(String userId) => '/users/$userId/follow';
  static String unfollowUser(String userId) => '/users/$userId/unfollow';
  static const String myFollowers = '/me/followers';
  static String userFollowers(String userId) => '/users/$userId/followers';
  static String userFollowersCount(String userId) =>
      '/users/$userId/followers/count';
  static String memberFollow(String memberId) => '/members/$memberId/follow';
  static String memberUnfollow(String memberId) =>
      '/members/$memberId/unfollow';
  static const String connections = '/connections';
  static const String connectionRequests = '/me/connection-requests';
  static const String sentConnectionRequests = '/connections/sent';
  static String memberConnections(String id) => '/members/$id/connections';
  static String acceptConnection(String id) =>
      '/members/$id/connections/accept';
  static String cancelSentConnection(String requestId) =>
      '/connections/sent/$requestId';
  static String memberBookmark(String id) => '/members/$id/bookmark';
  static const String bookmarkedPeers = '/bookmarked-peers';
  static String memberIntroducedPeers(String memberId) =>
      '/members/$memberId/introduced-peers';
  static String blockPeer(String peerId) => '/peers/$peerId/block';
  static String unblockPeer(String peerId) => '/peers/$peerId/block';
  static const String blockedPeers = '/blocked-peers';
  static String peerBlockStatus(String peerId) => '/peers/$peerId/block-status';

  // Online & Presence Status
  static const String onlineHeartbeat = '/members/online-heartbeat';
  static const String onlineOffline = '/members/online-offline';
  static const String updateOnlineStatus = '/members/update-online-status';
  static const String membersOnlineStatus = '/members/online-status';
  static const String connectionsOnlineStatus =
      '/members/my-connections-online-status';
  static String memberOnlineStatus(String id) => '/members/$id/online-status';

  // Profile & Uploads
  static const String profile = '/profile';
  static const String profilePosts = '/profile/posts';
  static String userPosts(String userId) => '/users/$userId/posts';
  static const String fileUpload = '/files/upload';

  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const String markAllNotificationsRead = '/notifications/mark-all-read';
  static const String notificationPreferences = '/notifications/preferences';

  // Circles
  static const String myCircles = '/circles/my';
  static const String joinedCircles = '/joined-circles';
  static const String circleCategories = '/circle-categories';
  static String circleDetail(String id) => '/circles/$id';
  static String circlePackage(String circleId) => '/circles/$circleId/package';
  static String circleMembers(String id) => '/circles/$id/members';
  static String circleOpenCategories(String circleId) =>
      '/circles/$circleId/open-categories';
  static String circleClosedCategories(String circleId) =>
      '/circles/$circleId/closed-categories';
  static const String circleJoinRequests = '/circle-join-requests';
  static const String myCircleJoinRequests = '/circle-join-requests/my';
  static String circleJoinRequestStatus(String id) =>
      '/circle-join-requests/$id/status';
  static String cancelCircleJoinRequest(String id) =>
      '/circle-join-requests/$id';
  static String circleCheckout(String circleId) =>
      '/billing/circle-checkout/$circleId';
  static String markCircleJoinRequestPaid(String id) =>
      '/admin/circle-join-requests/$id/mark-paid';
  static String circleJoinRequestMarkPaid(String id) =>
      '/admin/circle-join-requests/$id/mark-paid';
  static String leaveCircle(String circleId) => '/circles/$circleId/leave';

  // Membership & Billing (Zoho)
  static const String zohoPlans = '/zoho/plans';
  static const String membershipPlans = '/membership-plans';
  static const String billingCheckout = '/billing/checkout';
  static String billingHostedPageSync(String hostedPageId) =>
      '/billing/hostedpages/$hostedPageId/sync';
  static String billingCheckoutDetail(String hostedPageId) =>
      '/billing/checkout/$hostedPageId';
  static String billingCheckoutStatus(String hostedPageId) =>
      '/billing/checkout/$hostedPageId';
  static const String subscriptionsHistory = '/billing/subscriptions-history';
  static const String billingInvoices = '/billing/invoices';
  static String billingInvoiceDetail(String invoiceId) =>
      '/billing/invoices/$invoiceId';
  static String billingInvoicePdf(String invoiceId) =>
      '/billing/invoices/$invoiceId/pdf';

  // Testimonials
  static const String testimonials = '/testimonials';
  static String userTestimonials(String userId) =>
      '/users/$userId/testimonials';
  static const String receivedTestimonials =
      '/activities/testimonials?filter=received';
  static const String givenTestimonials =
      '/activities/testimonials?filter=given';
  static const String testimonialsReceived = '/testimonials/received';
  static const String testimonialsGiven = '/testimonials/given';

  // Business Deals
  static const String businessDeals = '/activities/business-deals';
  static String singleBusinessDeal(String id) =>
      '/activities/business-deals/$id';
  static const String receivedBusinessDeals =
      '/activities/business-deals?filter=received';
  static const String givenBusinessDeals =
      '/activities/business-deals?filter=given';
  static String userBusinessDeals(String userId) =>
      '/users/$userId/business-deals';

  // Referrals
  static const String activitiesReferrals = '/activities/referrals';
  static const String referralStatuses = '/activities/referrals/statuses';
  static String updateReferralStatus(String id) =>
      '/activities/referrals/$id/status';
  static const String referralsStats = '/referrals/stats';
  static const String referralsValidate = '/referrals/validate';
  static String validateReferralCode(String code) => '/referrals/validate/$code';
  static const String peerReferrals = '/peer-referrals';
  static const String receivedReferrals =
      '/activities/referrals?filter=received';
  static const String givenReferrals = '/activities/referrals?filter=given';

  // Leaderboards & Coins & Impacts
  static const String leaderboardCoins = '/leaderboards/coins';
  static const String leaderboardImpacts = '/leaderboards/impacts';
  static const String leaderboardBusinessDeals = '/leaderboards/business-deals';
  static const String leaderboardP2pMeetings = '/leaderboards/p2p-meetings';
  static const String leaderboardTestimonials = '/leaderboards/testimonials';
  static const String leaderboardReferrals = '/leaderboards/referrals';
  static const String coinGuidelines = '/coin-guidelines';
  static const String impactGuidelines = '/impact-guidelines';

  // P2P / 121 Meetings - Completed & History
  static const String activitiesP2pMeetings = '/activities/p2p-meetings';
  static const String givenP2pMeetings =
      '/activities/p2p-meetings?filter=given';
  static const String receivedP2pMeetings =
      '/activities/p2p-meetings?filter=received';
  static String singleP2pMeeting(String id) => '/activities/p2p-meetings/$id';
  static String userP2pMeetings(String userId) => '/p2p-meetings/user/$userId';

  // P2P / 121 Meetings - Scheduled Requests & Rescheduling
  static const String p2pMeetingRequests = '/p2p-meeting-requests';
  static const String p2pMeetingRequestsInbox = '/p2p-meeting-requests/inbox';
  static const String p2pMeetingRequestsSent = '/p2p-meeting-requests/sent';
  static String singleP2pMeetingRequest(String id) =>
      '/p2p-meeting-requests/$id';
  static String acceptP2pMeetingRequest(String id) =>
      '/p2p-meeting-requests/$id/accept';
  static String rejectP2pMeetingRequest(String id) =>
      '/p2p-meeting-requests/$id/reject';
  static String cancelP2pMeetingRequest(String id) =>
      '/p2p-meeting-requests/$id/cancel';
  static String rescheduleP2pMeetingRequest(String id) =>
      '/p2p-meeting-requests/$id/reschedule';
  static const String pendingRescheduleRequestsReceived =
      '/p2p-meeting-reschedule-requests/pending-received';
  static String approveRescheduleRequest(String id) =>
      '/p2p-meeting-reschedule-requests/$id/approve';
  static String rejectRescheduleRequest(String id) =>
      '/p2p-meeting-reschedule-requests/$id/reject';
  static const String activityCreatives = '/activity-creatives';

  // Events System
  static const String eventsAll = '/events/all';
  static const String allEventsWithLiveStatus = '/events/all-with-live-status';
  static String publicEventOccurrence(String eventId, String occurrenceId) =>
      '/public/events/$eventId/occurrences/$occurrenceId';
  static String privateEventDetail(String eventId) => '/events/$eventId';
  static String publicEventRegistrationForm(
    String eventId,
    String occurrenceId,
  ) => '/public/events/$eventId/occurrences/$occurrenceId/registration-form';
  static String eventRegister(String eventId, String occurrenceId) =>
      '/events/$eventId/occurrences/$occurrenceId/register';
  static String eventRegistrationRequest(String eventId, String occurrenceId) =>
      '/events/$eventId/occurrences/$occurrenceId/registration-request';
  static String eventVisitorRegister(String eventId, String occurrenceId) =>
      '/events/$eventId/occurrences/$occurrenceId/visitor-register';
  static String eventPaymentStatus(String registrationId) =>
      '/events/registrations/$registrationId/payment-status';
  static String eventRazorpayVerify(String registrationId) =>
      '/events/registrations/$registrationId/razorpay/verify';
  static String eventInvoice(String registrationId) =>
      '/events/registrations/$registrationId/invoice';
  static const String myRegistrations = '/events/my-registrations';
  static const String myRegistrationRequests =
      '/events/registration-requests/my';
  static const String myEventsWithQr = '/my/events-with-qr';
  static const String eventFeedbackCheckPending =
      '/event-feedbacks/check-pending';
  static const String eventFeedbacks = '/event-feedbacks';
  static const String myEventFeedbacks = '/event-feedbacks/my';
  static String eventFeedbacksForEvent(String eventId) =>
      '/event-feedbacks/event/$eventId';

  // Menu & Inner Screens
  static const String events = '/events/all';
  static const String circulars = '/circulars';
  static String circularDetail(String id) => '/circulars/$id';
  static const String eventGalleries = '/events/galleries';
  static String eventGalleryDetail(String id) => '/events/galleries/$id';
  static const String eventVideos = '/events/videos';
  static const String tutorials = '/tutorials';
  static const String myInvoices = '/my/invoices';
  static String downloadInvoice(String id) => '/billing/invoices/$id/pdf';
  static const String blockedUsers = '/blocked-users';
  static String unblockUser(String id) => '/blocked-users/$id';
  static const String feedback = '/feedback';
  static const String feedbackCategories = '/feedback/categories';
  static const String support = '/support';
  static const String supportTickets = '/support/tickets';
  static const String mySupportTickets = '/support/my-tickets';
  static String singleSupportTicket(String id) => '/support/tickets/$id';
  static const String adminSupportTickets = '/admin/support-tickets';
  static const String activitySummary = '/profile/last-month-activity';
  static const String newsletter = '/newsletter/latest';
  static const String rewardsStore = '/rewards/store/items';
  static const String industryInsights = '/insights/industry';
  static const String dailySummary = '/activities/daily-summary';
  static const String myGlobalPeerCertificate = '/my/global-peer-certificate';
  static const String regenerateGlobalPeerCertificate =
      '/my/global-peer-certificate/regenerate';
  static const String becomeAMentor = '/become-a-mentor';
  static const String becomeASpeaker = '/become-a-speaker';
  static const String partnerWithUs = '/partner-with-us';
  static const String storySubmission = '/story-submission';
  static const String storyStatus = '/story-status';


  // ===========================================================================
  // ASK / REQUIREMENT DISCOVERY SYSTEM (NEW COMMON ASK ENGINE)
  // Architecture: Powers Collaboration, Referral, and Get Help flows.
  // Docs Reference: ASK_SYSTEM_API_DOCUMENTATION.md (26 Endpoints)
  // ===========================================================================
  static String get _askApiBase {
    final base = AppEnvironment.baseUrl.split('/api')[0];
    return '$base/api';
  }

  // ---------------------------------------------------------------------------
  // PART 1: DYNAMIC CONFIGURATION APIS
  // ---------------------------------------------------------------------------
  /// API 1: Get Ask Flows (Canva Slide 1)
  /// Method: GET | URL: /api/asks/flows
  /// Loads primary modules: 'collaboration', 'referral', 'help'
  static String get askFlows => '$_askApiBase/asks/flows';

  /// API 2: Get Ask Types (Canva Slides 3, 14, 23)
  /// Method: GET | URL: /api/asks/flows/{flow}/types
  /// Loads hierarchical subcategories for flow (e.g., 'joint_venture', 'manufacturing_partner')
  static String askTypes(String flow) => '$_askApiBase/asks/flows/$flow/types';

  /// API 3: Get Dynamic Form Configuration
  /// Method: GET | URL: /api/asks/form-config?flow={flow}&type={type}
  /// Supplies dynamic question groups, input types (single/multi select, text), and options
  static String askFormConfig({required String flow, required String type}) =>
      '$_askApiBase/asks/form-config?flow=$flow&type=$type';

  // ---------------------------------------------------------------------------
  // PART 2: ASK CREATION, EDITING & PUBLISHING
  // ---------------------------------------------------------------------------
  /// API 4: Create Ask Draft (Canva Slides 4, 15, 24)
  /// Method: POST | URL: /api/asks
  /// Body: { "flow": "collaboration", "type": "manufacturing_partner", "title": "..." }
  /// Returns: { "ask_id": "...", "status": "draft", ... }
  static String get createAskDraft => '$_askApiBase/asks';

  /// API 5: Save / Update Ask Details (Brief: Goal, Bring, Need)
  /// Method: PUT | URL: /api/asks/{askId}
  /// Body: { "answers": [ { "field_key": "goal", "value_text": "..." }, ... ] }
  static String updateAskDetails(String askId) => '$_askApiBase/asks/$askId';

  /// API 6: Save Ask Filters (Canva Slides 5, 16)
  /// Method: PUT | URL: /api/asks/{askId}/filters
  /// Body: { "industry": [...], "geography": [...], "business_stage": [...], "timeline": [...], "expected_outcome": "..." }
  static String updateAskFilters(String askId) =>
      '$_askApiBase/asks/$askId/filters';

  /// API 7: Set Ask Visibility (Canva Slides 6, 17, 25)
  /// Method: PUT | URL: /api/asks/{askId}/visibility
  /// Body: { "visibility_type": "district"|"circle"|"global", "district_id": "...", "circle_id": "..." }
  static String updateAskVisibility(String askId) =>
      '$_askApiBase/asks/$askId/visibility';

  /// API 8: Set Timeline Preference
  /// Method: PUT | URL: /api/asks/{askId}/timeline-preference
  /// Body: { "publish_to_timeline": true|false }
  static String updateAskTimelinePreference(String askId) =>
      '$_askApiBase/asks/$askId/timeline-preference';

  /// API 9: Preview Ask (Canva Slide 6 Preview Card)
  /// Method: GET | URL: /api/asks/{askId}/preview
  /// Returns full preview card details before publishing
  static String previewAsk(String askId) => '$_askApiBase/asks/$askId/preview';

  /// API 10: Publish Ask
  /// Method: POST | URL: /api/asks/{askId}/publish
  /// Publishes request, triggers matching, creates timeline post (if enabled), sends notifications
  static String publishAsk(String askId) => '$_askApiBase/asks/$askId/publish';

  // ---------------------------------------------------------------------------
  // PART 3: ASK LISTING & MANAGEMENT
  // ---------------------------------------------------------------------------
  /// API 11: My Asks Dashboard (Canva Slide 30 Dashboard)
  /// Method: GET | URL: /api/asks?flow={flow}&status={status}&page={page}&per_page={per_page}
  /// Supports tabs: open, in_progress, fulfilled, closed, expired
  static String myAsks({
    String? flow,
    String? status,
    int page = 1,
    int perPage = 15,
  }) {
    final params = <String>[];
    if (flow != null && flow.isNotEmpty) params.add('flow=$flow');
    if (status != null && status.isNotEmpty) params.add('status=$status');
    params.add('page=$page');
    params.add('per_page=$perPage');
    return '$_askApiBase/asks?${params.join('&')}';
  }

  /// API 12: Ask Details
  /// Method: GET | URL: /api/asks/{askId}
  /// Returns complete ask details, match_count, response_count, etc.
  static String askDetail(String askId) => '$_askApiBase/asks/$askId';

  /// API 13: Update Ask Info
  /// Method: PATCH | URL: /api/asks/{askId}
  /// Body: { "title": "..." }
  static String patchAsk(String askId) => '$_askApiBase/asks/$askId';

  /// API 14: Peers Feed (For You, My Circle, My City, All Peers)
  /// Method: GET | URL: /api/asks/feed?scope={for_you|circle|city|all}&page={page}&per_page={per_page}
  static String peersFeed({
    String? scope,
    int page = 1,
    int perPage = 15,
  }) {
    final params = <String>[];
    if (scope != null && scope.isNotEmpty) params.add('scope=$scope');
    params.add('page=$page');
    params.add('per_page=$perPage');
    return '$_askApiBase/asks/feed?${params.join('&')}';
  }

  /// API 15: Congratulate Fulfilled Ask / Story
  /// Method: POST | URL: /api/asks/{askId}/congratulate
  static String congratulateAsk(String askId) => '$_askApiBase/asks/$askId/congratulate';

  /// API 16: Save / Bookmark Ask
  /// Method: POST | URL: /api/asks/{askId}/save
  static String saveAsk(String askId) => '$_askApiBase/asks/$askId/save';

  /// API 14: Cancel / Close Ask (Canva Slides 10, 29)
  /// Method: PATCH | URL: /api/asks/{askId}/status
  /// Body: { "status": "closed"|"cancelled", "reason": "..." }
  static String updateAskStatus(String askId) =>
      '$_askApiBase/asks/$askId/status';

  // ---------------------------------------------------------------------------
  // PART 4: MATCHING SYSTEM
  // ---------------------------------------------------------------------------
  /// API 15: Generate Matches
  /// Method: POST | URL: /api/asks/{askId}/matches/generate
  /// Manually triggers / refreshes the matching algorithm
  static String generateAskMatches(String askId) =>
      '$_askApiBase/asks/$askId/matches/generate';

  /// API 16: Get Matched Peers (Canva Slides 7, 18, 26)
  /// Method: GET | URL: /api/asks/{askId}/matches
  /// Returns list of matched peers with Canonical Peer data, match_score, match_reason
  static String askMatches(String askId) => '$_askApiBase/asks/$askId/matches';

  /// API 17: Update Match Action
  /// Method: PATCH | URL: /api/asks/{askId}/matches/{matchId}
  /// Body: { "match_status": "interested"|"ignored"|"connected" }
  static String updateMatchAction({
    required String askId,
    required String matchId,
  }) => '$_askApiBase/asks/$askId/matches/$matchId';

  // ---------------------------------------------------------------------------
  // PART 5: PEER RESPONSE SYSTEM
  // ---------------------------------------------------------------------------
  /// API 18: Get Ask For Response (Canva Slides 8, 20, 27)
  /// Method: GET | URL: /api/asks/{askId}/respond
  /// Returns ask summary, 4 available response types, and existing user response
  static String askForResponse(String askId) =>
      '$_askApiBase/asks/$askId/respond';

  /// API 19: Submit Ask Response (4 Responder Branches)
  /// Method: POST | URL: /api/asks/{askId}/responses
  /// Branches:
  ///   - Branch A (Direct Help): { "response_type": "can_help_directly", "message": "..." }
  ///   - Branch B (Introduce Peer): { "response_type": "can_introduce_peer", "introduced_user_id": "...", "message": "..." }
  ///   - Branch C (External Contact): { "response_type": "know_someone", "contact": { "full_name": "...", "phone": "...", ... } }
  ///   - Branch D (Not Relevant): { "response_type": "not_relevant" }
  static String submitAskResponse(String askId) =>
      '$_askApiBase/asks/$askId/responses';

  /// API 20: Get Ask Responses (Ask Owner View)
  /// Method: GET | URL: /api/asks/{askId}/responses
  /// Returns all responses received for the ask with responder and contact info
  static String askResponses(String askId) =>
      '$_askApiBase/asks/$askId/responses';

  /// API 21: Response Details
  /// Method: GET | URL: /api/asks/{askId}/responses/{responseId}
  /// Returns detailed information for a single response
  static String askResponseDetail({
    required String askId,
    required String responseId,
  }) => '$_askApiBase/asks/$askId/responses/$responseId';

  /// API 22: Update Response Status
  /// Method: PATCH | URL: /api/asks/{askId}/responses/{responseId}
  /// Body: { "status": "accepted"|"rejected"|"archived", "note": "..." }
  static String updateAskResponseStatus({
    required String askId,
    required String responseId,
  }) => '$_askApiBase/asks/$askId/responses/$responseId';

  // ---------------------------------------------------------------------------
  // PART 6: STATUS & CONTACT HISTORY
  // ---------------------------------------------------------------------------
  /// API 23: Response Status History (Audit Trail)
  /// Method: GET | URL: /api/asks/{askId}/responses/{responseId}/history
  /// Returns audit log of status changes for a response
  static String askResponseHistory({
    required String askId,
    required String responseId,
  }) => '$_askApiBase/asks/$askId/responses/$responseId/history';

  /// API 24: Ask Status History (Audit Trail)
  /// Method: GET | URL: /api/asks/{askId}/history
  /// Returns timeline of status transitions for an ask
  static String askHistory(String askId) => '$_askApiBase/asks/$askId/history';

  /// API 25: Update Response Contact Info
  /// Method: PATCH | URL: /api/asks/{askId}/responses/{responseId}/contact
  /// Body: { "full_name": "...", "company_name": "...", "designation": "...", "phone": "...", "email": "..." }
  static String updateAskResponseContact({
    required String askId,
    required String responseId,
  }) => '$_askApiBase/asks/$askId/responses/$responseId/contact';

  /// API 26: Link Existing Referral to Ask
  /// Method: POST | URL: /api/asks/{askId}/referral-link
  /// Body: { "referral_id": "..." }
  static String linkReferralToAsk(String askId) =>
      '$_askApiBase/asks/$askId/referral-link';

  // ---------------------------------------------------------------------------
  // 3 DEDICATED ASKS FLOWS: 9 CORE ENDPOINTS (Global Feed, My History, Leaderboard)
  // ---------------------------------------------------------------------------
  // Flow 1: Collaboration
  static String get collaborationGlobalFeed => '$_askApiBase/asks/collaboration/global';
  static String get collaborationMyAsks => '$_askApiBase/asks/collaboration/my';
  static String get collaborationLeaderboard => '$_askApiBase/asks/collaboration/leaderboard';

  // Flow 2: Referral
  static String get referralGlobalFeed => '$_askApiBase/asks/referral/global';
  static String get referralMyAsks => '$_askApiBase/asks/referral/my';
  static String get referralLeaderboard => '$_askApiBase/asks/referral/leaderboard';

  // Flow 3: Get Help
  static String get helpGlobalFeed => '$_askApiBase/asks/help/global';
  static String get helpMyAsks => '$_askApiBase/asks/help/my';
  static String get helpLeaderboard => '$_askApiBase/asks/help/leaderboard';

  // Ask Response & Referral Direct Status Update (Alternative helper)
  static String updateAskResponseDirectStatus(String responseId) =>
      '$_askApiBase/asks/responses/$responseId/status';
  static String referralStatus(String referralId) =>
      '$_askApiBase/asks/referral/$referralId/status';
  static String askReferralStatus(String referralId) =>
      '$_askApiBase/asks/referral/$referralId/status';

  // Highlights & Impact Sub-Features
  static const String referralMembers = '/referrals/members';
  static const String generateReferralCode = '/referrals/generate';
  static const String topIntroducers = '/members/top-introducers';
  static const String introducedPeers = '/profile/introduced-peers';
  static const String lastMonthActivity = '/profile/last-month-activity';
  static const String peerMonthlyImpactScript = '/peer-monthly-impact-script';
  static const String lifeImpactHistory = '/life-impact/history';
  static const String lifeImpact = '/life-impact';
  static const String lifeImpactActions = '/impacts/actions';
  static const String coinsHistory = '/coins/history';
  static const String coinsBalance = '/coins/balance';
  static const String coinClaims = '/coin-claims';
  static const String coinClaimActivities = '/coin-claims/activities';
  static const String myCoinClaims = '/coin-claims/my';
  static const String milestones = '/milestones';
  static String latestMilestone(String userId) =>
      '/users/$userId/milestone/latest';
  static String milestoneHistory(String userId) =>
      '/users/$userId/milestone/history';

  // Certifications
  static const String leadershipCertification = '/leadership-certification';
  static const String leadershipCertificationQuestions =
      '/leadership-certification/questions';
  static const String entrepreneurCertification = '/entrepreneur-certification';
  static const String entrepreneurCertificationQuestions =
      '/entrepreneur-certification/questions';
  static String userCertifications(String userId) =>
      '/certifications/user/$userId';

  // Leadership Role & Recommend Peer & Register Visitor
  static const String leaderInterest = '/forms/leader-interest';
  static const String recommendPeer = '/forms/recommend-peer';
  static const String recommendPeerMy = '/forms/recommend-peer/my';
  static const String registerVisitor = '/forms/register-visitor';
  static const String registerVisitorMy = '/forms/register-visitor/my';


  // Chat System (Direct 1-to-1, Circle Group, Circle Leadership)
  static const String chats = '/chats';
  static String chatDetail(String id) => '/chats/$id';
  static String chatMessages(String chatId) => '/chats/$chatId/messages';
  static String sendChatMessage(String chatId) => '/chats/$chatId/messages';
  static String markChatRead(String chatId) => '/chats/$chatId/mark-read';
  static String chatTypingStart(String chatId) => '/chats/$chatId/typing/start';
  static String chatTypingStop(String chatId) => '/chats/$chatId/typing/stop';
  static String deleteMessageForMe(String messageId) =>
      '/messages/$messageId/delete-for-me';
  static String deleteMessageForEveryone(String messageId) =>
      '/messages/$messageId/delete-for-everyone';

  // Circle Group Chat
  static String circleChatMessages(String circleId) =>
      '/circles/$circleId/chat/messages';
  static String sendCircleChatMessage(String circleId) =>
      '/circles/$circleId/chat/messages';
  static String markCircleChatRead(String circleId) =>
      '/circles/$circleId/chat/messages/read';
  static String circleMessageReads(String circleId, String messageId) =>
      '/circles/$circleId/chat/messages/$messageId/reads';
  static String deleteCircleMessageForMe(String circleId, String messageId) =>
      '/circles/$circleId/chat/messages/$messageId/delete-for-me';
  static String deleteCircleMessageForAll(String circleId, String messageId) =>
      '/circles/$circleId/chat/messages/$messageId';

  // Circle Leadership Chat
  static String circleLeadershipMembers(String circleId) =>
      '/circles/$circleId/leadership-chat/members';
  static String circleLeadershipMessages(String circleId) =>
      '/circles/$circleId/leadership-chat/messages';
  static String sendCircleLeadershipMessage(String circleId) =>
      '/circles/$circleId/leadership-chat/messages';
  static String markCircleLeadershipRead(String circleId) =>
      '/circles/$circleId/leadership-chat/messages/read';
  static String deleteCircleLeadershipMessageForMe(
    String circleId,
    String messageId,
  ) => '/circles/$circleId/leadership-chat/messages/$messageId/delete-for-me';
  static String deleteCircleLeadershipMessageForEveryone(
    String circleId,
    String messageId,
  ) =>
      '/circles/$circleId/leadership-chat/messages/$messageId/delete-for-everyone';
}
