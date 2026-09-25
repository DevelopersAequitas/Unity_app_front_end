import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import '../../domain/entities/entrepreneur_certification_result_entity.dart';
import 'certificate_share_helper.dart';

class EntrepreneurCertificateDialog extends StatelessWidget {
  final EntrepreneurCertificationResultEntity certificate;

  const EntrepreneurCertificateDialog({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    final certUrl = certificate.certificateUrl ?? '';
    final certTitle =
        certificate.certificationTier ?? 'Entrepreneur Certificate';
    final score = certificate.totalScore ?? 0;
    final percentage = certificate.percentage ?? 0;

    return Dialog.fullscreen(
      backgroundColor: const Color(0xFF0B0F19),
      child: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF111827),
                border: Border(
                  bottom: BorderSide(color: Color(0xFF1F2937), width: 1),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          certTitle,
                          style: AppTypography.titleSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.verified_rounded,
                              size: 13,
                              color: AppColor.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Verified Certificate Preview',
                              style: AppTypography.labelSmall.copyWith(
                                color: const Color(0xFF9CA3AF),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Interactive Certificate Canvas
            Expanded(
              child: Container(
                color: const Color(0xFF0B0F19),
                child: Center(
                  child: certUrl.isNotEmpty
                      ? InteractiveViewer(
                          panEnabled: true,
                          minScale: 1.0,
                          maxScale: 3.5,
                          boundaryMargin: EdgeInsets.zero,
                          clipBehavior: Clip.hardEdge,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.network(
                              certUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.primaryBlue,
                                    strokeWidth: 2,
                                  ),
                                );
                              },
                              errorBuilder: (_, _, _) => const Center(
                                child: Text(
                                  'Unable to load certificate image.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.workspace_premium_rounded,
                            size: 80,
                            color: AppColor.warning,
                          ),
                        ),
                ),
              ),
            ),

            // Bottom Actions Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF111827),
                border: Border(
                  top: BorderSide(color: Color(0xFF1F2937), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F2937),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Score: $score/100 ($percentage%)',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PrimaryPillButton(
                    label: 'Share',
                    iconData: Icons.share_rounded,
                    height: 36,
                    width: 96,
                    isOutlined: true,
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
                  ),
                  const SizedBox(width: 8),
                  PrimaryPillButton(
                    label: 'Save',
                    iconData: Icons.download_rounded,
                    height: 36,
                    width: 90,
                    onPressed: () {
                      CertificateShareHelper.downloadOrOpenCertificate(
                        context: context,
                        url: certUrl,
                        fileName:
                            'Entrepreneur_Certificate_${certificate.id}.jpg',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
