import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../highlights/domain/entities/introduced_peer_entity.dart';
import '../../bloc/peer_profile_bloc.dart';
import '../../bloc/peer_profile_state.dart';
import '../../screens/peer_introduced_peers_screen.dart';
import '../../../../highlights/presentation/widgets/introduced_peer_tile.dart';

class PeerIntroducedPeersCard extends StatelessWidget {
  final String peerId;
  final String peerName;

  const PeerIntroducedPeersCard({
    super.key,
    required this.peerId,
    required this.peerName,
  });

  void _navigateToAllIntroduced(
    BuildContext context,
    List<IntroducedPeerEntity> peers,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PeerIntroducedPeersScreen(
          peerId: peerId,
          peerName: peerName,
          initialPeers: peers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeerProfileBloc, PeerProfileState>(
      builder: (context, state) {
        if (state.isIntroducedPeersLoading && state.introducedPeers.isEmpty) {
          return _buildSkeleton();
        }

        final items = state.introducedPeers;
        if (items.isEmpty) return const SizedBox.shrink();

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
                  child: _buildViewMoreButton(context, items),
                ),
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
      ],
    );
  }

  Widget _buildViewMoreButton(
    BuildContext context,
    List<IntroducedPeerEntity> items,
  ) {
    final totalCount = items.length;
    return InkWell(
      onTap: () => _navigateToAllIntroduced(context, items),
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
