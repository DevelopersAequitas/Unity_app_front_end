import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/app_update_service.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_update_dialog.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _animController;
  Timer? _navigationTimer;
  bool _isNavigated = false;
  bool _animationFinished = false;

  AppUpdateResult? _updateResult;
  bool _isCheckingUpdate = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AuthBloc>().add(const AuthCheckRequested());

    // Asynchronously perform version update check on launch
    _checkAppVersion();

    // Single playthrough animation with reliable completion listener
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationFinished = true;
          _handleNextStep();
        }
      });

    _animController.forward();

    // Safety fallback timer ensuring screen advances even if animation finishes late
    _navigationTimer = Timer(const Duration(milliseconds: 2600), () {
      _animationFinished = true;
      _handleNextStep();
    });
  }

  Future<void> _checkAppVersion() async {
    try {
      final result = await AppUpdateService.instance.checkUpdate();
      _updateResult = result;
    } catch (_) {
      _updateResult = null;
    } finally {
      _isCheckingUpdate = false;
      if (mounted && _animationFinished) {
        _handleNextStep();
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // Re-verify if force update is still active upon returning
      _checkAppVersion();
    }
  }

  void _handleNextStep() {
    if (!mounted || _isNavigated) return;

    // If update check is still in progress, wait briefly
    if (_isCheckingUpdate) return;

    final update = _updateResult;

    // 1. Mandatory Force Update -> Intercept and block access
    if (update != null && update.isForceUpdate) {
      _navigationTimer?.cancel();
      AppUpdateDialog.show(context, result: update);
      return;
    }

    // 2. Optional Update -> Show dismissible prompt with "Later" option
    if (update != null && update.isOptionalUpdate) {
      _navigationTimer?.cancel();
      _isNavigated = true;
      AppUpdateDialog.show(
        context,
        result: update,
        onDismiss: () => _performNavigation(),
      );
      return;
    }

    // 3. Up to date or network check bypassed -> proceed to App
    _performNavigation();
  }

  void _performNavigation() {
    if (!mounted) return;
    _isNavigated = true;
    _navigationTimer?.cancel();

    final authState = context.read<AuthBloc>().state;
    final target = (authState is AuthAuthenticated)
        ? AppRoutes.home
        : AppRoutes.welcome;

    Navigator.of(context).pushReplacementNamed(target);
  }

  void _onAnimationLoaded(LottieComposition composition) {
    if (mounted) {
      _animController.duration = composition.duration;
      if (!_animController.isAnimating && !_animController.isCompleted) {
        _animController.forward();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
