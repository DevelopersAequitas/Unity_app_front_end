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
  static String billingCheckoutStatus(String hostedPageId) => '/billing/checkout/$hostedPageId/status';
  static const String subscriptionsHistory = '/billing/subscriptions-history';
  static const String billingInvoices = '/billing/invoices';
  static String billingInvoiceDetail(String invoiceId) => '/billing/invoices/$invoiceId';
  static String billingInvoicePdf(String invoiceId) => '/billing/invoices/$invoiceId/pdf';
}


