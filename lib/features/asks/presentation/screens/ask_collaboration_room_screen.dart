import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../widgets/ask_collaboration_stepper.dart';
import '../widgets/ask_step_header.dart';

class AskCollaborationRoomScreen extends StatefulWidget {
  final AskMatchPeerEntity peer;
  final AskSubmissionEntity submission;
  final bool isPoster;

  const AskCollaborationRoomScreen({
    super.key,
    required this.peer,
    required this.submission,
    this.isPoster = true,
  });

  @override
  State<AskCollaborationRoomScreen> createState() =>
      _AskCollaborationRoomScreenState();
}

class _AskCollaborationRoomScreenState
    extends State<AskCollaborationRoomScreen> {
  int _currentStepIndex = 2; // Step 3 (Confidentiality) is current in design

  List<CollaborationStepItem> _getSteps() {
    return [
      CollaborationStepItem(
        title: 'Intro call',
        description: 'Held',
        isCompleted: _currentStepIndex > 0,
        isCurrent: _currentStepIndex == 0,
      ),
      CollaborationStepItem(
        title: 'Fit check',
        description: 'Both agreed to continue',
        isCompleted: _currentStepIndex > 1,
        isCurrent: _currentStepIndex == 1,
      ),
      CollaborationStepItem(
        title: 'Confidentiality',
        description: 'Both sides acknowledge',
        isCompleted: _currentStepIndex > 2,
        isCurrent: _currentStepIndex == 2,
      ),
      CollaborationStepItem(
        title: 'Snapshot',
        description: 'A one-page, non-binding sketch',
        isCompleted: _currentStepIndex > 3,
        isCurrent: _currentStepIndex == 3,
      ),
      CollaborationStepItem(
        title: 'Pilot / meeting',
        description: 'Track progress',
        isCompleted: _currentStepIndex > 4,
        isCurrent: _currentStepIndex == 4,
      ),
      CollaborationStepItem(
        title: 'Outcome',
        description: 'Formalise, or part ways',
        isCompleted: _currentStepIndex > 5,
        isCurrent: _currentStepIndex == 5,
      ),
    ];
  }

  void _onNextStep() {
    if (!widget.isPoster) return;

    if (_currentStepIndex < 5) {
      setState(() => _currentStepIndex++);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Stage updated successfully!'),
          backgroundColor: AppColor.primaryBlue,
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.askCollaborationOutcome,
        arguments: {
          'peer': widget.peer,
          'submission': widget.submission,
        },
      );
    }
  }

  void _onStepTapped(int index) {
    if (!widget.isPoster) return;

    if (index == 5) {
      Navigator.of(context).pushNamed(
        AppRoutes.askCollaborationOutcome,
        arguments: {
          'peer': widget.peer,
          'submission': widget.submission,
        },
      );
    } else {
      setState(() => _currentStepIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final partnerName =
        widget.peer.name.isNotEmpty ? widget.peer.name : 'Peer';
    final typeName = widget.submission.type.name.isNotEmpty
        ? widget.submission.type.name
        : 'Manufacturing Partner';

    String buttonLabel;
    if (_currentStepIndex < 5) {
      buttonLabel = 'Complete ${_getSteps()[_currentStepIndex].title}';
    } else if (_currentStepIndex == 5) {
      buttonLabel = 'Complete Outcome';
    } else {
      buttonLabel = 'Finish & Return Home';
    }

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: const AppCommonBar(
        title: 'Collaboration Room',
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            AskStepHeader(
              title: 'Collaboration Room',
              subtitle: '[$partnerName] and you · $typeName',
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AskCollaborationStepper(
                  steps: _getSteps(),
                  onStepTap: widget.isPoster ? _onStepTapped : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? const Color(0xFF334155).withValues(alpha: 0.5)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              ),
              child: widget.isPoster
                  ? SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColor.brandGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: _onNextStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            buttonLabel,
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColor.darkSurfaceSubtle
                            : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColor.primaryBlue.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: AppColor.primaryBlue,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Collaboration stages are updated by the ask author ($partnerName).',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF1E40AF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
