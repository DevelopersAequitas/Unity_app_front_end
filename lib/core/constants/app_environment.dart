import 'package:flutter/foundation.dart';

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
        return 'https://peersunity.com/api/v1';
      case Flavor.dev:
        return 'https://dev.peersunity.com/api/v1';
    }
  }

  static String get packageName => 'com.peers.peersunity';

  static String get playStoreUrl =>
      'https://play.google.com/store/apps/details?id=$packageName';

  static String get appStoreUrl =>
      'https://apps.apple.com/in/app/peers-global-unity/id6739198477';

  static String get appStoreId => '6739198477';

  static String get appName => 'Peers Global Unity';

  static String get appScheme => 'peersunity';

  static String get appDomain =>
      flavor == Flavor.dev ? 'dev.peersunity.com' : 'peersunity.com';

  /// Universal deep link URL to navigate directly to the Join Circle/Chapter tab
  static String get joinCircleDeepLink =>
      'https://$appDomain/share?type=join_circle';

  /// Custom Scheme deep link to navigate directly to the Join Circle/Chapter tab
  static String get joinCircleSchemeLink => '$appScheme://join_circle';

  /// Universal deep link URL to navigate directly to an event pass / QR screen
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
}
