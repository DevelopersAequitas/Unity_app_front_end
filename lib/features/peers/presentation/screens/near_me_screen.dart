import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/near_me_bloc.dart';
import '../bloc/near_me_event.dart';
import '../bloc/near_me_state.dart';
import '../widgets/near_me_peer_card.dart';
import '../widgets/near_me_radius_selector.dart';
import '../widgets/peers_skeleton_loader.dart';

class NearMeScreen extends StatefulWidget {
  final bool isTab;
  const NearMeScreen({super.key, this.isTab = false});

  @override
  State<NearMeScreen> createState() => _NearMeScreenState();
}

class _NearMeScreenState extends State<NearMeScreen> {
  final MapController _mapController = MapController();
  bool _showRadiusSelector = false;

  // Default coordinate center (Ahmedabad / user city)
  static const LatLng _defaultCenter = LatLng(23.0225, 72.5714);

  @override
  void initState() {
    super.initState();
    if (!widget.isTab) {
      final bloc = context.read<NearMeBloc>();
      if (bloc.state.status == NearMeStatus.initial) {
        bloc.add(const NearMeFetchRequested());
      }
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;

    return Scaffold(
      backgroundColor: isDark ? AppColor.darkBackground : AppColor.lightSurface,
      appBar: widget.isTab
          ? null
          : AppCommonBar(
              title: 'Nearby Peers',
              showBack: true,
              showSearch: false,
              showNotifications: false,
              showProfile: false,
              onBackTap: () => Navigator.pop(context),
              actions: [
                // Eye / Filter Radius button
                IconButton(
            icon: Icon(
              _showRadiusSelector
                  ? Icons.visibility_rounded
                  : Icons.visibility_outlined,
              size: 22,
              color: _showRadiusSelector ? AppColor.primaryBlue : iconColor,
            ),
            tooltip: 'Toggle Radius Filter',
            onPressed: () {
              setState(() => _showRadiusSelector = !_showRadiusSelector);
            },
          ),
          // Refresh button
          IconButton(
            icon: Icon(Icons.refresh_rounded, size: 24, color: iconColor),
            tooltip: 'Refresh Nearby',
            onPressed: () {
              context.read<NearMeBloc>().add(
                const NearMeFetchRequested(refresh: true),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocConsumer<NearMeBloc, NearMeState>(
        listenWhen: (prev, curr) =>
            curr.errorMessage != null && prev.errorMessage != curr.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          final userCenter =
              (state.userLatitude != null &&
                  state.userLongitude != null &&
                  state.userLatitude != 0)
              ? LatLng(state.userLatitude!, state.userLongitude!)
              : _defaultCenter;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Half: Map View with Pins & Compass
              SizedBox(
                height: 270,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: userCenter,
                        initialZoom: 12.5,
                        minZoom: 4,
                        maxZoom: 18,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.peersglobal.unity_app',
                        ),
                        MarkerLayer(
                          markers: _buildMapMarkers(state, userCenter),
                        ),
                      ],
                    ),

                    // Top Left Floating Compass
                    Positioned(
                      top: 14,
                      left: 14,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.3,
                            child: const Icon(
                              Icons.navigation_rounded,
                              size: 20,
                              color: AppColor.error,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom Left Map Provider Attribution
                    Positioned(
                      bottom: 8,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '© OpenStreetMap',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightTextSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expandable Radius Selector (when eye/filter icon is active)
              AnimatedCrossFade(
                firstChild: Container(
                  color: AppColor.lightSurfaceMuted,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: NearMeRadiusSelector(
                    selectedRadius: state.selectedRadiusKm,
                    onRadiusChanged: (r) {
                      context.read<NearMeBloc>().add(NearMeRadiusChanged(r));
                    },
                  ),
                ),
                secondChild: const SizedBox.shrink(),
                crossFadeState: _showRadiusSelector
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 200),
              ),

              // Section Header: Nearby Peers
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                decoration: const BoxDecoration(
                  color: AppColor.lightSurface,
                  border: Border(
                    bottom: BorderSide(color: AppColor.lightBorder, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Nearby Peers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColor.lightTextPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    // const Spacer(),
                    // if (state.nearbyPeers.isNotEmpty)
                    //   Text(
                    //     '${state.nearbyPeers.length} Peers found',
                    //     style: const TextStyle(
                    //       fontSize: 12,
                    //       fontWeight: FontWeight.w600,
                    //       color: AppColor.lightTextSecondary,
                    //     ),
                    //   ),
                  ],
                ),
              ),

              // Bottom Half: Scrollable List of Peers
              Expanded(
                child: RefreshIndicator(
                  color: AppColor.primaryBlue,
                  onRefresh: () async {
                    context.read<NearMeBloc>().add(
                      const NearMeFetchRequested(refresh: true),
                    );
                  },
                  child:
                      state.status == NearMeStatus.loading &&
                          state.nearbyPeers.isEmpty
                      ? const PeersSkeletonLoader()
                      : state.nearbyPeers.isEmpty
                      ? _buildEmptyState()
                      : NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollUpdateNotification) {
                              if (notification.metrics.pixels >=
                                  notification.metrics.maxScrollExtent - 200) {
                                context.read<NearMeBloc>().add(
                                  const NearMeLoadMoreRequested(),
                                );
                              }
                            }
                            return false;
                          },
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount:
                                state.nearbyPeers.length +
                                (state.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.nearbyPeers.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColor.primaryBlue,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final peer = state.nearbyPeers[index];
                              return NearMePeerCard(
                                peer: peer,
                                onConnect: () {
                                  context.read<NearMeBloc>().add(
                                        NearMeConnectRequested(peer.id),
                                      );
                                },
                                onFollow: () {
                                  context.read<NearMeBloc>().add(
                                        NearMeFollowToggled(
                                          peerId: peer.id,
                                          isCurrentlyFollowing:
                                              peer.isFollowing,
                                        ),
                                      );
                                },
                                onScheduleP2P: () {
                                  // Navigate to P2P scheduling
                                },
                                onBookmark: () {
                                  context.read<NearMeBloc>().add(
                                        NearMeBookmarkToggled(
                                          peerId: peer.id,
                                          isCurrentlyBookmarked:
                                              peer.isBookmarked,
                                        ),
                                      );
                                },
                                onMessage: () {
                                  // Open message thread
                                },
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.peerProfile,
                                    arguments: peer.id,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Marker> _buildMapMarkers(NearMeState state, LatLng center) {
    final markers = <Marker>[];

    // Current User Marker
    markers.add(
      Marker(
        point: center,
        width: 44,
        height: 44,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.primaryPink.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.my_location_rounded,
              size: 24,
              color: AppColor.primaryPink,
            ),
          ),
        ),
      ),
    );

    // Nearby Peers Markers (Distribute realistically around center if coords are 0/missing)
    for (int i = 0; i < state.nearbyPeers.length; i++) {
      final peer = state.nearbyPeers[i];
      LatLng point;

      if (peer.latitude != 0 && peer.longitude != 0) {
        point = LatLng(peer.latitude, peer.longitude);
      } else {
        // Generate pseudo-coordinates dispersed within ~5-8km of center
        final angle = (i * 2.39996) + (i * 0.4);
        final dist = 0.015 + ((i % 5) * 0.018);
        point = LatLng(
          center.latitude + (dist * math.cos(angle)),
          center.longitude + (dist * math.sin(angle)),
        );
      }

      markers.add(
        Marker(
          point: point,
          width: 38,
          height: 38,
          child: const Icon(
            Icons.location_on_rounded,
            size: 34,
            color: AppColor.primaryBlue,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        alignment: Alignment.center,
        child: const Column(
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 48,
              color: AppColor.lightTextDisabled,
            ),
            SizedBox(height: 12),
            Text(
              'No peers found nearby',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColor.lightTextPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Try increasing the search radius to discover more peers.',
              style: TextStyle(
                fontSize: 13,
                color: AppColor.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
