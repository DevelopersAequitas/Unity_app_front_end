import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/leadership_certification_result_entity.dart';
import 'certificate_share_helper.dart';

class LeadershipCertificateDialog extends StatelessWidget {
  final LeadershipCertificationResultEntity certificate;

  const LeadershipCertificateDialog({super.key, required this.certificate});

  @override
  Widget build(BuildContext context) {
    final certUrl = certificate.certificateUrl ?? '';
    final certTitle =
        certificate.certificationLevel ?? 'Leadership Certificate';
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
                          minScale: 0.5,
                          maxScale: 4.0,
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
                  SizedBox(
                    height: 38,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        CertificateShareHelper.shareCertificate(
                          context: context,
                          title: 'Leadership Certification',
                          tier: certTitle,
                          certificateUrl: certUrl,
                          score: certificate.totalScore,
                          percentage: certificate.percentage,
                        );
                      },
                      icon: const Icon(Icons.share_rounded, size: 15),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF374151)),
                        backgroundColor: const Color(0xFF1F2937),
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 38,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        CertificateShareHelper.downloadOrOpenCertificate(
                          context: context,
                          url: certUrl,
                          fileName:
                              'Leadership_Certificate_${certificate.id}.jpg',
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 15),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
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
