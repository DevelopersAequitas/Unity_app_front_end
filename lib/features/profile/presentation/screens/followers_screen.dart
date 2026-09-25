import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../peers/domain/usecases/follow_user_usecase.dart';
import '../../../peers/domain/usecases/unfollow_user_usecase.dart';

class FollowersScreen extends StatefulWidget {
  final String? userId;
  final String? userName;

  const FollowersScreen({
    super.key,
    this.userId,
    this.userName,
  });

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  final DioClient _dio = DioClient();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;
  int _followersCount = 0;
  List<Map<String, dynamic>> _followers = [];
  String _searchQuery = '';
  final Set<String> _loadingFollowIds = {};

  @override
  void initState() {
    super.initState();
    _fetchFollowers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is List) return inner;
      if (inner is Map<String, dynamic>) {
        final sub = inner['data'] ??
            inner['items'] ??
            inner['followers'] ??
            inner['users'] ??
            inner['members'];
        if (sub is List) return sub;
      }
      final direct = data['followers'] ??
          data['items'] ??
          data['users'] ??
          data['members'] ??
          data['result'];
      if (direct is List) return direct;
    }
    return [];
  }

  int _extractCount(dynamic data) {
    if (data is num) return data.toInt();
    if (data is Map<String, dynamic>) {
      final inner = data['data'];
      if (inner is num) return inner.toInt();
      if (inner is Map<String, dynamic>) {
        final c = inner['count'] ??
            inner['followers_count'] ??
            inner['total'] ??
            inner['followers'];
        if (c is num) return c.toInt();
      }
      final direct = data['count'] ??
          data['followers_count'] ??
          data['total'] ??
          data['followers'];
      if (direct is num) return direct.toInt();
    }
    return 0;
  }

  Future<void> _fetchFollowers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    List<dynamic> raw = [];
    int count = 0;

    final targetId = widget.userId ?? '';

    if (targetId.isNotEmpty) {
      try {
        final countRes =
            await _dio.dio.get(ApiEndpoints.userFollowersCount(targetId));
        count = _extractCount(countRes.data);
        final list = _extractList(countRes.data);
        if (list.isNotEmpty) {
          raw = list;
        }
      } catch (_) {}
    }

    if (raw.isEmpty) {
      final listEndpoints = targetId.isEmpty
          ? [
              ApiEndpoints.myFollowers,
              '/followers',
              '/users/followers',
            ]
          : [
              ApiEndpoints.myFollowers,
              ApiEndpoints.userFollowers(targetId),
              '/members/$targetId/followers',
              '/users/$targetId/followers',
            ];

      for (final ep in listEndpoints) {
        try {
          final res = await _dio.dio.get(ep);
          final list = _extractList(res.data);
          if (list.isNotEmpty || res.statusCode == 200) {
            raw = list;
            if (count == 0) {
              count = _extractCount(res.data);
            }
            break;
          }
        } catch (_) {}
      }
    }

    if (count == 0) {
      if (targetId.isNotEmpty) {
        try {
          final countRes =
              await _dio.dio.get(ApiEndpoints.userFollowersCount(targetId));
          count = _extractCount(countRes.data);
        } catch (_) {
          count = raw.length;
        }
      } else {
        try {
          final countRes = await _dio.dio.get('/me/followers/count');
          count = _extractCount(countRes.data);
        } catch (_) {
          count = raw.length;
        }
      }
    }

    if (count == 0 && raw.isNotEmpty) {
      count = raw.length;
    }

    if (mounted) {
      setState(() {
        _followers = raw.map((item) {
          if (item is Map<String, dynamic>) {
            final followerUser = item['user'] ??
                item['follower'] ??
                item['member'] ??
                item['peer'];
            if (followerUser is Map<String, dynamic>) {
              return {
                ...item,
                ...followerUser,
                'follow_id': item['follow_id'] ?? item['id'],
                'is_following': item['is_following'] ??
                    item['is_followed_by_me'] ??
                    followerUser['is_following'] ??
                    false,
              };
            }
            return item;
          }
          return <String, dynamic>{};
        }).where((m) => m.isNotEmpty).toList();
        _followersCount = count > _followers.length ? count : _followers.length;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFollow(Map<String, dynamic> follower) async {
    final rawId = (follower['id'] ??
            follower['user_id'] ??
            follower['member_id'] ??
            follower['peer_id'] ??
            '')
        .toString();
    if (rawId.isEmpty) return;

    final currentlyFollowing = follower['is_following'] == true ||
        follower['following'] == true ||
        follower['is_followed_by_me'] == true;

    setState(() => _loadingFollowIds.add(rawId));

    try {
      if (currentlyFollowing) {
        try {
          await context.read<UnfollowUserUseCase>()(rawId);
        } catch (_) {
          try {
            await _dio.dio.delete(ApiEndpoints.unfollowUser(rawId));
          } catch (_) {
            await _dio.dio.post(ApiEndpoints.unfollowUser(rawId));
          }
        }
      } else {
        try {
          await context.read<FollowUserUseCase>()(rawId);
        } catch (_) {
          await _dio.dio.post(ApiEndpoints.followUser(rawId));
        }
      }

      PeersEventBus.instance.emit(PeerFollowToggledEvent(
        peerId: rawId,
        isFollowing: !currentlyFollowing,
      ));

      if (mounted) {
        setState(() {
          final index = _followers.indexWhere((f) =>
              (f['id'] ?? f['user_id'] ?? f['member_id'] ?? '').toString() ==
              rawId);
          if (index != -1) {
            _followers[index] = {
              ..._followers[index],
              'is_following': !currentlyFollowing,
            };
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentlyFollowing
                  ? 'Failed to unfollow peer'
                  : 'Failed to follow peer',
            ),
            backgroundColor: AppColor.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loadingFollowIds.remove(rawId));
      }
    }
  }

  List<Map<String, dynamic>> get _filteredFollowers {
    if (_searchQuery.trim().isEmpty) return _followers;
    final q = _searchQuery.toLowerCase().trim();
    return _followers.where((f) {
      final name = (f['name'] ??
              f['display_name'] ??
              f['full_name'] ??
              f['username'] ??
              '')
          .toString()
          .toLowerCase();
      final designation = (f['designation'] ??
              f['headline'] ??
              f['profession'] ??
              f['role'] ??
              f['company_name'] ??
              '')
          .toString()
          .toLowerCase();
      final email = (f['email'] ?? '').toString().toLowerCase();
      return name.contains(q) || designation.contains(q) || email.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.userName != null && widget.userName!.isNotEmpty
        ? "${widget.userName}'s Followers"
        : 'Followers';

    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppCommonBar(
        title: title.toUpperCase(),
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.pop(context),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: RefreshIndicator(
                  color: AppColor.primaryBlue,
                  onRefresh: _fetchFollowers,
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColor.lightSurface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$_followersCount ${_followersCount == 1 ? 'Follower' : 'Followers'}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search followers...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColor.lightTextSecondary,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 20,
                color: AppColor.lightTextSecondary,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              filled: true,
              fillColor: AppColor.lightBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.lightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColor.lightBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColor.primaryBlue,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColor.primaryBlue,
        ),
      );
    }

    if (_errorMessage != null) {
      return AppErrorView(
        title: 'Unable to Load Followers',
        message: _errorMessage,
        onRetry: _fetchFollowers,
        screenName: 'Followers',
      );
    }

    final filtered = _filteredFollowers;

    if (filtered.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFF6FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.people_outline_rounded,
                    size: 36,
                    color: AppColor.primaryBlue,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'No followers match your search'
                      : 'No followers yet',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _searchQuery.isNotEmpty
                      ? 'Try searching with another keyword.'
                      : 'When other peers follow this account, they will appear here.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColor.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: filtered.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final follower = filtered[index];
        return _buildFollowerCard(follower);
      },
    );
  }

  Widget _buildFollowerCard(Map<String, dynamic> follower) {
    final id = (follower['id'] ??
            follower['user_id'] ??
            follower['member_id'] ??
            follower['peer_id'] ??
            '')
        .toString();
    final name = (follower['name'] ??
            follower['display_name'] ??
            follower['full_name'] ??
            'Peer')
        .toString();
    final avatar = (follower['profile_photo_url'] ??
            follower['avatar'] ??
            follower['photo'] ??
            '')
        .toString();
    final designation = (follower['designation'] ??
            follower['headline'] ??
            follower['profession'] ??
            follower['role'] ??
            follower['company_name'] ??
            '')
        .toString();
    final company = (follower['company_name'] ??
            follower['business_name'] ??
            follower['company'] ??
            '')
        .toString();
    final city =
        (follower['city'] ?? follower['location'] ?? '').toString();

    final isFollowing = follower['is_following'] == true ||
        follower['following'] == true ||
        follower['is_followed_by_me'] == true;
    final isLoadingThis = _loadingFollowIds.contains(id);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.1),
            backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
            child: avatar.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'P',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryBlue,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                if (designation.isNotEmpty || company.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    designation.isNotEmpty && company.isNotEmpty
                        ? '$designation at $company'
                        : (designation.isNotEmpty ? designation : company),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.lightTextSecondary,
                    ),
                  ),
                ],
                if (city.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: AppColor.lightTextSecondary,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColor.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 32,
            child: OutlinedButton(
              onPressed: isLoadingThis ? null : () => _toggleFollow(follower),
              style: OutlinedButton.styleFrom(
                backgroundColor: isFollowing
                    ? AppColor.lightBackground
                    : AppColor.primaryBlue,
                foregroundColor:
                    isFollowing ? AppColor.lightTextPrimary : Colors.white,
                side: BorderSide(
                  color: isFollowing
                      ? AppColor.lightBorder
                      : AppColor.primaryBlue,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoadingThis
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryBlue,
                      ),
                    )
                  : Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isFollowing
                            ? AppColor.lightTextPrimary
                            : Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
