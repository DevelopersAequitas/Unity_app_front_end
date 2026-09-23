import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/usecases/get_coins_leaderboard_usecase.dart';
import '../../domain/usecases/get_impacts_leaderboard_usecase.dart';
import '../bloc/leaderboard_bloc.dart';
import '../bloc/leaderboard_event.dart';
import '../bloc/leaderboard_state.dart';
import '../widgets/leaderboard_empty_state.dart';
import '../widgets/leaderboard_error_view.dart';
import '../widgets/leaderboard_podium_section.dart';
import '../widgets/leaderboard_ranking_list.dart';
import '../widgets/leaderboard_skeleton.dart';
import '../widgets/leaderboard_sticky_user_card.dart';

class LeaderboardScreen extends StatelessWidget {
  final LeaderboardType type;

  const LeaderboardScreen({
    super.key,
    this.type = LeaderboardType.coins,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => LeaderboardBloc(
        getCoinsLeaderboardUseCase: ctx.read<GetCoinsLeaderboardUseCase>(),
        getImpactsLeaderboardUseCase: ctx.read<GetImpactsLeaderboardUseCase>(),
        type: type,
      )..add(const LeaderboardFetchRequested()),
      child: _LeaderboardView(type: type),
    );
  }
}

class _LeaderboardView extends StatelessWidget {
  final LeaderboardType type;

  const _LeaderboardView({required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightBackground;
    final isImpact = type == LeaderboardType.impact;

    return BlocBuilder<LeaderboardBloc, LeaderboardState>(
      builder: (context, state) {
        final leaderboard = state.leaderboard;
        final entries = leaderboard.entries;
        final currentUserRank = leaderboard.currentUserRank;
        final bool showStickyCard =
            currentUserRank != null && currentUserRank.rank > 20;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppCommonBar(
            title: isImpact ? 'Impact Leaderboard' : 'Coins Leaderboard',
            showBack: true,
            showSearch: false,
            showNotifications: false,
            showProfile: false,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.help_outline_rounded,
                  size: 22,
                  color: AppColor.lightTextPrimary,
                ),
                tooltip: isImpact ? 'Impact Rules' : 'Coin Rules',
                onPressed: () => Navigator.pushNamed(
                  context,
                  isImpact ? AppRoutes.impactGuidelines : AppRoutes.coinGuidelines,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              ResponsiveContainer(
                child: Container(
                  color: Colors.white,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<LeaderboardBloc>().add(
                        const LeaderboardFetchRequested(forceRefresh: true),
                      );
                    },
                    color: isImpact ? const Color(0xFFC026D3) : AppColor.primaryBlue,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: showStickyCard ? 130 : 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Loading Skeleton ──
                          if (state.isLoading && entries.isEmpty)
                            const LeaderboardSkeleton()
                          // ── Error State ──
                          else if (state.isFailure && entries.isEmpty)
                            LeaderboardErrorView(
                              message: state.errorMessage,
                              onRetry: () {
                                context.read<LeaderboardBloc>().add(
                                  const LeaderboardFetchRequested(
                                    forceRefresh: true,
                                  ),
                                );
                              },
                            )
                          // ── Empty State ──
                          else if (entries.isEmpty)
                            LeaderboardEmptyState(
                              onRefresh: () {
                                context.read<LeaderboardBloc>().add(
                                  const LeaderboardFetchRequested(
                                    forceRefresh: true,
                                  ),
                                );
                              },
                            )
                          // ── Content: Top Three 3D Stage Podium + Rankings List ──
                          else ...[
                            // Top 3 3D Stage Podium
                            LeaderboardPodiumSection(
                              topThree: leaderboard.topThree,
                              isImpact: isImpact,
                            ),
                            const SizedBox(height: 8),

                            // Global Rankings List (Ranks 4 → 20)
                            LeaderboardRankingList(
                              rankings: leaderboard.globalRankings,
                              isImpact: isImpact,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Sticky Current User Ranking Card Overlay ──
              if (showStickyCard)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    top: false,
                    child: LeaderboardStickyUserCard(
                      userEntry: currentUserRank,
                      isImpact: isImpact,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

