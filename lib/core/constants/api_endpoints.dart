import 'app_environment.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl => AppEnvironment.baseUrl;

  static const String requestOtp = '/auth/request-otp';
  static const String verifyOtp = '/auth/verify-otp';
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

  // Peers & Connections
  static const String membersLimited = '/members/limited';
  static String member(String id) => '/members/$id';
  static String followUser(String userId) => '/users/$userId/follow';
  static String unfollowUser(String userId) => '/users/$userId/unfollow';
  static String memberFollow(String memberId) => '/members/$memberId/follow';
  static String memberUnfollow(String memberId) => '/members/$memberId/unfollow';
  static const String connections = '/connections';
  static const String connectionRequests = '/me/connection-requests';
  static const String sentConnectionRequests = '/connections/sent';
  static String memberConnections(String id) => '/members/$id/connections';
  static String acceptConnection(String id) =>
      '/members/$id/connections/accept';
  static String cancelSentConnection(String requestId) =>
      '/connections/sent/$requestId';
  static String memberBookmark(String id) => '/members/$id/bookmark';

  // Online & Presence Status
  static const String onlineHeartbeat = '/members/online-heartbeat';
  static const String onlineOffline = '/members/online-offline';
  static const String updateOnlineStatus = '/members/update-online-status';
  static const String membersOnlineStatus = '/members/online-status';
  static const String connectionsOnlineStatus = '/members/my-connections-online-status';
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
  static const String circleCategories = '/circle-categories';
  static String circleDetail(String id) => '/circles/$id';
  static String circleMembers(String id) => '/circles/$id/members';
  static String circleOpenCategories(String circleId) => '/circles/$circleId/open-categories';
  static String circleClosedCategories(String circleId) => '/circles/$circleId/closed-categories';
  static const String circleJoinRequests = '/circle-join-requests';
  static const String myCircleJoinRequests = '/circle-join-requests/my';
  static String circleJoinRequestStatus(String id) => '/circle-join-requests/$id/status';
  static String cancelCircleJoinRequest(String id) => '/circle-join-requests/$id';

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
  static String billingInvoiceDetail(String invoiceId) => '/billing/invoices/$invoiceId';
  static String billingInvoicePdf(String invoiceId) => '/billing/invoices/$invoiceId/pdf';

  // Testimonials
  static const String testimonials = '/testimonials';
  static String userTestimonials(String userId) => '/users/$userId/testimonials';
  static const String receivedTestimonials = '/activities/testimonials?filter=received';
  static const String givenTestimonials = '/activities/testimonials?filter=given';
  static const String testimonialsReceived = '/testimonials/received';
  static const String testimonialsGiven = '/testimonials/given';

  // Business Deals
  static const String businessDeals = '/activities/business-deals';
  static String singleBusinessDeal(String id) => '/activities/business-deals/$id';
  static const String receivedBusinessDeals = '/activities/business-deals?filter=received';
  static const String givenBusinessDeals = '/activities/business-deals?filter=given';
  static String userBusinessDeals(String userId) => '/users/$userId/business-deals';

  // Referrals
  static const String activitiesReferrals = '/activities/referrals';
  static const String referralStatuses = '/activities/referrals/statuses';
  static String updateReferralStatus(String id) => '/activities/referrals/$id/status';
  static const String referralsStats = '/referrals/stats';
  static const String peerReferrals = '/peer-referrals';
  static const String receivedReferrals = '/activities/referrals?filter=received';
  static const String givenReferrals = '/activities/referrals?filter=given';

  // Leaderboards & Coins & Impacts
  static const String leaderboardCoins = '/leaderboards/coins';
  static const String leaderboardImpacts = '/leaderboards/impacts';
  static const String coinGuidelines = '/coin-guidelines';
  static const String impactGuidelines = '/impact-guidelines';

  // P2P / 121 Meetings - Completed & History
  static const String activitiesP2pMeetings = '/activities/p2p-meetings';
  static const String givenP2pMeetings = '/activities/p2p-meetings?filter=given';
  static const String receivedP2pMeetings = '/activities/p2p-meetings?filter=received';
  static String singleP2pMeeting(String id) => '/activities/p2p-meetings/$id';
  static String userP2pMeetings(String userId) => '/p2p-meetings/user/$userId';

  // P2P / 121 Meetings - Scheduled Requests & Rescheduling
  static const String p2pMeetingRequests = '/p2p-meeting-requests';
  static const String p2pMeetingRequestsInbox = '/p2p-meeting-requests/inbox';
  static const String p2pMeetingRequestsSent = '/p2p-meeting-requests/sent';
  static String singleP2pMeetingRequest(String id) => '/p2p-meeting-requests/$id';
  static String acceptP2pMeetingRequest(String id) => '/p2p-meeting-requests/$id/accept';
  static String rejectP2pMeetingRequest(String id) => '/p2p-meeting-requests/$id/reject';
  static String cancelP2pMeetingRequest(String id) => '/p2p-meeting-requests/$id/cancel';
  static String rescheduleP2pMeetingRequest(String id) => '/p2p-meeting-requests/$id/reschedule';
  static const String pendingRescheduleRequestsReceived = '/p2p-meeting-reschedule-requests/pending-received';
  static String approveRescheduleRequest(String id) => '/p2p-meeting-reschedule-requests/$id/approve';
  static String rejectRescheduleRequest(String id) => '/p2p-meeting-reschedule-requests/$id/reject';
  static const String activityCreatives = '/activity-creatives';

  // Menu & Inner Screens
  static const String circulars = '/circulars';
  static String circularDetail(String id) => '/circulars/$id';
  static const String eventGalleries = '/events/galleries';
  static String eventGalleryDetail(String id) => '/events/galleries/$id';
  static const String eventVideos = '/events/videos';
  static const String tutorials = '/tutorials';
  static const String myInvoices = '/my/invoices';
  static String downloadInvoice(String id) => '/my/invoices/$id/download';
  static const String blockedUsers = '/blocked-users';
  static String unblockUser(String id) => '/blocked-users/$id';
  static const String feedback = '/feedback';
  static const String feedbackCategories = '/feedback/categories';
  static const String support = '/support';
  static const String supportTickets = '/support/tickets';
  static const String adminSupportTickets = '/admin/support-tickets';
  static const String activitySummary = '/profile/activity-summary';
  static const String newsletter = '/newsletter/latest';
  static const String rewardsStore = '/rewards/store/items';
  static const String industryInsights = '/insights/industry';
  static const String dailySummary = '/activities/daily-summary';
  static const String myGlobalPeerCertificate = '/my/global-peer-certificate';
  static const String regenerateGlobalPeerCertificate = '/my/global-peer-certificate/regenerate';
  static const String becomeAMentor = '/become-a-mentor';
  static const String becomeASpeaker = '/become-a-speaker';
  static const String partnerWithUs = '/partner-with-us';
  static const String storySubmission = '/story-submission';
  static const String storyStatus = '/story-status';

  // Requirements & Asks
  static const String activitiesRequirements = '/activities/requirements';
  static const String myRequirements = '/activities/requirements?filter=my';
  static const String incompletedRequirements = '/requirements/incompleted';
  static String singleRequirement(String id) => '/activities/requirements/$id';
  static String closeRequirement(String id) => '/requirements/$id/close';

  // Highlights & Impact Sub-Features
  static const String referralMembers = '/referrals/members';
  static const String generateReferralCode = '/referrals/generate';
  static const String topIntroducers = '/members/top-introducers';
  static const String introducedPeers = '/profile/introduced-peers';
  static const String lastMonthActivity = '/profile/last-month-activity';
  static const String peerMonthlyImpactScript = '/peer-monthly-impact-script';
  static const String lifeImpactHistory = '/life-impact/history';
  static const String lifeImpact = '/life-impact';
  static const String lifeImpactActions = '/life-impact/actions';
  static const String coinsHistory = '/coins/history';
  static const String coinsBalance = '/coins/balance';
  static const String milestones = '/milestones';

  // Certifications
  static const String leadershipCertification = '/leadership-certification';
  static const String leadershipCertificationQuestions = '/leadership-certification/questions';
  static const String entrepreneurCertification = '/entrepreneur-certification';
  static const String entrepreneurCertificationQuestions = '/entrepreneur-certification/questions';
  static String userCertifications(String userId) => '/certifications/user/$userId';

  // Leadership Role & Recommend Peer
  static const String leaderInterest = '/forms/leader-interest';
  static const String recommendPeer = '/forms/recommend-peer';
}  