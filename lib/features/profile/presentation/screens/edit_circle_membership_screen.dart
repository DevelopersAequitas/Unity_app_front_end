import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/profile_entity.dart';

class EditCircleMembershipScreen extends StatelessWidget {
  final ProfileEntity profile;

  const EditCircleMembershipScreen({
    super.key,
    required this.profile,
  });

  String _formatDate(String? isoDate) => AppDateFormatter.format(isoDate, defaultValue: 'N/A');

  @override
  Widget build(BuildContext context) {
    final activeCircle = profile.activeCircle;
    final memberships = profile.circleMemberships;
    final categories = profile.categories;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Circle & Membership',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Notice
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm + 2),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_outlined, color: Color(0xFF3B82F6), size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Circle membership and business category assignments are verified and managed by chapter administrators.',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColor.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Membership Overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColor.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MEMBERSHIP STATUS',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.textTertiary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        profile.membershipStatusLabel ?? profile.membershipStatus ?? 'Active Member',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColor.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                        ),
                        child: const Text(
                          'Verified',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildInfoRow('Active Circle', activeCircle?.name ?? 'Not Assigned'),
                  _buildInfoRow('Circle City', activeCircle?.city?.name ?? 'Not Assigned'),
                  _buildInfoRow('Joined Date', _formatDate(profile.circleJoinedAt)),
                  _buildInfoRow('Expires Date', _formatDate(profile.circleExpiresAt)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Circle Memberships List
            if (memberships.isNotEmpty) ...[
              Text(
                'ENROLLED CIRCLES (${memberships.length})',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColor.textTertiary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...memberships.map((m) {
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.all(AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColor.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            m.circleName,
                            style: AppTypography.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColor.textPrimary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColor.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                            ),
                            child: Text(
                              (m.memberRole ?? 'Member').toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${m.memberStatus} • Payment: ${m.paymentStatus}',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColor.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.sm),
            ],

            // Category Hierarchy
            if (categories.isNotEmpty) ...[
              Text(
                'BUSINESS CATEGORY PATH',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColor.textTertiary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ...categories.map((c) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.all(AppSpacing.sm + 2),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColor.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (c.level1 != null && c.level1!.isNotEmpty)
                        _buildCategoryStep('L1: Domain', c.level1!),
                      if (c.level2 != null && c.level2!.isNotEmpty)
                        _buildCategoryStep('L2: Specialization', c.level2!),
                      if (c.level3 != null && c.level3!.isNotEmpty)
                        _buildCategoryStep('L3: Segment', c.level3!),
                      if (c.level4 != null && c.level4!.isNotEmpty)
                        _buildCategoryStep('L4: Focus', c.level4!),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: AppColor.textTertiary, fontSize: 11),
          ),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppColor.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStep(String level, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              level,
              style: AppTypography.labelSmall.copyWith(
                color: AppColor.textTertiary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
