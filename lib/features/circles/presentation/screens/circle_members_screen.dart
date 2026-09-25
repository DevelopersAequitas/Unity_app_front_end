import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../peers/presentation/bloc/peers_event.dart';
import '../../../peers/presentation/widgets/peer_card.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/circle_entity.dart';
import '../../domain/entities/circle_member_entity.dart';
import '../../domain/usecases/get_circle_members_usecase.dart';

class CircleMembersScreen extends StatefulWidget {
  final CircleEntity circle;

  const CircleMembersScreen({super.key, required this.circle});

  @override
  State<CircleMembersScreen> createState() => _CircleMembersScreenState();
}

class _CircleMembersScreenState extends State<CircleMembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CircleMemberEntity> _allMembers = [];
  List<CircleMemberEntity> _filteredMembers = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _setupBusSubscription();
  }

  void _setupBusSubscription() {
    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (!mounted) return;
      if (event is PeerConnectionRequestedEvent) {
        _updateMemberStatus(event.peerId,
            connectionStatus: 'pending',
            isRequested: true,
            isConnected: false);
      } else if (event is PeerConnectionAcceptedEvent) {
        _updateMemberStatus(event.peerId,
            connectionStatus: 'connected',
            isRequested: false,
            isConnected: true);
      } else if (event is PeerConnectionDeclinedEvent) {
        _updateMemberStatus(event.peerId,
            connectionStatus: 'none',
            isRequested: false,
            isConnected: false);
      } else if (event is PeerConnectionCancelledEvent) {
        _updateMemberStatus(event.peerId,
            connectionStatus: 'none',
            isRequested: false,
            isConnected: false);
      } else if (event is PeerFollowToggledEvent) {
        _updateMemberFollow(event.peerId, event.isFollowing);
      } else if (event is PeerBookmarkToggledEvent) {
        _updateMemberBookmark(event.peerId, event.isBookmarked);
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
      _allMembers = _allMembers.map((m) {
        if (m.id == peerId || m.userId == peerId) {
          return m.copyWith(
            connectionStatus: connectionStatus,
            isRequested: isRequested,
            isConnected: isConnected,
          );
        }
        return m;
      }).toList();
      _filterMembers();
    });
  }

  void _updateMemberFollow(String peerId, bool isFollowing) {
    setState(() {
      _allMembers = _allMembers.map((m) {
        if (m.id == peerId || m.userId == peerId) {
          return m.copyWith(isFollowing: isFollowing);
        }
        return m;
      }).toList();
      _filterMembers();
    });
  }

  void _updateMemberBookmark(String peerId, bool isBookmarked) {
    setState(() {
      _allMembers = _allMembers.map((m) {
        if (m.id == peerId || m.userId == peerId) {
          return m.copyWith(isBookmark: isBookmarked);
        }
        return m;
      }).toList();
      _filterMembers();
    });
  }

  @override
  void dispose() {
    _busSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final useCase = context.read<GetCircleMembersUseCase>();
      final members = await useCase(widget.circle.id);

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _allMembers = members;
        _filteredMembers = members;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _filterMembers() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMembers = _allMembers;
      } else {
        _filteredMembers = _allMembers.where((m) {
          final name = m.effectiveName.toLowerCase();
          final company = (m.companyName ?? '').toLowerCase();
          final role = (m.role ?? '').toLowerCase();
          final cat = (m.effectiveCategoryTag ?? '').toLowerCase();
          final bCat = (m.businessCategory ?? '').toLowerCase();
          final subCat = (m.businessSubCategory ?? '').toLowerCase();
          final l4 = (m.level4Category ?? '').toLowerCase();
          final city = (m.city ?? '').toLowerCase();
          return name.contains(query) ||
              company.contains(query) ||
              role.contains(query) ||
              cat.contains(query) ||
              bCat.contains(query) ||
              subCat.contains(query) ||
              l4.contains(query) ||
              city.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final profileState = context.watch<ProfileBloc>().state;
    final authState = context.watch<AuthBloc>().state;
    final currentUserId = profileState.profile?.id ?? authState.user?.id;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: '${widget.circle.name} Peers',
        showBack: true,
        showSearch: true,
        showNotifications: false,
        showProfile: false,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search peers, companies, roles...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchClose: () {
          setState(() {
            _isSearching = false;
            _searchController.clear();
            _filterMembers();
          });
        },
        onSearchChanged: (_) => _filterMembers(),
        onBackTap: () => Navigator.of(context).pop(),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.primaryBlue,
                  ),
                )
              : _errorMessage != null
                  ? AppErrorView(
                      title: 'Unable to Load Circle Peers',
                      message: _errorMessage,
                      onRetry: _loadMembers,
                      screenName: '${widget.circle.name} Peers',
                    )
                  : _filteredMembers.isEmpty
                      ? Center(
                          child: Text(
                            'No peers found in this circle',
                            style: TextStyle(fontSize: 13, color: secondaryText),
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColor.primaryBlue,
                          onRefresh: _loadMembers,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 24),
                            itemCount: _filteredMembers.length,
                            itemBuilder: (context, index) {
                              final member = _filteredMembers[index];
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
                                        context.read<PeersBloc>().add(
                                              PeerConnectRequested(peer.id),
                                            );
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
                                onScheduleP2P: null,
                                onMessage: isCurrentUser ? () {} : null,
                                onBookmark: isCurrentUser
                                    ? () {}
                                    : () {
                                        context.read<PeersBloc>().add(
                                              PeerBookmarkToggled(
                                                peerId: peer.id,
                                                isCurrentlyBookmarked: peer.isBookmarked,
                                              ),
                                            );
                                      },
                              );
                            },
                          ),
                        ),
        ),
      ),
    );
  }
}
