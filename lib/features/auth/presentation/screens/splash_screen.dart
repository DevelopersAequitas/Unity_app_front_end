import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/splash_content.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  Timer? _navigationTimer;
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthCheckRequested());

    // Single playthrough animation with reliable completion listener
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2400),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _navigateToTarget();
          }
        });

    _animController.forward();

    // Safety fallback timer ensuring screen advances even if animation finishes late
    _navigationTimer = Timer(const Duration(milliseconds: 2600), () {
      _navigateToTarget();
    });
  }

  void _onAnimationLoaded(LottieComposition composition) {
    if (mounted) {
      _animController.duration = composition.duration;
      if (!_animController.isAnimating && !_animController.isCompleted) {
        _animController.forward();
      }
    }
  }

  void _navigateToTarget() {
    if (!mounted || _isNavigated) return;
    _isNavigated = true;
    _navigationTimer?.cancel();

    final authState = context.read<AuthBloc>().state;
    final target = (authState is AuthAuthenticated)
        ? AppRoutes.home
        : AppRoutes.welcome;

    Navigator.of(context).pushReplacementNamed(target);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      body: ResponsiveContainer(
        child: SplashContent(
          animController: _animController,
          onLoaded: _onAnimationLoaded,
        ),
      ),
    );
  }
}
