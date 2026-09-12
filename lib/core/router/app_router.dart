import 'package:flutter/material.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/peers/presentation/screens/connections_screen.dart';
import '../../features/peers/presentation/screens/matches_screen.dart';
import '../../features/peers/presentation/screens/near_me_screen.dart';
import '../../features/peers/presentation/screens/peer_requests_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String verifyOtp = '/verify-otp';
  static const String register = '/register';
  static const String home = '/home';
  static const String connections = '/connections';
  static const String peerRequests = '/peer-requests';
  static const String nearMe = '/near-me';
  static const String matches = '/matches';
  static const String profile = '/profile';
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case AppRoutes.verifyOtp:
        String email = '';
        String channel = 'email';
        if (settings.arguments is Map<String, dynamic>) {
          final map = settings.arguments as Map<String, dynamic>;
          email = map['email'] as String? ?? '';
          channel = map['channel'] as String? ?? 'email';
        } else if (settings.arguments is String) {
          email = settings.arguments as String;
        }
        return MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(email: email, channel: channel),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case AppRoutes.connections:
        return MaterialPageRoute(
          builder: (_) => const ConnectionsScreen(),
          settings: settings,
        );
      case AppRoutes.peerRequests:
        return MaterialPageRoute(
          builder: (_) => const PeerRequestsScreen(),
          settings: settings,
        );
      case AppRoutes.nearMe:
        return MaterialPageRoute(
          builder: (_) => const NearMeScreen(),
          settings: settings,
        );
      case AppRoutes.matches:
        return MaterialPageRoute(
          builder: (_) => const MatchesScreen(),
          settings: settings,
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
    }
  }
}

