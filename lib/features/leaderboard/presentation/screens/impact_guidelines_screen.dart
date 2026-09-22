import 'package:flutter/material.dart';
import '../../../../core/cache/hive_cache_store.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../data/datasources/leaderboard_local_datasource.dart';
import '../../data/datasources/leaderboard_remote_datasource.dart';
import '../../data/models/impact_guidelines_model.dart';

class ImpactGuidelinesScreen extends StatefulWidget {
  const ImpactGuidelinesScreen({super.key});

  @override
  State<ImpactGuidelinesScreen> createState() => _ImpactGuidelinesScreenState();
}

class _ImpactGuidelinesScreenState extends State<ImpactGuidelinesScreen> {
  late final LeaderboardLocalDataSource _localDataSource;
  late final LeaderboardRemoteDataSource _remoteDataSource;
  ImpactGuidelinesModel? _guidelines;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _localDataSource = LeaderboardLocalDataSourceImpl(
      cacheStore: HiveCacheStore(),
    );
    _remoteDataSource = LeaderboardRemoteDataSourceImpl(dioClient: DioClient());
    _loadGuidelines();
  }

  Future<void> _loadGuidelines({bool isRefresh = false}) async {
    if (!isRefresh) {
      final cached = await _localDataSource.getCachedImpactGuidelines();
      if (cached != null) {
        if (mounted) {
          setState(() {
            _guidelines = cached;
            _isLoading = false;
          });
        }
      }
    }

    try {
      final fresh = await _remoteDataSource.getImpactGuidelines();
      final rawData = _remoteDataSource.lastRawImpactGuidelinesData;
      if (rawData != null) {
        await _localDataSource.cacheImpactGuidelines(rawData);
      }
      if (mounted) {
        setState(() {
          _guidelines = fresh;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (_guidelines == null) {
            _errorMessage = e.toString();
          }
        });
      }
    }
  }

  IconData _getActionIcon(String action, String category) {
    final lower = '${action.toLowerCase()} ${category.toLowerCase()}';
    if (lower.contains('deal') || lower.contains('business'))
      return Icons.handshake_outlined;
    if (lower.contains('testimonial') || lower.contains('review'))
      return Icons.rate_review_outlined;
    if (lower.contains('referral')) return Icons.group_add_outlined;
    if (lower.contains('connect') || lower.contains('collaboration'))
      return Icons.hub_outlined;
    if (lower.contains('meeting') || lower.contains('p2p'))
      return Icons.video_call_outlined;
    if (lower.contains('signup') || lower.contains('sign up'))
      return Icons.person_add_alt_1_outlined;
    if (lower.contains('visibility') || lower.contains('trust'))
      return Icons.verified_user_outlined;
    return Icons.auto_awesome_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppCommonBar(
        title: 'Impact Rules',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
      ),
      body: ResponsiveContainer(
        child: RefreshIndicator(
          color: const Color(0xFFC026D3),
          onRefresh: () async {
            await _loadGuidelines(isRefresh: true);
          },
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _guidelines == null) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFFC026D3),
          ),
        ),
      );
    }

    if (_errorMessage != null && _guidelines == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColor.primaryPink,
                size: 36,
              ),
              const SizedBox(height: 10),
              const Text(
                'Failed to load impact rules',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadGuidelines();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC026D3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final data = _guidelines!;
    final guidelines = data.guidelines;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // ── Hero / Overview Card ──
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF5FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF3E8FF), width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF4FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFF0ABFC),
                        width: 1.0,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Color(0xFFC026D3),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColor.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              if (data.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  data.description,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColor.lightTextSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Section Title ──
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'HOW TO EARN IMPACT SCORE',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColor.lightTextTertiary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // ── Guidelines List ──
        ...guidelines.map((item) {
          final isMulti = item.impactValue > 1;
          final unitText = item.impactUnit.isNotEmpty
              ? item.impactUnit
              : (isMulti ? 'Lives' : 'Life');

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF4FF),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      _getActionIcon(item.action, item.category),
                      size: 18,
                      color: const Color(0xFFC026D3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.action,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: AppColor.lightTextPrimary,
                          ),
                        ),
                        if (item.category.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.category,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              color: AppColor.lightTextTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF4FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFF0ABFC),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_rounded,
                          size: 11.5,
                          color: Color(0xFFC026D3),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${item.impactValue} $unitText',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFC026D3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
