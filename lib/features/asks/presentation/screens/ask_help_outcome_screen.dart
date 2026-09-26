import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../../domain/usecases/update_ask_status_usecase.dart';
import '../bloc/my_asks/my_asks_bloc.dart';
import '../bloc/my_asks/my_asks_event.dart';
import '../bloc/peers_feed/peers_feed_bloc.dart';
import '../bloc/peers_feed/peers_feed_event.dart';
import '../widgets/ask_bottom_button.dart';
import '../widgets/ask_step_header.dart';

class AskHelpOutcomeScreen extends StatefulWidget {
  final AskMatchPeerEntity peer;
  final AskSubmissionEntity submission;

  const AskHelpOutcomeScreen({
    super.key,
    required this.peer,
    required this.submission,
  });

  @override
  State<AskHelpOutcomeScreen> createState() => _AskHelpOutcomeScreenState();
}

class _AskHelpOutcomeScreenState extends State<AskHelpOutcomeScreen> {
  String _outcomeStatus = 'yes_fully';
  final TextEditingController _noteController = TextEditingController();
  bool _shareStoryOnFeed = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _onCloseAndThank() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    final askId = widget.submission.askId ?? '';
    try {
      if (askId.isNotEmpty) {
        final updateStatusUseCase = context.read<UpdateAskStatusUseCase>();
        await updateStatusUseCase(
          askId: askId,
          status: 'fulfilled',
          outcomeStatus: _outcomeStatus,
          note: _noteController.text.trim(),
          shareStory: _shareStoryOnFeed,
        );
      }
    } catch (_) {}

    if (mounted) {
      context.read<MyAsksBloc>().add(const MyAsksFetchRequested(refresh: true));
      context.read<PeersFeedBloc>().add(const PeersFeedFetchRequested(isRefresh: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thank you! Assistance fulfilled & recorded.'),
          backgroundColor: AppColor.primaryBlue,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Widget _buildRadioTile(String key, String title, bool isDark) {
    final isSelected = _outcomeStatus == key;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isSelected
        ? AppColor.primaryBlue
        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return InkWell(
      onTap: () => setState(() => _outcomeStatus = key),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
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
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
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

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: const AppCommonBar(
        title: 'Help Outcome',
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const AskStepHeader(
              title: 'Did this ask get resolved?',
              subtitle: 'Close the loop — thank the Peer who helped',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRadioTile('yes_fully', 'Yes, fully resolved', isDark),
                    const SizedBox(height: 8),
                    _buildRadioTile('partially', 'Partially resolved', isDark),
                    const SizedBox(height: 8),
                    _buildRadioTile('no_response', 'No response after intro', isDark),
                    const SizedBox(height: 8),
                    _buildRadioTile('withdrawn', 'Withdrawn', isDark),
                    const SizedBox(height: 14),
                    Text(
                      'A short note of thanks',
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
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
                        maxLines: 2,
                        style: TextStyle(fontSize: 13.5, color: titleColor),
                        decoration: const InputDecoration(
                          hintText: 'What they did that helped',
                          hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _shareStoryOnFeed,
                          onChanged: (v) => setState(() => _shareStoryOnFeed = v ?? false),
                          activeColor: AppColor.primaryBlue,
                        ),
                        Expanded(
                          child: Text(
                            'Share a shout-out on the Feed',
                            style: TextStyle(fontSize: 12.5, color: titleColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            AskBottomButton(
              label: 'Close and thank',
              onPressed: _onCloseAndThank,
            ),
          ],
        ),
      ),
    );
  }
}
