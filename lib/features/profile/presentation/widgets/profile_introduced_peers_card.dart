import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../highlights/presentation/bloc/top_builders/top_builders_bloc.dart';
import '../../../highlights/presentation/bloc/top_builders/top_builders_state.dart';
import '../../../highlights/presentation/screens/top_community_builders_screen.dart';
import '../../../highlights/presentation/widgets/introduced_peer_tile.dart';

class ProfileIntroducedPeersCard extends StatelessWidget {
  const ProfileIntroducedPeersCard({super.key});

  void _navigateToMyIntroductions(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const TopCommunityBuildersScreen(initialTabIndex: 1),
      ),
    );
  }

  void _navigateToAddReferral(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addReferral);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopBuildersBloc, TopBuildersState>(
      builder: (context, state) {
        if (state.status == TopBuildersStatus.loading &&
            state.myIntroduced.isEmpty) {
          return _buildSkeleton();
        }

        final items = state.myIntroduced;
        final displayItems = items.take(3).toList();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColor.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildHeader(context, items.length),
              ),
              const SizedBox(height: 8),
              if (items.isEmpty)
                _buildEmptyState(context)
              else ...[
                ...displayItems.map(
                  (peer) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: IntroducedPeerTile(
                      peer: peer,
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    ),
                  ),
                ),
                if (items.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: _buildViewMoreButton(context, items.length),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
    return Row(
      children: [
        const Icon(Icons.people_alt_outlined, size: 18, color: AppColor.primaryBlue),
        const SizedBox(width: 6),
        Text(
          'Introduced Peers',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: AppColor.primaryBlue,
              ),
            ),
          ),
        ],
        const Spacer(),
        GestureDetector(
          onTap: () => _navigateToAddReferral(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColor.primaryBlue.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_rounded, size: 14, color: AppColor.primaryBlue),
                const SizedBox(width: 3),
                Text(
                  'Add More',
                  style: AppTypography.labelSmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildViewMoreButton(BuildContext context, int totalCount) {
    return InkWell(
      onTap: () => _navigateToMyIntroductions(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.primaryBlue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColor.primaryBlue.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              totalCount > 3 ? 'View More ($totalCount)' : 'View All',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColor.primaryBlue,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 11,
              color: AppColor.primaryBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            'No peers introduced yet',
            style: AppTypography.bodySmall.copyWith(
              color: AppColor.lightTextSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _navigateToAddReferral(context),
            child: Text(
              '+ Introduce / Invite a Peer',
              style: AppTypography.labelSmall.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor.primaryBlue,
          ),
        ),
      ),
    );
  }
}
