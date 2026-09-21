import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/collaboration.dart';

class CollaborationCard extends StatelessWidget {
  final Collaboration collaboration;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;

  const CollaborationCard({
    super.key,
    required this.collaboration,
    this.onTap,
    this.onAccept,
  });

  void _onPeerTap(BuildContext context) {
    final userId = collaboration.user.id;
    if (userId.isEmpty) return;
    final authUser = context.read<AuthBloc>().state.user;
    final myId = authUser?.id ?? '';
    if (myId.isNotEmpty && userId == myId) {
      Navigator.of(context).pushNamed(AppRoutes.profile);
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.peerProfile,
        arguments: userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = collaboration.isCompleted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _onPeerTap(context),
                    behavior: HitTestBehavior.opaque,
                    child: _avatar(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collaboration.title,
                          style: AppTypography.titleSmall.copyWith(
                            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () => _onPeerTap(context),
                          behavior: HitTestBehavior.opaque,
                          child: Text(
                            'Posted by ${collaboration.user.name}',
                            style: AppTypography.bodySmall.copyWith(color: AppColor.primaryBlue, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _badge(isCompleted ? 'COMPLETED' : 'OPEN', isCompleted ? AppColor.success : AppColor.warning),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                collaboration.description,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              _buildMetaRow(isDark),
              if (collaboration.isIncomplete && onAccept != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text('Accept Collaboration', style: AppTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.1),
      backgroundImage: collaboration.user.profilePhotoUrl != null ? NetworkImage(collaboration.user.profilePhotoUrl!) : null,
      child: collaboration.user.profilePhotoUrl == null ? const Icon(Icons.person, color: AppColor.primaryBlue, size: 20) : null,
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildMetaRow(bool isDark) {
    final textColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        _metaItem(Icons.category_outlined, collaboration.collaborationType.label, textColor),
        if (collaboration.industry != null) _metaItem(Icons.business_center_outlined, collaboration.industry!.label, textColor),
        if (collaboration.user.city.isNotEmpty) _metaItem(Icons.location_on_outlined, collaboration.user.city, textColor),
      ],
    );
  }

  Widget _metaItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(text, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
