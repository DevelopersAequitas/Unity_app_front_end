import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import '../router/app_router.dart';

class DeepLinkService {
  DeepLinkService._();
  static final DeepLinkService instance = DeepLinkService._();

  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> init() async {
    _appLinks = AppLinks();

    // 1. Handle app launch from terminated state
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('[DeepLinkService] Initial URI received: $initialUri');
        _handleUriWithRetry(initialUri);
      }
    } catch (e) {
      debugPrint('[DeepLinkService] Error getting initial link: $e');
    }

    // 2. Handle links while app is running in background/foreground
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        debugPrint('[DeepLinkService] Stream URI received: $uri');
        _handleUriWithRetry(uri);
      },
      onError: (err) {
        debugPrint('[DeepLinkService] Stream error: $err');
      },
    );
  }

  void _handleUriWithRetry(Uri uri, {int retryCount = 0}) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      if (retryCount < 10) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _handleUriWithRetry(uri, retryCount: retryCount + 1);
        });
      }
      return;
    }

    _handleUri(uri, context);
  }

  void _handleUri(Uri uri, BuildContext context) {
    debugPrint('[DeepLinkService] Handling URI: $uri (path: ${uri.path}, host: ${uri.host}, query: ${uri.queryParameters})');

    String? type = uri.queryParameters['type'];
    String? id = uri.queryParameters['id'];

    // Handle path-based links e.g. /profile/123 or /post/123
    if (type == null || type.isEmpty) {
      if (uri.pathSegments.isNotEmpty) {
        final first = uri.pathSegments.first.toLowerCase();
        if (first == 'share') {
          type = uri.queryParameters['type'];
        } else if (first == 'profile' || first == 'peer_profile') {
          type = 'peer_profile';
          if (uri.pathSegments.length > 1) {
            id = uri.pathSegments[1];
          }
        } else if (first == 'post' || first == 'posts') {
          type = 'post';
          if (uri.pathSegments.length > 1) {
            id = uri.pathSegments[1];
          }
        } else if (first == 'connections') {
          type = 'connections';
        } else if (first == 'requests') {
          type = 'requests';
        } else if (first == 'join_circle' || first == 'joincircle') {
          type = 'join_circle';
        }
      }
    }

    // Fallback to host for scheme links: peersunity://peer_profile?id=...
    if (type == null || type.isEmpty) {
      type = uri.host;
    }

    if (id == null || id.isEmpty) {
      id = uri.queryParameters['id'] ?? uri.queryParameters['profile_id'] ?? uri.queryParameters['post_id'];
    }

    final cleanId = id?.replaceAll('/', '').trim();

    switch (type.toLowerCase()) {
      case 'peer_profile':
      case 'profile':
      case 'peer':
        if (cleanId != null && cleanId.isNotEmpty) {
          Navigator.pushNamed(context, AppRoutes.peerProfile, arguments: cleanId);
        }
        break;

      case 'post':
      case 'posts':
        // Navigate to home / timeline feed
        Navigator.pushNamed(context, AppRoutes.home);
        break;

      case 'connections':
      case 'my_connections':
        Navigator.pushNamed(context, AppRoutes.connections);
        break;

      case 'requests':
      case 'peer_requests':
        Navigator.pushNamed(context, AppRoutes.peerRequests);
        break;

      case 'join_circle':
      case 'circle':
      case 'circles':
        Navigator.pushNamed(context, AppRoutes.home);
        break;

      case 'testimonial':
      case 'testimonials':
        Navigator.pushNamed(context, AppRoutes.testimonials);
        break;

      default:
        debugPrint('[DeepLinkService] Unhandled deep link type: $type');
        break;
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
