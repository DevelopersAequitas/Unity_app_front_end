import 'package:flutter/foundation.dart';
import '../../app/app_config.dart';

enum Flavor { dev, prod }

enum Product { peers }

class AppEnvironment {
  static Product get product => Product.peers;

  static Flavor flavor = kDebugMode ? Flavor.dev : Flavor.prod;

  static const List<String> devEmails = [
    'usera125@gmail.com',
    'hardik@gmail.com',
    'harsh@gmail.com',
    'urvashi@gmail.com',
    'dhruvil@gmail.com',
    'jay@gmail.com',
    'chirag@gmail.com',
    'mohit@gmail.com',
    'rahul@gmail.com',
    'vinit@gmail.com',
    'vinitchavda222@gmail.com',
    'malichirag1369@gmail.com',
    'krushali@gmail.com',
    'dev1@gmail.com',
    'dev2@gmail.com',
    'dev3@gmail.com',
    'test@gmail.com',
    'test1@gmail.com',
    'tester@gmail.com',
    'tester1@gmail.com',
  ];

  static const List<String> devPasswordEmails = [
    'usera125@gmail.com',
    'hardik@gmail.com',
    'harsh@gmail.com',
    'urvashi@gmail.com',
    'dhruvil@gmail.com',
    'jay@gmail.com',
    'krushali@gmail.com',
    'chirag@gmail.com',
    'mohit@gmail.com',
    'rahul@gmail.com',
    'vinit@gmail.com',
    'dev1@gmail.com',
    'dev2@gmail.com',
    'dev3@gmail.com',
    'test@gmail.com',
    'test1@gmail.com',
    'tester@gmail.com',
    'tester1@gmail.com',
  ];

  static const List<String> devPhones = [
    '916353025164',
    '6353025164',
    '919904978744',
    '9904978744',
    '9537639248',
    '919537639248',
  ];

  static String get baseUrl {
    switch (flavor) {
      case Flavor.prod:
        // Temporarily pointing to dev base URL for testing
        return 'https://dev.peersunity.com/api/v1';
      case Flavor.dev:
        return 'https://dev.peersunity.com/api/v1';
    }
  }

  static String get packageName => AppConfig.isInitialized
      ? AppConfig.current.androidPackageName
      : 'com.peers.peersunity';

  static String get playStoreUrl =>
      'https://play.google.com/store/apps/details?id=$packageName';

  static String get appStoreUrl =>
      'https://apps.apple.com/in/app/peers-global-unity/id6739198477';

  static String get appStoreId => '6739198477';

  static String get appName =>
      AppConfig.isInitialized ? AppConfig.current.appName : 'Peers Global Unity';

  static String get appScheme =>
      AppConfig.isInitialized ? AppConfig.current.appScheme : 'peersunity';

  static String get appDomain => AppConfig.isInitialized
      ? AppConfig.current.appDomain
      : (flavor == Flavor.dev ? 'dev.peersunity.com' : 'peersunity.com');

  /// 1. Peer Profile Deep Link
  static String getPeerProfileDeepLink(String peerId) {
    return Uri.https(appDomain, '/share', {
      'type': 'peer_profile',
      'id': peerId,
    }).toString();
  }

  /// 2. Post / Recognition Deep Link
  static String getPostDeepLink(String postId) {
    return Uri.https(appDomain, '/share', {
      'type': 'post',
      'id': postId,
    }).toString();
  }

  /// 3. Circle Deep Link
  static String getCircleDeepLink(String circleId) {
    return Uri.https(appDomain, '/share', {
      'type': 'circle',
      'id': circleId,
    }).toString();
  }

  /// 4. Join Circle Deep Link
  static String get joinCircleDeepLink =>
      'https://$appDomain/share?type=join_circle';

  /// 5. Connections Deep Link
  static String get connectionsDeepLink =>
      'https://$appDomain/share?type=connections';

  /// 6. Requests Deep Link
  static String get requestsDeepLink =>
      'https://$appDomain/share?type=requests';

  /// 7. Referral / Register Deep Link
  static String getRegisterDeepLink(String refCode) {
    return Uri.https(appDomain, '/register', {
      'ref': refCode,
    }).toString();
  }

  /// 8. Custom Scheme deep link to navigate directly to the Join Circle/Chapter tab
  static String get joinCircleSchemeLink => '$appScheme://join_circle';

  /// 9. Universal deep link URL to navigate directly to an event pass / QR screen
  static String getEventQrDeepLink(
    String eventId, {
    String? occurrenceId,
    String? registrationId,
  }) {
    final queryParams = <String, String>{'type': 'event_qr', 'id': eventId};
    if (occurrenceId != null && occurrenceId.isNotEmpty) {
      queryParams['occurrence_id'] = occurrenceId;
    }
    if (registrationId != null && registrationId.isNotEmpty) {
      queryParams['registration_id'] = registrationId;
    }
    return Uri.https(appDomain, '/share', queryParams).toString();
  }

  /// Custom Scheme deep link to navigate directly to an event pass / QR screen
  static String getEventQrSchemeLink(
    String eventId, {
    String? occurrenceId,
    String? registrationId,
  }) {
    final query = <String, String>{
      'id': eventId,
      if (occurrenceId != null && occurrenceId.isNotEmpty)
        'occurrence_id': occurrenceId,
      if (registrationId != null && registrationId.isNotEmpty)
        'registration_id': registrationId,
    };
    return Uri(
      scheme: appScheme,
      host: 'event_qr',
      queryParameters: query,
    ).toString();
  }

  /// 10. Testimonial Deep Link
  static String getTestimonialDeepLink({
    String? testimonialId,
    String? peerId,
    String? tab,
  }) {
    final queryParams = <String, String>{
      'type': 'testimonial',
      if (testimonialId != null && testimonialId.isNotEmpty) 'id': testimonialId,
      if (peerId != null && peerId.isNotEmpty) 'peer_id': peerId,
      if (tab != null && tab.isNotEmpty) 'tab': tab,
    };
    return Uri.https(appDomain, '/share', queryParams).toString();
  }

  /// 11. Business Deal Deep Link
  static String getBusinessDealDeepLink({
    String? dealId,
    String? peerId,
    String? tab,
  }) {
    final queryParams = <String, String>{
      'type': 'business_deal',
      if (dealId != null && dealId.isNotEmpty) 'id': dealId,
      if (peerId != null && peerId.isNotEmpty) 'peer_id': peerId,
      if (tab != null && tab.isNotEmpty) 'tab': tab,
    };
    return Uri.https(appDomain, '/share', queryParams).toString();
  }

  /// 12. Referral Deep Link
  static String getReferralDeepLink({
    String? referralId,
    String? peerId,
    String? tab,
  }) {
    final queryParams = <String, String>{
      'type': 'referral',
      if (referralId != null && referralId.isNotEmpty) 'id': referralId,
      if (peerId != null && peerId.isNotEmpty) 'peer_id': peerId,
      if (tab != null && tab.isNotEmpty) 'tab': tab,
    };
    return Uri.https(appDomain, '/share', queryParams).toString();
  }

  /// 13. Requirement Deep Link
  static String getRequirementDeepLink(String requirementId) {
    return Uri.https(appDomain, '/share', {
      'type': 'requirement',
      'id': requirementId,
    }).toString();
  }

  /// 14. Event Deep Link
  static String getEventDeepLink(
    String eventId, {
    String? occurrenceId,
  }) {
    final queryParams = <String, String>{
      'type': 'event',
      'id': eventId,
      if (occurrenceId != null && occurrenceId.isNotEmpty)
        'occurrence_id': occurrenceId,
    };
    return Uri.https(appDomain, '/share', queryParams).toString();
  }
}

