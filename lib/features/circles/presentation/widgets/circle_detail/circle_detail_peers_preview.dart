import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/events/peers_event_bus.dart';
import 'package:unity_app/core/widgets/app_snack_bar.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_avatar.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../../peers/presentation/bloc/peers_event.dart';
import '../../../../peers/presentation/widgets/peer_card.dart';
import '../../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../domain/entities/circle_entity.dart';
import '../../../domain/entities/circle_member_entity.dart';
import '../../../domain/usecases/get_circle_members_usecase.dart';

class CircleDetailPeersPreview extends StatefulWidget {
  final CircleEntity circle;

  const CircleDetailPeersPreview({super.key, required this.circle});

  @override
  State<CircleDetailPeersPreview> createState() => _CircleDetailPeersPreviewState();
}

class _CircleDetailPeersPreviewState extends State<CircleDetailPeersPreview> {
  List<CircleMemberEntity> _members = [];
  bool _isLoading = true;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  @override
  void initState() {
    super.initState();
    _fetchPreviewMembers();
    _setupBusSubscription();
  }

  void _setupBusSubscription() {
    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      if (event is PeerConnectionRequestedEvent) {
        _updateMemberStatus(event.peerId,
            connectionStatus: 'pending', isRequested: true, isConnected: false);
      } else if (event is PeerConnectionAcceptedEvent) {
        _updateMemberStatus(event.peerId,
            connectionStatus: 'connected', isRequested: false, isConnected: true);
      } else if (event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionCancelledEvent) {
        final peerId = event is PeerConnectionDeclinedEvent
            ? event.peerId
            : (event as PeerConnectionCancelledEvent).peerId;
        _updateMemberStatus(peerId,
            connectionStatus: 'none', isRequested: false, isConnected: false);
      } else if (event is PeerFollowToggledEvent) {
        setState(() {
          _members = _members.map((m) {
            if (m.id == event.peerId || m.userId == event.peerId) {
              return m.copyWith(isFollowing: event.isFollowing);
            }
            return m;
          }).toList();
        });
      } else if (event is PeerBookmarkToggledEvent) {
        setState(() {
          _members = _members.map((m) {
            if (m.id == event.peerId || m.userId == event.peerId) {
              return m.copyWith(isBookmark: event.isBookmarked);
            }
            return m;
          }).toList();
        });
      }
    });
  }

  void _updateMemberStatus(
    String peerId, {
    required String connectionStatus,
    required bool isRequested,
    required bool isConnected,
  }) {
    setState(() {
      _members = _members.map((m) {
        if (m.id == peerId || m.userId == peerId) {
          return m.copyWith(
            connectionStatus: connectionStatus,
            isRequested: isRequested,
            isConnected: isConnected,
          );
        }
        return m;
      }).toList();
    });
  }

  @override
  void dispose() {
    _busSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchPreviewMembers() async {
    try {
      final useCase = context.read<GetCircleMembersUseCase>();
      final result = await useCase(widget.circle.id);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _members = result;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final count = _members.isNotEmpty ? _members.length : widget.circle.membersCount;
    final previewList = _members.take(4).toList();

    final profileState = context.watch<ProfileBloc>().state;
    final authState = context.watch<AuthBloc>().state;
    final currentUserId = profileState.profile?.id ?? authState.user?.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Circle Peers',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: primaryText,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.darkSurfaceSubtle : AppColor.badgeBlueBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.circleMembers,
                    arguments: widget.circle,
                  );
                },
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'See more',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
              ),
            ),
          )
        else if (previewList.isNotEmpty)
          ...previewList.map((member) {
            final peer = member.toPeerEntity();
            final bool isCurrentUser = currentUserId != null &&
                (currentUserId == member.userId || currentUserId == member.id);

            return PeerCard(
              peer: peer,
              isCurrentUser: isCurrentUser,
              onTap: () {
                if (isCurrentUser) {
                  Navigator.pushNamed(context, AppRoutes.profile);
                } else {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.peerProfile,
                    arguments: member.userId ?? member.id,
                  );
                }
              },
              onConnect: isCurrentUser
                  ? null
                  : () {
                      context.read<PeersBloc>().add(PeerConnectRequested(peer.id));
                    },
              onFollow: isCurrentUser
                  ? null
                  : () {
                      context.read<PeersBloc>().add(
                            PeerFollowToggled(
                              peerId: peer.id,
                              isCurrentlyFollowing: peer.isFollowing,
                            ),
                          );
                    },
              onScheduleP2P: isCurrentUser
                  ? null
                  : () {
                      AppSnackBar.showInfo(
                        context,
                        'Scheduling P2P with ${peer.displayName}',
                      );
                    },
              onMessage: () {
                AppSnackBar.showInfo(
                  context,
                  'Messaging ${peer.displayName}',
                );
              },
              onBookmark: () {
                if (!isCurrentUser) {
                  context.read<PeersBloc>().add(
                        PeerBookmarkToggled(
                          peerId: peer.id,
                          isCurrentlyBookmarked: peer.isBookmarked,
                        ),
                      );
                }
              },
            );
          })
        else
          _buildFallbackLeadershipList(isDark),
      ],
    );
  }

  Widget _buildFallbackLeadershipList(bool isDark) {
    if (widget.circle.leadership.isEmpty) {
      return const SizedBox.shrink();
    }
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: widget.circle.leadership.take(4).map((leader) {
          return ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            leading: AppAvatar(
              imageUrl: leader.avatarUrl,
              name: leader.name,
              size: 36,
            ),
            title: Text(
              leader.name,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: primaryText),
            ),
            subtitle: Text(
              leader.role,
              style: TextStyle(fontSize: 10.5, color: secondaryText),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColor.primaryBlue),
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.circleMembers,
                arguments: widget.circle,
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
