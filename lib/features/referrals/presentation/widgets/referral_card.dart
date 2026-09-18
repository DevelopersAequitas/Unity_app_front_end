import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/referral_entity.dart';
import '../bloc/referrals_bloc.dart';
import '../bloc/referrals_event.dart';
import 'referral_detail_sheet.dart';
import 'referral_options_sheet.dart';
import 'referral_status_update_sheet.dart';

String _formatDateTime(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    final dt = DateTime.parse(raw).toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} · $hour:$minute $ampm';
  } catch (_) {
    return raw;
  }
}

class ReferralCard extends StatelessWidget {
  final ReferralEntity referral;
  final String tabType;

  const ReferralCard({
    super.key,
    required this.referral,
    this.tabType = 'received',
  });

  void _onPeerTap(BuildContext context) {
    final peerId = referral.fromUserId ?? referral.toUserId;
    if (peerId != null && peerId.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.peerProfile,
        arguments: peerId,
      );
    }
  }

  void _showOptions(BuildContext context) {
    String? currentUserName;
    try {
      currentUserName = context.read<ProfileBloc>().state.profile?.displayName;
    } catch (_) {}

    ReferralOptionsSheet.show(
      context,
      referral: referral,
      currentUserName: currentUserName,
      tabType: tabType,
    );
  }

  void _openDetailSheet(BuildContext context, String dateStr) {
    String? currentUserName;
    try {
      currentUserName = context.read<ProfileBloc>().state.profile?.displayName;
    } catch (_) {}

    ReferralDetailSheet.show(
      context,
      referral: referral,
      currentUserName: currentUserName,
      tabType: tabType,
      dateStr: dateStr,
    );
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
        return const Color(0xFFD97706); // Amber
      case 'contacted':
        return const Color(0xFF2563EB); // Blue
      case 'got business':
        return const Color(0xFF059669); // Emerald
      case 'not qualified':
        return const Color(0xFFDC2626); // Rose
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
    final dateStr = _formatDateTime(referral.createdAt);
    final designation = referral.peerDesignation?.trim() ?? '';
    final company = referral.peerCompany?.trim() ?? '';
    final city = (referral.city ?? referral.peerLocation)?.trim() ?? '';
    final category = referral.category?.trim() ?? '';
    final remarks = (referral.remarks ?? '').trim();
    final isLongText = remarks.length > 80;
    final statusColor = _getStatusColor(referral.statusName);
    final statusBgColor = _getStatusBgColor(referral.statusName);

    final subLine = [
      if (designation.isNotEmpty) designation,
      if (company.isNotEmpty) company,
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightBorder, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Timestamp + Three Dots Menu ──
          Row(
            children: [
              Expanded(
                child: Text(
                  dateStr,
                  style: const TextStyle(
                    color: AppColor.lightTextTertiary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showOptions(context),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 2),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 18,
                    color: AppColor.lightTextTertiary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // ── Row 2: Avatar + Peer Info ──
          GestureDetector(
            onTap: () => _onPeerTap(context),
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(
                  imageUrl: referral.peerPhotoUrl,
                  name: referral.peerName,
                  size: 42,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Name in UPPERCASE + PRO badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              referral.peerName.toUpperCase(),
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
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
                                borderRadius: BorderRadius.circular(4),
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
                              size: 10.5,
                              color: AppColor.lightTextTertiary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              city,
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 10.5,
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
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // 4. Category
                      if (category.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        AppGradientText(
                          category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Row 3: Referral Party Info Box ──
          GestureDetector(
            onTap: () => _openDetailSheet(context, dateStr),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.lightBorder.withValues(alpha: 0.8),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Referral Type Chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          referral.referralTypeLabel,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                      ),

                      // Status Badge (Interactive)
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
                              color: statusColor.withValues(alpha: 0.3),
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
                                  fontSize: 10.5,
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

                  // Referral of (Party name)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          referral.referralOf,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.5,
                            color: AppColor.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Hot Value indicator
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Priority ${referral.hotValue}/5',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Quick contact action icons if available
                  if ((referral.phone != null && referral.phone!.trim().isNotEmpty) ||
                      (referral.email != null && referral.email!.trim().isNotEmpty)) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (referral.phone != null && referral.phone!.trim().isNotEmpty) ...[
                          InkWell(
                            onTap: () async {
                              final uri = Uri.parse('tel:${referral.phone!.trim()}');
                              if (await canLaunchUrl(uri)) launchUrl(uri);
                            },
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.phone_outlined,
                                    size: 12,
                                    color: AppColor.primaryBlue,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    referral.phone!.trim(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColor.primaryBlue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (referral.email != null && referral.email!.trim().isNotEmpty) ...[
                          InkWell(
                            onTap: () async {
                              final uri = Uri.parse('mailto:${referral.email!.trim()}');
                              if (await canLaunchUrl(uri)) launchUrl(uri);
                            },
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 12,
                                    color: AppColor.lightTextSecondary,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    referral.email!.trim(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColor.lightTextSecondary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Row 4: Referral Remarks / Notes if present ──
          if (remarks.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _openDetailSheet(context, dateStr),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '“$remarks”',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightTextPrimary.withValues(alpha: 0.88),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isLongText) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Read more',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
