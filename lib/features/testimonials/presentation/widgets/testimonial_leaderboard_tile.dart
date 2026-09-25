import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../peers/presentation/widgets/peer_card.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/testimonial_leaderboard_entity.dart';

class TestimonialLeaderboardTile extends StatelessWidget {
  final TestimonialLeaderboardEntity item;
  const TestimonialLeaderboardTile({super.key, required this.item});

  Color _rankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return AppColor.primaryBlue;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = context.watch<ProfileBloc>().state.profile?.id ??
        context.watch<AuthBloc>().state.user?.id;
    final isCurrentUser = currentUserId != null && currentUserId == item.id;
    final peer = item.toPeerEntity();
    final rankColor = _rankColor(item.rank);

    final countLabel = '${item.testimonialsCount} ${item.testimonialsCount == 1 ? 'Testimonial' : 'Testimonials'}';
    final ratingLabel = item.avgRating > 0 ? ' • ${item.avgRating.toStringAsFixed(1)} ★' : '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      item.rank <= 3 ? Icons.emoji_events_rounded : Icons.workspace_premium_rounded,
                      size: 15,
                      color: rankColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Rank #${item.rank}',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$countLabel$ratingLabel',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          PeerCard(
            key: ValueKey(item.id),
            peer: peer,
            isCurrentUser: isCurrentUser,
            margin: EdgeInsets.zero,
            showBorder: false,
            showActions: false,
            onBookmark: () {},
            onTap: () => Navigator.pushNamed(
              context,
              isCurrentUser ? AppRoutes.profile : AppRoutes.peerProfile,
              arguments: item.id,
            ),
          ),
        ],
      ),
    );
  }
}
