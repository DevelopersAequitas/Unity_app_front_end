import 'package:flutter/material.dart';
import '../../../../core/cache/hive_cache_store.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../data/datasources/leaderboard_local_datasource.dart';
import '../../data/datasources/leaderboard_remote_datasource.dart';
import '../../data/models/coin_guidelines_model.dart';
import '../widgets/coin_badge.dart';

class CoinGuidelinesScreen extends StatefulWidget {
  const CoinGuidelinesScreen({super.key});

  @override
  State<CoinGuidelinesScreen> createState() => _CoinGuidelinesScreenState();
}

class _CoinGuidelinesScreenState extends State<CoinGuidelinesScreen> {
  late final LeaderboardLocalDataSource _localDataSource;
  late final LeaderboardRemoteDataSource _remoteDataSource;
  CoinGuidelinesModel? _guidelines;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _localDataSource = LeaderboardLocalDataSourceImpl(cacheStore: HiveCacheStore());
    _remoteDataSource = LeaderboardRemoteDataSourceImpl(dioClient: DioClient());
    _loadGuidelines();
  }

  Future<void> _loadGuidelines({bool isRefresh = false}) async {
    if (!isRefresh) {
      final cached = await _localDataSource.getCachedCoinGuidelines();
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
      final fresh = await _remoteDataSource.getCoinGuidelines();
      final rawData = _remoteDataSource.lastRawCoinGuidelinesData;
      if (rawData != null) {
        await _localDataSource.cacheCoinGuidelines(rawData);
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

  IconData _getActivityIcon(String activity) {
    final lower = activity.toLowerCase();
    if (lower.contains('testimonial')) return Icons.rate_review_outlined;
    if (lower.contains('signup') || lower.contains('sign up')) return Icons.person_add_alt_1_outlined;
    if (lower.contains('referral')) return Icons.group_add_outlined;
    if (lower.contains('requirement')) return Icons.assignment_outlined;
    if (lower.contains('deal') || lower.contains('business')) return Icons.handshake_outlined;
    if (lower.contains('p2p') || lower.contains('meeting')) return Icons.video_call_outlined;
    if (lower.contains('recommend')) return Icons.thumb_up_alt_outlined;
    if (lower.contains('help')) return Icons.volunteer_activism_outlined;
    return Icons.star_outline_rounded;
  }

  String _formatCoins(int number) {
    if (number >= 1000) {
      final str = number.toString();
      final chars = str.split('');
      final buffer = StringBuffer();
      for (int i = 0; i < chars.length; i++) {
        if (i > 0 && (chars.length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(chars[i]);
      }
      return buffer.toString();
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppCommonBar(
        title: 'Coin Rules',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
      ),
      body: ResponsiveContainer(
        child: RefreshIndicator(
          color: AppColor.primaryBlue,
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
            color: AppColor.primaryBlue,
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
                'Failed to load coin rules',
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
                  backgroundColor: AppColor.primaryBlue,
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
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.0,
            ),
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
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFFDE68A),
                        width: 1.0,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.monetization_on_rounded,
                        color: Color(0xFFD97706),
                        size: 22,
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
            'HOW TO EARN COINS',
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
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.0,
                ),
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
                      color: AppColor.badgeBlueBg,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Icon(
                      _getActivityIcon(item.activity),
                      size: 18,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.activity,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppColor.lightTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFBFDBFE),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CoinStackIcon(
                          size: 13,
                          color: AppColor.primaryBlue,
                        ),
                        const SizedBox(width: 4.5),
                        Text(
                          '+${_formatCoins(item.coins)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryBlue,
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
