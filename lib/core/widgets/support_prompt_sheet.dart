import 'dart:io';
import 'package:flutter/material.dart';
import '../../features/menu/presentation/screens/submit_ticket_screen.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import '../utils/app_error_handler.dart';

class SupportPromptSheet extends StatefulWidget {
  final String? errorMessage;
  final dynamic originalError;
  final String? screenName;
  final File? screenshotFile;

  const SupportPromptSheet({
    super.key,
    this.errorMessage,
    this.originalError,
    this.screenName,
    this.screenshotFile,
  });

  static Future<void> show(
    BuildContext context, {
    String? errorMessage,
    dynamic originalError,
    String? screenName,
    File? screenshotFile,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SupportPromptSheet(
        errorMessage: errorMessage,
        originalError: originalError,
        screenName: screenName,
        screenshotFile: screenshotFile,
      ),
    );
  }

  @override
  State<SupportPromptSheet> createState() => _SupportPromptSheetState();
}

class _SupportPromptSheetState extends State<SupportPromptSheet> {
  final TextEditingController _reasonController = TextEditingController();
  bool _includeScreenshot = true; // Enabled by default as requested

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _proceedToSupport() {
    final screen = widget.screenName ?? 'Screen';
    final userReason = _reasonController.text.trim();

    final friendlyError = widget.errorMessage ??
        (widget.originalError != null
            ? AppErrorHandler.toUserFriendlyMessage(widget.originalError)
            : 'Unable to load data due to connection or server response.');

    final subject = 'Issue on $screen';

    String description;
    if (userReason.isNotEmpty) {
      description = '$userReason\n\n[Error Details on $screen]: $friendlyError';
    } else {
      description =
          'I encountered an error loading data on $screen.\n\nDetails: $friendlyError\nPlease assist in resolving this issue.';
    }

    final File? attachmentToSend =
        (_includeScreenshot && widget.screenshotFile != null)
            ? widget.screenshotFile
            : null;

    Navigator.of(context).pop();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubmitTicketScreen(
          initialSubject: subject,
          initialDescription: description,
          initialDepartment: 'Technical Issue',
          initialPriority: 'High',
          initialAttachment: attachmentToSend,
          screenName: widget.screenName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final hasScreenshot = widget.screenshotFile != null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: AppColor.primaryBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Issue & Get Support',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColor.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.screenName != null
                            ? 'Trouble loading ${widget.screenName}'
                            : 'Let our team know what happened',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColor.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: AppColor.lightTextTertiary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColor.lightBorder),
            const SizedBox(height: 16),

            // Screenshot option (Default: Enabled)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.lightScaffoldBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColor.lightBorder),
              ),
              child: Row(
                children: [
                  if (hasScreenshot && _includeScreenshot) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        widget.screenshotFile!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ] else ...[
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColor.lightBorder),
                      ),
                      child: const Icon(
                        Icons.screenshot_outlined,
                        color: AppColor.primaryBlue,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Include Screen Capture',
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColor.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hasScreenshot
                              ? (_includeScreenshot
                                  ? 'Screenshot attached automatically'
                                  : 'Screenshot disabled')
                              : 'Screen preview will be attached if available',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColor.lightTextSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: _includeScreenshot,
                    activeThumbColor: AppColor.primaryBlue,
                    onChanged: (val) {
                      setState(() {
                        _includeScreenshot = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Reason / What happened field
            Text(
              'WHAT HAPPENED? (OPTIONAL)',
              style: AppTypography.labelSmall.copyWith(
                color: AppColor.lightTextSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText:
                    'Describe the problem or leave blank to send automatic error info...',
                hintStyle: AppTypography.bodySmall.copyWith(
                  color: AppColor.lightTextDisabled,
                ),
                filled: true,
                fillColor: AppColor.lightScaffoldBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.lightBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColor.lightBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColor.primaryBlue, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 14,
                  color: AppColor.lightTextTertiary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'If blank, technical error details will be automatically prefilled.',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColor.lightTextTertiary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            // Action button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _proceedToSupport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(
                  'Continue to Help & Support',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
