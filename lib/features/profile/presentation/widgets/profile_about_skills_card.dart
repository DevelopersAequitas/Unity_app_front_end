import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileAboutSkillsCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileAboutSkillsCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final hasSkills = profile.skills.isNotEmpty;
    final hasHelp = profile.iCanHelpWith.isNotEmpty;
    final hasLooking = profile.iAmLookingFor.isNotEmpty;

    if (!hasSkills && !hasHelp && !hasLooking) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasSkills) ...[
            _buildSectionHeader('Skills & Expertise', Icons.psychology_outlined),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: profile.skills.map((s) => _buildChip(s, AppColor.primaryBlue)).toList(),
            ),
          ],
          if (hasHelp) ...[
            if (hasSkills) const SizedBox(height: 12),
            _buildSectionHeader('I Can Help With', Icons.handshake_outlined),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: profile.iCanHelpWith.map((h) => _buildChip(h, AppColor.accentGreen)).toList(),
            ),
          ],
          if (hasLooking) ...[
            if (hasSkills || hasHelp) const SizedBox(height: 12),
            _buildSectionHeader('Looking For', Icons.search_outlined),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: profile.iAmLookingFor.map((l) => _buildChip(l, AppColor.primaryBlue)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColor.lightTextTertiary),
        const SizedBox(width: 6),
        Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12.5,
            color: AppColor.lightTextPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
