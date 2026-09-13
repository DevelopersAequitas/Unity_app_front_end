class AppCacheBoxes {
  AppCacheBoxes._();

  static const String authBox = 'peers_auth_box';
  static const String sessionBox = 'peers_session_box';
  static const String appCacheBox = 'peers_offline_data_box';
  static const String homeFeedBox = 'peers_home_feed_box';
  static const String peersBox = 'peers_data_box';
  static const String notificationsBox = 'peers_notifications_box';
  static const String circlesBox = 'peers_circles_box';
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

  // Peers Caching
  static const String allPeers = 'cached_all_peers';
  static const String myConnections = 'cached_my_connections';
  static const String connectionRequests = 'cached_connection_requests';
  static const String sentConnectionRequests = 'cached_sent_connection_requests';
  static const String matchPeers = 'cached_match_peers';

  // Notifications Caching
  static const String notifications = 'cached_notifications';

  // Circles Caching
  static const String myCircles = 'cached_my_circles';
  static const String circleCategories = 'cached_circle_categories';
}
