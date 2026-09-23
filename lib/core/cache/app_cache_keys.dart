class AppCacheBoxes {
  AppCacheBoxes._();

  static const String authBox = 'peers_auth_box';
  static const String profileBox = 'peers_profile_box';
  static const String sessionBox = 'peers_session_box';
  static const String appCacheBox = 'peers_offline_data_box';
  static const String homeFeedBox = 'peers_home_feed_box';
  static const String peersBox = 'peers_data_box';
  static const String notificationsBox = 'peers_notifications_box';
  static const String circlesBox = 'peers_circles_box';
  static const String leaderboardBox = 'peers_leaderboard_box';
  static const String chatBox = 'peers_chat_box';
  static const String shortsBox = 'peers_shorts_box';
}

class AppCacheKeys {
  AppCacheKeys._();

  static const String authToken = 'auth_token';
  static const String authUser = 'auth_user';
  static const String lastActiveEmail = 'last_active_email';
  static const String lastSyncedAt = 'last_synced_at';
  static const String registrationDraft = 'registration_draft';

  // Home Feed Caching
  static const String timelineFeed = 'cached_timeline_feed';
  static const String brandPartners = 'cached_brand_partners';

  // Profile Caching
  static const String userProfile = 'cached_user_profile';
  static const String userPosts = 'cached_user_posts';
  static const String savedPosts = 'cached_saved_posts';

  // Peers Caching
  static const String allPeers = 'cached_all_peers';
  static const String myConnections = 'cached_my_connections';
  static const String connectionRequests = 'cached_connection_requests';
  static const String sentConnectionRequests = 'cached_sent_connection_requests';
  static const String matchPeers = 'cached_match_peers';
  static const String nearbyPeers = 'cached_nearby_peers';
  static const String bookmarkedPeers = 'cached_bookmarked_peers';

  // Notifications Caching
  static const String notifications = 'cached_notifications';

  // Circles Caching
  static const String myCircles = 'cached_my_circles';
  static const String circleCategories = 'cached_circle_categories';

  // Shorts Caching
  static const String shortsVideos = 'cached_shorts_videos';

  // Leaderboard Caching
  static const String coinsLeaderboard = 'cached_coins_leaderboard';
  static const String impactLeaderboard = 'cached_impact_leaderboard';
  static const String coinGuidelines = 'cached_coin_guidelines';
  static const String impactGuidelines = 'cached_impact_guidelines';

  // Chat Caching
  static const String directConversations = 'cached_direct_conversations';
  static String directMessages(String chatId) => 'cached_direct_msgs_$chatId';
  static String circleMessages(String circleId) => 'cached_circle_msgs_$circleId';
  static String leadershipMessages(String circleId) =>
      'cached_leadership_msgs_$circleId';
}
