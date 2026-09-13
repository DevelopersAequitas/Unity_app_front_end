import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/network_connectivity_service.dart';
import '../services/peers_realtime_sync_service.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/bloc/home_event.dart';
import '../../features/peers/presentation/bloc/connections_bloc.dart';
import '../../features/peers/presentation/bloc/connections_event.dart';
import '../../features/peers/presentation/bloc/matches_bloc.dart';
import '../../features/peers/presentation/bloc/matches_event.dart';
import '../../features/peers/presentation/bloc/peer_requests_bloc.dart';
import '../../features/peers/presentation/bloc/peer_requests_event.dart';
import '../../features/peers/presentation/bloc/peers_bloc.dart';
import '../../features/peers/presentation/bloc/peers_event.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/bloc/profile_posts_bloc.dart';
import '../../features/profile/presentation/bloc/profile_posts_event.dart';

class ConnectivityOverlay extends StatefulWidget {
  final Widget child;

  const ConnectivityOverlay({super.key, required this.child});

  @override
  State<ConnectivityOverlay> createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;

  StreamSubscription<NetworkStatus>? _subscription;
  NetworkStatus _status = NetworkStatus.online;
  bool _wasOffline = false;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _sizeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );

    _status = NetworkConnectivityService.instance.currentStatus;
    if (_status == NetworkStatus.offline) {
      _wasOffline = true;
      _animController.value = 1.0;
    }

    _subscription = NetworkConnectivityService.instance.onStatusChanged.listen((status) {
      _handleStatusChange(status);
    });
  }

  void _handleStatusChange(NetworkStatus newStatus) {
    if (!mounted) return;
    _dismissTimer?.cancel();

    if (newStatus == NetworkStatus.offline) {
      _wasOffline = true;
      setState(() {
        _status = NetworkStatus.offline;
      });
      _animController.forward();
    } else if (newStatus == NetworkStatus.online) {
      if (_wasOffline) {
        setState(() {
          _status = NetworkStatus.online;
        });
        _animController.forward();

        // Trigger real-time refresh on active Blocs
        _triggerOnlineRealtimeSync();

        // YouTube style: show "Back online" for 2.5 seconds, then dismiss
        _dismissTimer = Timer(const Duration(milliseconds: 2500), () {
          if (mounted) {
            _animController.reverse().then((_) {
              if (mounted) {
                setState(() {
                  _wasOffline = false;
                });
              }
            });
          }
        });
      } else {
        setState(() {
          _status = NetworkStatus.online;
        });
        _animController.reverse();
      }
    }
  }

  void _triggerOnlineRealtimeSync() {
    try {
      context.read<HomeBloc>().add(const HomeFeedRefreshRequested());
    } catch (_) {}
    try {
      context.read<ProfileBloc>().add(const ProfileFetchRequested(forceRefresh: true));
    } catch (_) {}
    try {
      context.read<ProfilePostsBloc>().add(const ProfilePostsRefreshRequested());
    } catch (_) {}
    try {
      context.read<PeersBloc>().add(const PeersRefreshRequested());
    } catch (_) {}
    try {
      context.read<ConnectionsBloc>().add(const ConnectionsRefreshRequested());
    } catch (_) {}
    try {
      context.read<PeerRequestsBloc>().add(const PeerRequestsRefreshRequested());
    } catch (_) {}
    try {
      context.read<MatchesBloc>().add(const MatchesFetchRequested());
    } catch (_) {}
    try {
      PeersRealtimeSyncService.instance.syncNow();
    } catch (_) {}
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _subscription?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Expanded(
          child: widget.child,
        ),
        SizeTransition(
          sizeFactor: _sizeAnimation,
          alignment: Alignment.topCenter,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildStickyBar(bottomInset),
          ),
        ),
      ],
    );
  }

  Widget _buildStickyBar(double bottomInset) {
    final isOffline = _status == NetworkStatus.offline;

    return Material(
      color: isOffline ? const Color(0xFF212121) : const Color(0xFF0F9D58),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 5.5,
          bottom: bottomInset > 0 ? bottomInset + 2 : 5.5,
          left: 12,
          right: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isOffline ? Icons.wifi_off_rounded : Icons.check_circle_rounded,
              size: 13,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              isOffline ? "You're offline" : 'Back online',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
