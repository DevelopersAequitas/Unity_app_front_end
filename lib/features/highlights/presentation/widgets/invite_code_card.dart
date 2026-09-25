import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';

class InviteCodeCard extends StatelessWidget {
  final String referralCode;
  final String referralLink;

  const InviteCodeCard({
    super.key,
    required this.referralCode,
    required this.referralLink,
  });

  String _resolveCode(BuildContext context) {
    if (referralCode.trim().isNotEmpty) return referralCode.trim();
    final profile = context.read<ProfileBloc>().state.profile;
    if (profile?.referralCode != null &&
        profile!.referralCode!.trim().isNotEmpty) {
      return profile.referralCode!.trim();
    }
    return '';
  }

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    AppSnackBar.showSuccess(context, 'Invite code copied: $code');
  }

  void _shareLink(BuildContext context, String code) {
    final link = referralLink.isNotEmpty
        ? referralLink
        : 'https://dev.peersunity.com/register?ref=$code';
    SharePlus.instance.share(
      ShareParams(
        text: 'Join me on Peers Unity - the premier entrepreneur collaboration community!\n👉 $link',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final code = _resolveCode(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.card_giftcard_rounded, size: 18, color: AppColor.primaryBlue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'YOUR EXCLUSIVE INVITE CODE',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  code,
                  style: AppTypography.titleSmall.copyWith(
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 17, color: AppColor.primaryBlue),
            tooltip: 'Copy Code',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
            onPressed: () => _copyCode(context, code),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 17, color: AppColor.primaryBlue),
            tooltip: 'Share Link',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
            onPressed: () => _shareLink(context, code),
          ),
        ],
      ),
    );
  }
}
