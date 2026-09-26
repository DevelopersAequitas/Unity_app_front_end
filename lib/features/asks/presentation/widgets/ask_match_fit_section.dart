import 'package:flutter/material.dart';
import '../../domain/entities/ask_match_peer_entity.dart';

class AskMatchFitSection extends StatelessWidget {
  final AskMatchPeerEntity peer;

  const AskMatchFitSection({super.key, required this.peer});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
              decoration: BoxDecoration(
                color: const Color(0xFF0E7A68).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${peer.matchScore}% Match',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0E7A68),
                ),
              ),
            ),
            if (peer.matchReason.isNotEmpty)
              Flexible(
                child: Text(
                  peer.matchReason,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: subColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
        if (peer.matchesMap.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: peer.matchesMap.entries.map((entry) {
              final isMatched = entry.value == 'match' || entry.value == true;
              final keyName = entry.key[0].toUpperCase() + entry.key.substring(1);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isMatched
                      ? const Color(0xFF0E7A68).withValues(alpha: 0.08)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$keyName: ${isMatched ? "Matches" : "Partial"}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isMatched ? const Color(0xFF0E7A68) : subColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
