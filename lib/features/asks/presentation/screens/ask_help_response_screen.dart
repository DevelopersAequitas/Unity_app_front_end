import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../bloc/ask_response/ask_response_bloc.dart';
import '../bloc/ask_response/ask_response_event.dart';
import '../bloc/ask_response/ask_response_state.dart';
import '../widgets/ask_bottom_button.dart';

class AskHelpResponseScreen extends StatefulWidget {
  final AskMatchPeerEntity peer;
  final AskSubmissionEntity submission;
  final String askId;

  const AskHelpResponseScreen({
    super.key,
    required this.peer,
    required this.submission,
    required this.askId,
  });

  @override
  State<AskHelpResponseScreen> createState() => _AskHelpResponseScreenState();
}

class _AskHelpResponseScreenState extends State<AskHelpResponseScreen> {
  String _stance = 'can_help_directly';
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    context.read<AskResponseBloc>().add(
          AskResponseSubmitRequested(
            askId: widget.askId,
            responseType: _stance,
            message: _noteController.text.trim(),
            timeline: 'immediate',
          ),
        );
  }

  Widget _buildRadioOption(String value, String label, bool isDark) {
    final isSelected = _stance == value;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isSelected
        ? AppColor.primaryBlue
        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return InkWell(
      onTap: () => setState(() => _stance = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 0.8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColor.primaryBlue : const Color(0xFF94A3B8),
                  width: 2,
                ),
                color: isSelected ? AppColor.primaryBlue : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.circle, size: 7, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? (isDark ? Colors.white : AppColor.primaryBlue) : textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final askTitle = widget.submission.effectiveGoal.isNotEmpty
        ? widget.submission.effectiveGoal
        : 'Guidance on sales and growth as we scale';

    return BlocConsumer<AskResponseBloc, AskResponseState>(
      listener: (context, state) {
        if (state.status == AskResponseStatus.success) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.askCollaborationRoom,
            arguments: {
              'peer': widget.peer,
              'submission': widget.submission,
            },
          );
        } else if (state.status == AskResponseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Unable to send response'),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AskResponseStatus.loading;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          appBar: const AppCommonBar(
            title: 'Help',
            showBack: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'How can you help?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ask Title Box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: Text(
                            askTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                              height: 1.35,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildRadioOption('can_help_directly', 'I can help', isDark),
                        const SizedBox(height: 8),
                        _buildRadioOption('point_to_someone', 'I can point you to someone', isDark),
                        const SizedBox(height: 8),
                        _buildRadioOption('not_now', 'Not now', isDark),
                        const SizedBox(height: 14),
                        Text(
                          'A short note',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: titleColor),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          child: TextField(
                            controller: _noteController,
                            maxLines: 3,
                            onChanged: (_) => setState(() {}),
                            style: TextStyle(fontSize: 13.5, color: titleColor),
                            decoration: const InputDecoration(
                              hintText: 'When you can start, and how',
                              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),
                AskBottomButton(
                  label: 'Send my response',
                  isLoading: isLoading,
                  onPressed: _noteController.text.trim().isNotEmpty
                      ? _onSubmit
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
