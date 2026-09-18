import 'package:flutter/material.dart';
import 'package:unity_app/core/constants/app_colors.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';

class SelectedPeerCard extends StatelessWidget {
  final PeerEntity? selectedPeer;
  final VoidCallback onTap;

  const SelectedPeerCard({
    super.key,
    required this.selectedPeer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Peer Member',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selectedPeer != null ? AppColors.primary : AppColors.borderLight,
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(
                    Icons.person_outline,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedPeer?.displayName ?? 'Select Peer Member',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selectedPeer != null ? FontWeight.w500 : FontWeight.w400,
                          color: selectedPeer != null
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (selectedPeer?.companyName != null &&
                          selectedPeer!.companyName!.isNotEmpty)
                        Text(
                          selectedPeer!.companyName!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
