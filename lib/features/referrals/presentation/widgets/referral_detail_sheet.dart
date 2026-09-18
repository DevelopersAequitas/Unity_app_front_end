import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../domain/entities/referral_entity.dart';
import '../bloc/referrals_bloc.dart';
import '../bloc/referrals_event.dart';
import 'referral_share_helper.dart';
import 'referral_status_update_sheet.dart';

class ReferralDetailSheet extends StatelessWidget {
  final ReferralEntity referral;
  final String? currentUserName;
  final String tabType;
  final String dateStr;

  const ReferralDetailSheet({
    super.key,
    required this.referral,
    this.currentUserName,
    this.tabType = 'received',
    required this.dateStr,
  });

  static Future<void> show(
    BuildContext context, {
    required ReferralEntity referral,
    String? currentUserName,
    String tabType = 'received',
    required String dateStr,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (_) => ReferralDetailSheet(
        referral: referral,
        currentUserName: currentUserName,
        tabType: tabType,
        dateStr: dateStr,
      ),
    );
  }

  void _onShare(BuildContext context) {
    Navigator.pop(context);
    ReferralShareHelper.shareReferral(
      referral: referral,
      currentUserName: currentUserName,
      tabType: tabType,
    );
  }

  void _onPeerTap(BuildContext context) {
    Navigator.pop(context);
    final peerId = referral.fromUserId ?? referral.toUserId;
    if (peerId != null && peerId.isNotEmpty) {
      Navigator.pushNamed(context, AppRoutes.peerProfile, arguments: peerId);
    }
  }

  void _openStatusUpdateSheet(BuildContext context) {
    final bloc = context.read<ReferralsBloc>();
    ReferralStatusUpdateSheet.show(
      context,
      referral: referral,
      availableStatuses: bloc.state.availableStatuses,
      onStatusSelected: (statusId, statusName) {
        bloc.add(ReferralStatusUpdated(
          referralId: referral.id,
          statusId: statusId,
          statusName: statusName,
        ));
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFD97706);
      case 'contacted':
        return const Color(0xFF2563EB);
      case 'got business':
        return const Color(0xFF059669);
      case 'not qualified':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF4F46E5);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFEF3C7);
      case 'contacted':
        return const Color(0xFFDBEAFE);
      case 'got business':
        return const Color(0xFFD1FAE5);
      case 'not qualified':
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFEEF2FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final designation = referral.peerDesignation?.trim() ?? '';
    final company = referral.peerCompany?.trim() ?? '';
    final city = (referral.city ?? referral.peerLocation)?.trim() ?? '';
    final category = referral.category?.trim() ?? '';
    final remarks = referral.remarks?.trim() ?? '';
    final statusColor = _getStatusColor(referral.statusName);
    final statusBgColor = _getStatusBgColor(referral.statusName);

    final subLine = [
      if (designation.isNotEmpty) designation,
      if (company.isNotEmpty) company,
    ].join(' · ');

    return Material(
      color: AppColor.lightSurface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header Row: Date & Time + Share icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: AppColor.lightTextTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: AppColor.primaryBlue,
                  ),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () => _onShare(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Peer Row
                    GestureDetector(
                      onTap: () => _onPeerTap(context),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppAvatar(
                            imageUrl: referral.peerPhotoUrl,
                            name: referral.peerName,
                            size: 46,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Name + PRO badge
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        referral.peerName.toUpperCase(),
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 0.3,
                                          color: AppColor.lightTextPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (referral.isPro) ...[
                                      const SizedBox(width: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: AppColor.brandGradient,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'PRO',
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.white,
                                            letterSpacing: 0.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),

                                // 2. City
                                if (city.isNotEmpty) ...[
                                  const SizedBox(height: 1),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 11,
                                        color: AppColor.lightTextTertiary,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        city,
                                        style:
                                            AppTypography.labelSmall.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.lightTextTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                // 3. Designation · Company
                                if (subLine.isNotEmpty) ...[
                                  const SizedBox(height: 1),
                                  Text(
                                    subLine,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.lightTextSecondary,
                                    ),
                                  ),
                                ],

                                // 4. Category
                                if (category.isNotEmpty) ...[
                                  const SizedBox(height: 1),
                                  AppGradientText(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Referral Info Showcase Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColor.primaryBlue.withValues(alpha: 0.08),
                            const Color(0xFF7C3AED).withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColor.primaryBlue.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                referral.referralTypeLabel.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  color: AppColor.primaryBlue,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _openStatusUpdateSheet(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusBgColor,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: statusColor.withValues(alpha: 0.4),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: statusColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        referral.statusName,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: statusColor,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 13,
                                        color: statusColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  referral.referralOf,
                                  style: AppTypography.titleLarge.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.lightTextPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryBlue
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Priority ${referral.hotValue} of 5',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.primaryBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: AppColor.lightTextTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Referral Date: ${referral.referralDate}',
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 11.5,
                                  color: AppColor.lightTextTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Contact Details
                    if ((referral.phone != null && referral.phone!.trim().isNotEmpty) ||
                        (referral.email != null && referral.email!.trim().isNotEmpty) ||
                        (referral.address != null && referral.address!.trim().isNotEmpty)) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Contact Details',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColor.lightBorder),
                        ),
                        child: Column(
                          children: [
                            if (referral.phone != null && referral.phone!.trim().isNotEmpty) ...[
                              InkWell(
                                onTap: () async {
                                  final uri = Uri.parse('tel:${referral.phone!.trim()}');
                                  if (await canLaunchUrl(uri)) launchUrl(uri);
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.phone_rounded,
                                        size: 16,
                                        color: AppColor.primaryBlue,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          referral.phone!.trim(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.primaryBlue,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_outward_rounded,
                                        size: 14,
                                        color: AppColor.primaryBlue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (referral.email != null && referral.email!.trim().isNotEmpty) ...[
                              if (referral.phone != null && referral.phone!.trim().isNotEmpty)
                                const Divider(height: 12, color: AppColor.lightBorder),
                              InkWell(
                                onTap: () async {
                                  final uri = Uri.parse('mailto:${referral.email!.trim()}');
                                  if (await canLaunchUrl(uri)) launchUrl(uri);
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.email_rounded,
                                        size: 16,
                                        color: Color(0xFF7C3AED),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          referral.email!.trim(),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: AppColor.lightTextPrimary,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_outward_rounded,
                                        size: 14,
                                        color: AppColor.lightTextTertiary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (referral.address != null && referral.address!.trim().isNotEmpty) ...[
                              if ((referral.phone != null && referral.phone!.trim().isNotEmpty) ||
                                  (referral.email != null && referral.email!.trim().isNotEmpty))
                                const Divider(height: 12, color: AppColor.lightBorder),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.location_on_rounded,
                                      size: 16,
                                      color: AppColor.primaryPink,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        referral.address!.trim(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.lightTextPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],

                    if (remarks.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Remarks / Requirements',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '“$remarks”',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightTextPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Primary Share Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => _onShare(context),
                icon: const Icon(Icons.share_outlined, size: 16),
                label: const Text(
                  'Share Referral',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
