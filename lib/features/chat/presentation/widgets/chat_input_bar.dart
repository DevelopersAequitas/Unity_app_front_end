import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import 'chat_attachment_picker_sheet.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final Function(String filePath, String fileType)? onSendAttachment;
  final ValueChanged<String>? onChanged;
  final bool isSending;
  final String hintText;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.onSendAttachment,
    this.onChanged,
    this.isSending = false,
    this.hintText = 'Type a message...',
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _timer;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.trim().isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) {
      setState(() => _hasText = has);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _recordSeconds++);
      }
    });
  }

  void _stopRecording({required bool send}) {
    _timer?.cancel();
    if (send && _recordSeconds >= 1 && widget.onSendAttachment != null) {
      widget.onSendAttachment!('voice_note_$_recordSeconds.m4a', 'audio');
    }
    setState(() {
      _isRecording = false;
      _recordSeconds = 0;
    });
  }

  String _formatDuration(int sec) {
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _openAttachmentPicker() async {
    final result = await ChatAttachmentPickerSheet.show(context);
    if (result != null && mounted) {
      if (result['action'] == 'voice_record') {
        _startRecording();
      } else if (result['path'] != null && widget.onSendAttachment != null) {
        widget.onSendAttachment!(
          result['path']!,
          result['type'] ?? 'image',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _isRecording
            ? _buildRecordingBar(isDark)
            : _buildInputRow(isDark),
      ),
    );
  }

  Widget _buildRecordingBar(bool isDark) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: AppColor.error),
          onPressed: () => _stopRecording(send: false),
          tooltip: 'Cancel recording',
        ),
        const SizedBox(width: 8),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColor.error,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatDuration(_recordSeconds),
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.error,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Recording voice note...',
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            gradient: AppColor.brandGradient,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            onPressed: () => _stopRecording(send: true),
            tooltip: 'Send voice note',
          ),
        ),
      ],
    );
  }

  Widget _buildInputRow(bool isDark) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline_rounded, size: 24),
          color: isDark
              ? AppColor.darkTextSecondary
              : AppColor.lightTextSecondary,
          onPressed: _openAttachmentPicker,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 100),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColor.darkSurfaceSubtle
                  : AppColor.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: TextField(
              controller: widget.controller,
              onChanged: widget.onChanged,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: AppTypography.bodyLarge.copyWith(
                color: isDark
                    ? AppColor.darkTextPrimary
                    : AppColor.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.bodyLarge.copyWith(
                  color: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.lightTextSecondary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            gradient: AppColor.brandGradient,
            shape: BoxShape.circle,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.isSending
                  ? null
                  : (_hasText ? widget.onSend : _startRecording),
              child: Center(
                child: widget.isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        _hasText ? Icons.send_rounded : Icons.mic_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
