import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../peers/domain/usecases/get_blocked_peers_usecase.dart';
import '../../../peers/domain/usecases/unblock_peer_usecase.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../widgets/blocked_user_tile.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final DioClient _dio = DioClient();
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _users = [];
  StreamSubscription<PeerBusEvent>? _busSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBlockedUsers();
    });

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerBlockedEvent ||
          event is PeerUnblockedEvent ||
          event is PeersSyncNeededEvent) {
        if (mounted) {
          _fetchBlockedUsers();
        }
      }
    });
  }

  @override
  void dispose() {
    _busSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchBlockedUsers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    List<Map<String, dynamic>> items = [];
    String? error;
    try {
      final useCase = context.read<GetBlockedPeersUseCase>();
      items = await useCase();
    } catch (e) {
      try {
        final res = await _dio.dio.get(ApiEndpoints.blockedPeers);
        final data = res.data;
        List? raw;
        if (data is Map<String, dynamic>) {
          final inner = data['data'];
          if (inner is Map<String, dynamic>) {
            raw =
                (inner['items'] as List?) ??
                (inner['peers'] as List?) ??
                (inner['users'] as List?);
          } else if (inner is List) {
            raw = inner;
          } else {
            raw = (data['items'] as List?) ?? (data['peers'] as List?);
          }
        } else if (data is List) {
          raw = data;
        }
        if (raw != null) {
          items = raw.whereType<Map<String, dynamic>>().toList();
        }
      } catch (err) {
        try {
          final res2 = await _dio.dio.get(ApiEndpoints.blockedUsers);
          final data2 = res2.data;
          List? raw2;
          if (data2 is Map<String, dynamic>) {
            final inner = data2['data'];
            if (inner is Map<String, dynamic>) {
              raw2 = (inner['items'] as List?) ?? (inner['users'] as List?);
            } else if (inner is List) {
              raw2 = inner;
            }
          } else if (data2 is List) {
            raw2 = data2;
          }
          if (raw2 != null) {
            items = raw2.whereType<Map<String, dynamic>>().toList();
          }
        } catch (_) {
          error = err.toString();
        }
      }
    }

    if (mounted) {
      setState(() {
        _users = items;
        _errorMessage = items.isEmpty ? error : null;
        _isLoading = false;
      });
    }
  }

  Future<void> _unblockUser(String userId, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Unblock Peer',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to unblock $name? They will be able to view your profile and interact with you.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColor.lightTextSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Unblock'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    // Optimistically remove from list
    setState(() {
      _users.removeWhere((item) {
        final id = item['id']?.toString() ??
            item['peer_id']?.toString() ??
            item['user_id']?.toString() ??
            item['blocked_user_id']?.toString() ??
            '';
        return id == userId;
      });
    });

    try {
      try {
        final unblockUseCase = context.read<UnblockPeerUseCase>();
        await unblockUseCase(userId);
      } catch (_) {
        try {
          await _dio.dio.delete(ApiEndpoints.unblockPeer(userId));
        } catch (_) {
          await _dio.dio.delete(ApiEndpoints.unblockUser(userId));
        }
      }

      if (mounted) {
        PeersEventBus.instance.emit(PeerUnblockedEvent(peerId: userId));
        PeersEventBus.instance.emit(const PeersSyncNeededEvent());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unblocked $name successfully')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to unblock user. Please try again.'),
          ),
        );
        _fetchBlockedUsers();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Blocked Users',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextPrimary,
          ),
        ),
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColor.lightTextPrimary,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchBlockedUsers,
        color: AppColor.primaryBlue,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => Container(
          height: 68,
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.lightBorder),
          ),
        ),
      );
    }

    if (_errorMessage != null && _users.isEmpty) {
      return AppErrorView(
        title: 'Unable to Load Blocked Users',
        message: _errorMessage,
        onRetry: _fetchBlockedUsers,
        screenName: 'Blocked Users',
      );
    }

    if (_users.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_off_outlined,
                  size: 28,
                  color: AppColor.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No Blocked Users',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You haven\'t blocked any members.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.lightTextSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = _users[index];
        final userObj = (item['user'] is Map<String, dynamic>)
            ? item['user'] as Map<String, dynamic>
            : (item['peer'] is Map<String, dynamic>)
            ? item['peer'] as Map<String, dynamic>
            : null;
        final id =
            item['id']?.toString() ??
            item['peer_id']?.toString() ??
            item['user_id']?.toString() ??
            item['blocked_user_id']?.toString() ??
            userObj?['id']?.toString() ??
            '';
        final name =
            item['name']?.toString() ??
            item['full_name']?.toString() ??
            item['displayName']?.toString() ??
            item['display_name']?.toString() ??
            item['peer_name']?.toString() ??
            userObj?['name']?.toString() ??
            userObj?['full_name']?.toString() ??
            userObj?['displayName']?.toString() ??
            (userObj != null && userObj['first_name'] != null
                ? '${userObj['first_name']} ${userObj['last_name'] ?? ''}'
                      .trim()
                : 'Blocked Member');
        final avatar =
            item['avatar_url']?.toString() ??
            item['avatar']?.toString() ??
            item['profile_photo_url']?.toString() ??
            item['photo_url']?.toString() ??
            userObj?['avatar_url']?.toString() ??
            userObj?['profile_photo_url']?.toString() ??
            '';

        final company =
            item['company_name']?.toString() ??
            item['company']?.toString() ??
            userObj?['company_name']?.toString() ??
            userObj?['company']?.toString();
        final designation =
            item['designation']?.toString() ??
            item['title']?.toString() ??
            userObj?['designation']?.toString();
        final reason =
            item['reason']?.toString() ?? item['block_reason']?.toString();

        String? subtitle;
        if (designation != null &&
            designation.isNotEmpty &&
            company != null &&
            company.isNotEmpty) {
          subtitle = '$designation • $company';
        } else if (designation != null && designation.isNotEmpty) {
          subtitle = designation;
        } else if (company != null && company.isNotEmpty) {
          subtitle = company;
        }

        return BlockedUserTile(
          id: id,
          name: name,
          avatar: avatar,
          subtitle: subtitle,
          reason: reason,
          onUnblock: () => _unblockUser(id, name),
        );
      },
    );
  }
}
