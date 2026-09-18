import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/testimonials_bloc.dart';
import '../bloc/testimonials_state.dart';
import 'testimonial_card.dart';

class TestimonialsCard extends StatelessWidget {
  final String? peerId;
  final String? peerName;
  final bool isOwnProfile;
  final VoidCallback? onViewMore;

  const TestimonialsCard({
    super.key,
    this.peerId,
    this.peerName,
    this.isOwnProfile = false,
    this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestimonialsBloc, TestimonialsState>(
      builder: (context, state) {
        if (state.receivedStatus == TestimonialsStatus.loading && state.testimonials.isEmpty) {
          return _buildLoadingSkeleton();
        }

        final items = state.testimonials;
        final displayItems = items.take(3).toList();

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColor.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.rate_review_outlined,
                    size: 18,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Received Testimonials',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: AppColor.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (items.isNotEmpty)
                    GestureDetector(
                      onTap: onViewMore ?? () => _navigateToTestimonials(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColor.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${items.length}',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: AppColor.primaryBlue,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            size: 15,
                            color: AppColor.primaryBlue,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (items.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColor.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'No testimonials received yet',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightTextTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else ...[
                ...displayItems.map((t) => TestimonialCard(testimonial: t, tabType: 'received')),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: onViewMore ?? () => _navigateToTestimonials(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.primaryBlue,
                        side: const BorderSide(color: AppColor.primaryBlue, width: 0.9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'View All (${items.length})',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _navigateToTestimonials(BuildContext context) {
    if (!isOwnProfile && peerId != null && peerId!.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.peerTestimonials,
        arguments: {
          'peerId': peerId,
          'peerName': peerName ?? 'Peer',
        },
      );
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.testimonials,
      );
    }
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
        ),
      ),
    );
  }
}
