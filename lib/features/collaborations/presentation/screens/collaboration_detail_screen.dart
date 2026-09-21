import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/collaboration.dart';
import '../bloc/collaborations_bloc.dart';
import '../bloc/collaborations_event.dart';
import '../bloc/collaborations_state.dart';

class CollaborationDetailScreen extends StatelessWidget {
  final Collaboration collaboration;

  const CollaborationDetailScreen({super.key, required this.collaboration});

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

    return BlocListener<CollaborationsBloc, CollaborationsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          (curr.status == CollaborationsStatus.success || curr.status == CollaborationsStatus.error),
      listener: (context, state) {
        if (state.status == CollaborationsStatus.success && state.successMessage != null) {
          AppSnackBar.showSuccess(context, state.successMessage!);
          Navigator.pop(context);
        } else if (state.status == CollaborationsStatus.error && state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        appBar: AppCommonBar(
          title: 'Collaboration Details',
          showBack: true,
          showSearch: false,
          showNotifications: false,
          showProfile: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(
                    text: 'Check out this collaboration opportunity: ${collaboration.title} on Peers Global Unity!\n\n${collaboration.description}',
                  ),
                );
              },
            ),
          ],
        ),
        body: AppGradientBackground(
          child: ResponsiveContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserHeader(context, isDark),
                  const SizedBox(height: 16),
                  Text(
                    collaboration.title,
                    style: AppTypography.titleMedium.copyWith(
                      color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoChips(isDark),
                  const SizedBox(height: 16),
                  _buildSection('Description', collaboration.description, isDark),
                  const SizedBox(height: 16),
                  _buildContextDetails(isDark),
                  const SizedBox(height: 24),
                  _buildAcceptButton(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () => _onPeerTap(context),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.1),
              backgroundImage: collaboration.user.profilePhotoUrl != null ? NetworkImage(collaboration.user.profilePhotoUrl!) : null,
              child: collaboration.user.profilePhotoUrl == null ? const Icon(Icons.person, color: AppColor.primaryBlue, size: 24) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collaboration.user.name,
                    style: AppTypography.titleSmall.copyWith(
                      color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (collaboration.user.city.isNotEmpty)
                    Text(
                      collaboration.user.city,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
            if (collaboration.isVerified)
              const Icon(Icons.verified_rounded, color: AppColor.primaryBlue, size: 20),
            const SizedBox(width: 4),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChips(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _chip(collaboration.collaborationType.label, AppColor.primaryBlue),
        if (collaboration.industry != null) _chip(collaboration.industry!.label, AppColor.primaryBlue),
        _chip(collaboration.scope.replaceAll('_', ' ').toUpperCase(), AppColor.warning),
        if (collaboration.preferredModel != null)
          _chip(collaboration.preferredModel!.replaceAll('_', ' ').toUpperCase(), AppColor.success),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
      child: Text(text, style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildSection(String title, String content, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.titleSmall.copyWith(color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text(content, style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildContextDetails(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Opportunity Context', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 10),
          _detailRow('Business Stage', collaboration.businessStage.replaceAll('_', ' '), isDark),
          _detailRow('Years in Operation', collaboration.yearsInOperation.replaceAll('_', ' '), isDark),
          _detailRow('Urgency', collaboration.urgency.replaceAll('_', ' '), isDark),
          if (collaboration.countriesOfInterest != null && collaboration.countriesOfInterest!.isNotEmpty)
            _detailRow('Countries', collaboration.countriesOfInterest!.join(', '), isDark),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary, fontWeight: FontWeight.w400)),
          ),
          Expanded(
            child: Text(value, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    final currentUserId = context.read<ProfileBloc>().state.profile?.id;
    if (!collaboration.isIncomplete || collaboration.user.id == currentUserId) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: () => context.read<CollaborationsBloc>().add(AcceptCollaborationEvent(collaboration.id)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text('Accept Collaboration', style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
