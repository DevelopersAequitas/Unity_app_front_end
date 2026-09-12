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
  static const String brandPartners = '/brand-partners';
  static String postLike(String id) => '/posts/$id/like';
  static String postSave(String id) => '/posts/$id/save';

  // Peers & Connections
  static const String membersLimited = '/members/limited';
  static String member(String id) => '/members/$id';
  static String followUser(String userId) => '/users/$userId/follow';
  static String unfollowUser(String userId) => '/users/$userId/unfollow';
  static const String connections = '/connections';
  static const String connectionRequests = '/me/connection-requests';
  static const String sentConnectionRequests = '/connections/sent';
  static String memberConnections(String id) => '/members/$id/connections';
  static String acceptConnection(String id) =>
      '/members/$id/connections/accept';
  static String cancelSentConnection(String requestId) =>
      '/connections/sent/$requestId';
  static String memberBookmark(String id) => '/members/$id/bookmark';

  // Profile & Uploads
  static const String profile = '/profile';
  static const String profilePosts = '/profile/posts';
  static String userPosts(String userId) => '/users/$userId/posts';
  static const String fileUpload = '/files/upload';
}
