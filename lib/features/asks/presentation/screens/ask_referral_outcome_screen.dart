import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../../domain/usecases/update_ask_status_usecase.dart';
import '../bloc/my_asks/my_asks_bloc.dart';
import '../bloc/my_asks/my_asks_event.dart';
import '../bloc/peers_feed/peers_feed_bloc.dart';
import '../bloc/peers_feed/peers_feed_event.dart';

class AskReferralOutcomeScreen extends StatefulWidget {
  final AskMatchPeerEntity peer;
  final AskSubmissionEntity submission;

  const AskReferralOutcomeScreen({
    super.key,
    required this.peer,
    required this.submission,
  });

  @override
  State<AskReferralOutcomeScreen> createState() =>
      _AskReferralOutcomeScreenState();
}

class _AskReferralOutcomeScreenState extends State<AskReferralOutcomeScreen> {
  String _outcomeStatus = 'deal_closed';
  String _approxValue = '1_to_10_lakh';
  bool _addToAnonymousTotal = false;
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
          approxValue: _approxValue,
          note: _noteController.text.trim(),
          shareStory: _shareStoryOnFeed,
          anonymousTotal: _addToAnonymousTotal,
        );
      }
    } catch (_) {}

    if (mounted) {
      context.read<MyAsksBloc>().add(const MyAsksFetchRequested(refresh: true));
      context.read<PeersFeedBloc>().add(const PeersFeedFetchRequested(isRefresh: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Referral fulfilled & recorded.'),
          backgroundColor: Color(0xFF0E7A68),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Widget _buildRadioTile(String key, String title, bool isDark) {
    final isSelected = _outcomeStatus == key;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isSelected
        ? const Color(0xFF0E7A68)
        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return InkWell(
      onTap: () => setState(() => _outcomeStatus = key),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1.2),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0E7A68) : const Color(0xFF94A3B8),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF0E7A68) : Colors.transparent,
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.circle, size: 8, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueChip(String key, String label, bool isDark) {
    final isSelected = _approxValue == key;
    return InkWell(
      onTap: () => setState(() => _approxValue = key),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0E7A68)
              : (isDark ? const Color(0xFF1E293B) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0E7A68)
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B)),
          ),
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
        title: 'Outcome',
        showBack: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'How did this end?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: titleColor,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRadioTile('deal_closed', 'Deal closed', isDark),
                    const SizedBox(height: 10),
                    _buildRadioTile('met_no_deal', 'Met, no deal', isDark),
                    const SizedBox(height: 10),
                    _buildRadioTile('contact_did_not_respond', 'Contact did not respond', isDark),
                    const SizedBox(height: 20),
                    Text(
                      'Approximate business value (private, only you see this)',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: titleColor),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildValueChip('under_1_lakh', 'Under ₹1 lakh', isDark),
                        _buildValueChip('1_to_10_lakh', '₹1 to 10 lakh', isDark),
                        _buildValueChip('above_10_lakh', 'Above ₹10 lakh', isDark),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Checkbox(
                          value: _addToAnonymousTotal,
                          onChanged: (v) => setState(() => _addToAnonymousTotal = v ?? false),
                          activeColor: const Color(0xFF0E7A68),
                        ),
                        Expanded(
                          child: Text(
                            'Add to the anonymous Peers Global business-facilitated total',
                            style: TextStyle(fontSize: 13, color: titleColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Thank your Giver',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500, color: titleColor),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor, width: 1.2),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: _noteController,
                        maxLines: 3,
                        style: TextStyle(fontSize: 14, color: titleColor),
                        decoration: const InputDecoration(
                          hintText: 'A line about what this introduction did for you',
                          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Checkbox(
                          value: _shareStoryOnFeed,
                          onChanged: (v) => setState(() => _shareStoryOnFeed = v ?? false),
                          activeColor: const Color(0xFF0E7A68),
                        ),
                        Expanded(
                          child: Text(
                            'Share this as a story on the Feed, tagging my Giver',
                            style: TextStyle(fontSize: 13, color: titleColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onCloseAndThank,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E7A68),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Close and thank my Giver',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
