import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/peers_logo.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';

class TestimonialsHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;

  const TestimonialsHeader({
    super.key,
    this.onProfileTap,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onBackTap != null) ...[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColor.lightTextPrimary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: onBackTap,
                    ),
                    const SizedBox(width: 6),
                  ],
                  const PeersLogo(
                    iconSize: 26,
                    showText: true,
                  ),
                ],
              ),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, profileState) {
                  final user = profileState.profile;
                  return GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.primaryBlue.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                      ),
                      child: AppAvatar(
                        imageUrl: user?.profilePhotoUrl,
                        name: user?.displayName ?? 'Me',
                        size: 36,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Testimonials',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              letterSpacing: -0.3,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Recognition shared across your network.',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: AppColor.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
