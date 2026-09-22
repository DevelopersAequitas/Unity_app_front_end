import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/timeline_mention_entity.dart';

/// A rich text widget that renders timeline post descriptions with:
/// 1. Mentioned peer names in UPPERCASE.
/// 2. Brand gradient styling for peer mentions.
/// 3. Clickable interaction to open the mentioned peer's profile.
/// 4. Integrated Read more / Read less collapsible text expansion.
class MentionTextView extends StatefulWidget {
  final String text;
  final List<TimelineMentionEntity> mentions;
  final TextStyle? style;
  final int maxLines;
  final bool expandable;
  final void Function(String peerId)? onMentionTap;

  const MentionTextView({
    super.key,
    required this.text,
    this.mentions = const [],
    this.style,
    this.maxLines = 3,
    this.expandable = true,
    this.onMentionTap,
  });

  @override
  State<MentionTextView> createState() => _MentionTextViewState();
}

class _MentionTextViewState extends State<MentionTextView> {
  bool _isExpanded = false;

  void _handlePeerTap(String peerId) {
    if (peerId.trim().isEmpty) return;
    if (widget.onMentionTap != null) {
      widget.onMentionTap!(peerId);
    } else {
      Navigator.pushNamed(context, AppRoutes.peerProfile, arguments: peerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawText = widget.text.trim();
    if (rawText.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultStyle = widget.style ??
        TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w400,
          height: 1.45,
          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
        );

    final isLong = rawText.length > 160;
    final spans = _buildSpans(rawText, defaultStyle);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(children: spans),
          maxLines: (!_isExpanded && widget.expandable) ? widget.maxLines : null,
          overflow: (!_isExpanded && widget.expandable) ? TextOverflow.ellipsis : TextOverflow.visible,
        ),
        if (isLong && widget.expandable)
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _isExpanded ? 'Read less' : 'Read more',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<InlineSpan> _buildSpans(String text, TextStyle baseStyle) {
    final List<InlineSpan> spans = [];

    // Comprehensive regex that matches:
    // 1) Markdown mention: @[Display Name](peerId) or @[Display Name](id:123)
    // 2) Tagged mention: @{peerId:Display Name} or @[peerId:Display Name]
    // 3) Plain mention: @[Word] or @(\w+)
    final pattern = RegExp(
      r'@\[([^\]]+)\]\(([^)]+)\)|@\{([^:]+):([^}]+)\}|@\[([^:]+):([^\]]+)\]|@([a-zA-Z0-9_\.\-]+(?:\s+[a-zA-Z0-9_\.\-]+)?)',
      multiLine: true,
    );

    int lastIndex = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }

      String mentionName = '';
      String peerId = '';

      if (match.group(1) != null && match.group(2) != null) {
        // @[Display Name](peerId)
        mentionName = match.group(1)!;
        peerId = match.group(2)!.replaceAll('id:', '').trim();
      } else if (match.group(3) != null && match.group(4) != null) {
        // @{peerId:Display Name}
        peerId = match.group(3)!.trim();
        mentionName = match.group(4)!;
      } else if (match.group(5) != null && match.group(6) != null) {
        // @[peerId:Display Name]
        peerId = match.group(5)!.trim();
        mentionName = match.group(6)!;
      } else if (match.group(7) != null) {
        // Plain mention: @Name
        mentionName = match.group(7)!;
        // Search in mentions list
        final matchedMention = widget.mentions.where((m) =>
            m.name.toLowerCase() == mentionName.toLowerCase() ||
            m.username?.toLowerCase() == mentionName.toLowerCase()).firstOrNull;
        if (matchedMention != null) {
          peerId = matchedMention.id;
          mentionName = matchedMention.name;
        }
      }

      if (mentionName.isNotEmpty) {
        // Format in UPPERCASE
        final upperName = mentionName.toUpperCase();
        final displayText = upperName.startsWith('@') ? upperName : '@$upperName';

        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => _handlePeerTap(peerId),
              behavior: HitTestBehavior.opaque,
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => AppColor.brandGradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  displayText,
                  style: baseStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // Required for ShaderMask
                  ),
                ),
              ),
            ),
          ),
        );
      }

      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: baseStyle,
      ));
    }

    return spans;
  }
}
