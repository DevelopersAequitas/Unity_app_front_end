import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/gratitude_script_entity.dart';

class GratitudeCardPreview extends StatelessWidget {
  final GratitudeScriptEntity script;

  const GratitudeCardPreview({super.key, required this.script});

  void _copyScript(BuildContext context) {
    Clipboard.setData(ClipboardData(text: script.buildFullScript()));
    AppSnackBar.showSuccess(context, 'Full script copied to clipboard!');
  }

  void _shareScript() {
    SharePlus.instance.share(
      ShareParams(text: '🎙️ Monthly Impact Script:\n\n${script.buildFullScript()}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(gradient: AppColor.brandGradient, borderRadius: BorderRadius.circular(6)),
                child: const Text('MONTHLY IMPACT SCRIPT', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w500, color: Colors.white, letterSpacing: 0.4)),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 17, color: AppColor.primaryBlue),
                    tooltip: 'Copy Full Script',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () => _copyScript(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 17, color: AppColor.primaryBlue),
                    tooltip: 'Share Script',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: _shareScript,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(script.greetingText, style: AppTypography.titleSmall.copyWith(color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          if (script.introductionText.isNotEmpty) _buildParagraph(script.introductionText, isDark),
          if (script.monthlyLivesImpactedText.isNotEmpty) _buildParagraph(script.monthlyLivesImpactedText, isDark),
          if (script.monthlyBusinessDoneText.isNotEmpty) _buildParagraph(script.monthlyBusinessDoneText, isDark),
          if (script.checklist.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...script.checklist.take(3).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 3, left: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: AppColor.primaryBlue, fontSize: 11)),
                        Expanded(child: _buildParagraph(item, isDark, marginBottom: 0)),
                      ],
                    ),
                  ),
                ),
          ],
          if (script.businessDealsText.isNotEmpty) _buildParagraph(script.businessDealsText, isDark),
          if (script.lifetimeImpactText.isNotEmpty) _buildParagraph(script.lifetimeImpactText, isDark),
          if (script.progressWord.isNotEmpty) _buildHighlightBlock('Progress:', script.progressWord, isDark),
          if (script.nextMonthGoal.isNotEmpty) _buildHighlightBlock('Goal:', script.nextMonthGoal, isDark),
          if (script.experienceStory.isNotEmpty) _buildHighlightBlock('Story:', script.experienceStory, isDark),
          const SizedBox(height: 6),
          Text(script.closingText, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary, fontStyle: FontStyle.italic, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildParagraph(String text, bool isDark, {double marginBottom = 4}) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom),
      child: Text(text, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary, fontSize: 11.5, height: 1.35)),
    );
  }

  Widget _buildHighlightBlock(String title, String content, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(color: AppColor.primaryBlue.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title ', style: AppTypography.labelSmall.copyWith(color: AppColor.primaryBlue, fontWeight: FontWeight.w500, fontSize: 10.5)),
          Expanded(child: Text(content, style: AppTypography.bodySmall.copyWith(color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary, fontSize: 10.5))),
        ],
      ),
    );
  }
}


