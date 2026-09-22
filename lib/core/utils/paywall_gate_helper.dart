import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../router/app_router.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

class PaywallGateHelper {
  PaywallGateHelper._();

  static bool isPro(BuildContext context) {
    try {
      return context.read<ProfileBloc>().state.profile?.isPro ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Checks if the current user is a Pro member.
  /// If not, navigates directly to the Membership Paywall.
  /// Returns `true` if user is Pro, `false` otherwise.
  static bool checkPro(
    BuildContext context, {
    String? message,
  }) {
    if (isPro(context)) return true;
    Navigator.pushNamed(context, AppRoutes.membershipPaywall);
    return false;
  }
}
