import 'package:flutter/material.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import 'ask_match_fit_section.dart';
import 'ask_match_peer_header.dart';

class AskMatchPeerCard extends StatelessWidget {
  final AskMatchPeerEntity peer;
  final VoidCallback onStartConversation;

  const AskMatchPeerCard({
    super.key,
    required this.peer,
    required this.onStartConversation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AskMatchPeerHeader(peer: peer.peer),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          AskMatchFitSection(peer: peer),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: onStartConversation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F2438),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Start conversation',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

