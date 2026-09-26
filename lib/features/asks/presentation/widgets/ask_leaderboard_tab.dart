import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../data/datasources/asks_remote_datasource.dart';
import '../../data/models/ask_leaderboard_item_model.dart';

class AskLeaderboardTab extends StatefulWidget {
  final String flowCode;

  const AskLeaderboardTab({
    super.key,
    this.flowCode = 'help',
  });

  @override
  State<AskLeaderboardTab> createState() => _AskLeaderboardTabState();
}

class _AskLeaderboardTabState extends State<AskLeaderboardTab> {
  String _timeFilter = 'all';
  bool _isLoading = false;
  String? _errorMessage;
  List<AskLeaderboardItemModel> _items = [];

  static const _filters = [
    {'label': 'All Time', 'value': 'all'},
    {'label': 'This Month', 'value': 'month'},
    {'label': 'This Week', 'value': 'week'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
  }

  @override
  void didUpdateWidget(covariant AskLeaderboardTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flowCode != widget.flowCode) {
      _fetchLeaderboard();
    }
  }

  Future<void> _fetchLeaderboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ds = context.read<AsksRemoteDataSource>();
      final result = await ds.getLeaderboard(
        flowCode: widget.flowCode,
        timeFilter: _timeFilter,
      );

      if (mounted) {
        setState(() {
          _items = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        const SizedBox(height: 8),
        // Filter row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _filters.map((f) {
              final isSelected = _timeFilter == f['value'];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f['label']!),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected && _timeFilter != f['value']) {
                      setState(() => _timeFilter = f['value']!);
                      _fetchLeaderboard();
                    }
                  },
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColor.darkTextSecondary
                            : AppColor.lightTextSecondary),
                  ),
                  selectedColor: AppColor.primaryBlue,
                  backgroundColor:
                      isDark ? AppColor.darkSurface : AppColor.lightSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColor.primaryBlue
                          : (isDark
                              ? AppColor.darkBorder
                              : AppColor.lightBorder),
                      width: 0.8,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _buildBody(isDark),
        ),
      ],
    );
  }

  Widget _buildBody(bool isDark) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryBlue,
          strokeWidth: 2,
        ),
      );
    }

    if (_errorMessage != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: isDark
                  ? AppColor.darkTextSecondary
                  : AppColor.lightTextSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'Failed to load leaderboard',
              style: TextStyle(
                color: isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.lightTextSecondary,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _fetchLeaderboard,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return RefreshIndicator(
        color: AppColor.primaryBlue,
        onRefresh: _fetchLeaderboard,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 48,
                      color: isDark
                          ? AppColor.darkTextTertiary
                          : AppColor.lightTextTertiary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No leaderboard rankings yet.',
                      style: TextStyle(
                        color: isDark
                            ? AppColor.darkTextSecondary
                            : AppColor.lightTextSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Be the first to fulfill an ask and top the ranks!',
                      style: TextStyle(
                        color: isDark
                            ? AppColor.darkTextTertiary
                            : AppColor.lightTextTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: _fetchLeaderboard,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final item = _items[index];
          final rank = item.rank > 0 ? item.rank : index + 1;

          Color rankColor;
          if (rank == 1) {
            rankColor = const Color(0xFFF59E0B); // Gold
          } else if (rank == 2) {
            rankColor = const Color(0xFF94A3B8); // Silver
          } else if (rank == 3) {
            rankColor = const Color(0xFFD97706); // Bronze
          } else {
            rankColor = isDark
                ? AppColor.darkTextTertiary
                : AppColor.lightTextTertiary;
          }

          return InkWell(
            onTap: () {
              if (item.userId.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.peerProfile,
                  arguments: item.userId,
                );
              }
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: rank <= 3
                      ? rankColor.withValues(alpha: 0.35)
                      : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                  width: rank <= 3 ? 1.2 : 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Rank badge
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: rank <= 3
                          ? rankColor.withValues(alpha: 0.15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '#$rank',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: rankColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AppAvatar(
                    imageUrl: item.avatarUrl ?? '',
                    name: item.displayName,
                    size: 42,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.displayName,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColor.darkTextPrimary
                                : AppColor.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.companyName != null || item.city != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            [
                              if (item.companyName != null &&
                                  item.companyName!.isNotEmpty)
                                item.companyName!,
                              if (item.city != null && item.city!.isNotEmpty)
                                item.city!,
                            ].join(' • '),
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              color: isDark
                                  ? AppColor.darkTextSecondary
                                  : AppColor.lightTextSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    AppColor.primaryBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.giverBadge,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.primaryBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AppGradientText(
                        '${item.count}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.metricLabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColor.darkTextTertiary
                              : AppColor.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
