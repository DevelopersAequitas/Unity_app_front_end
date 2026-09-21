import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/entrepreneur_certification_result_entity.dart';
import 'certificate_share_helper.dart';

class EntrepreneurCertificateCard extends StatelessWidget {
  final EntrepreneurCertificationResultEntity certificate;
  final VoidCallback? onViewCertificate;

  const EntrepreneurCertificateCard({
    super.key,
    required this.certificate,
    this.onViewCertificate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final certUrl = certificate.certificateUrl ?? '';
    final certTitle = certificate.certificationTier ?? 'Master Entrepreneur';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColor.warning.withValues(alpha: 0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.warning.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: AppColor.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Verified Entrepreneur Certificate',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColor.warning,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (certUrl.isNotEmpty)
                  GestureDetector(
                    onTap: onViewCertificate,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? AppColor.darkBorder
                              : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.network(
                          certUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (_, child, progress) {
                            if (progress == null) return child;
                            return const SizedBox(
                              height: 220,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primaryBlue,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, _, _) => _buildPlaceholder(),
                        ),
                      ),
                    ),
                  )
                else
                  _buildPlaceholder(),
                const SizedBox(height: 12),
                Text(
                  certTitle,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: primaryTextColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Score: ${certificate.totalScore ?? 0} / 100 (${certificate.percentage ?? 0}%)',
                  style: AppTypography.bodySmall.copyWith(
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton.icon(
                          onPressed: onViewCertificate,
                          icon: const Icon(Icons.fullscreen_rounded, size: 16),
                          label: const Text('View Full'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: IconButton.filledTonal(
                        onPressed: () {
                          CertificateShareHelper.shareCertificate(
                            context: context,
                            title: 'Entrepreneur Certification',
                            tier: certTitle,
                            certificateUrl: certUrl,
                            score: certificate.totalScore,
                            percentage: certificate.percentage,
                          );
                        },
                        icon: const Icon(Icons.share_rounded, size: 16),
                        tooltip: 'Share',
                        style: IconButton.styleFrom(
                          backgroundColor:
                              AppColor.primaryBlue.withValues(alpha: 0.1),
                          foregroundColor: AppColor.primaryBlue,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: IconButton.filledTonal(
                        onPressed: () {
                          CertificateShareHelper.downloadOrOpenCertificate(
                            context: context,
                            url: certUrl,
                            fileName:
                                'Entrepreneur_Certificate_${certificate.id}.jpg',
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 16),
                        tooltip: 'Download',
                        style: IconButton.styleFrom(
                          backgroundColor:
                              AppColor.primaryBlue.withValues(alpha: 0.1),
                          foregroundColor: AppColor.primaryBlue,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColor.primaryBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Icon(
          Icons.workspace_premium_rounded,
          size: 48,
          color: AppColor.warning,
        ),
      ),
    );
  }
}
