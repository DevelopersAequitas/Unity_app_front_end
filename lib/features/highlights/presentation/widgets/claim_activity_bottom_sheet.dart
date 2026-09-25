import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/claim_activity_entity.dart';

class ClaimActivityBottomSheet extends StatefulWidget {
  final ClaimActivityEntity activity;

  const ClaimActivityBottomSheet({super.key, required this.activity});

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required ClaimActivityEntity activity,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClaimActivityBottomSheet(activity: activity),
    );
  }

  @override
  State<ClaimActivityBottomSheet> createState() =>
      _ClaimActivityBottomSheetState();
}

class _ClaimActivityBottomSheetState extends State<ClaimActivityBottomSheet> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, DateTime> _dates = {};
  final Map<String, String> _errors = {};
  File? _attachedFile;
  bool _isVideoFile = false;
  bool _isProcessingVideo = false;
  String? _videoProcessingStatus;

  bool get _isVideoActivity {
    final code = widget.activity.code.toLowerCase();
    final label = widget.activity.label.toLowerCase();
    return code.contains('video') ||
        code.contains('feedback') ||
        label.contains('video') ||
        label.contains('feedback') ||
        widget.activity.fields.any((f) => f.type == 'video' || f.key.contains('video'));
  }

  @override
  void initState() {
    super.initState();
    for (final field in widget.activity.fields) {
      if (field.type == 'date') {
        _dates[field.key] = DateTime.now();
      } else if (field.type != 'file' && field.type != 'video') {
        _controllers[field.key] = TextEditingController();
      }
    }
    if (_isVideoActivity && !_controllers.containsKey('video_link')) {
      _controllers['video_link'] = TextEditingController();
    }
    if (_controllers.isEmpty && _dates.isEmpty && widget.activity.fields.isEmpty) {
      _controllers['description'] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (_isProcessingVideo) return;

    final fields = <String, dynamic>{};
    _controllers.forEach((k, v) {
      if (v.text.trim().isNotEmpty) {
        fields[k] = v.text.trim();
      }
    });
    _dates.forEach((k, v) => fields[k] = _formatIsoDate(v));

    final newErrors = <String, String>{};

    // ── Field Inline Validation ──
    if (widget.activity.fields.isEmpty) {
      final desc = _controllers['description']?.text.trim() ?? '';
      if (desc.isEmpty) {
        newErrors['description'] = 'Description / Remarks is required.';
      }
    } else {
      for (final field in widget.activity.fields) {
        if (!field.required) continue;
        if (field.type == 'date') {
          if (_dates[field.key] == null) {
            newErrors[field.key] = '${field.label} is required.';
          }
        } else if (field.type == 'file' ||
            field.type == 'video' ||
            field.key.contains('proof') ||
            field.key.contains('file')) {
          final hasFile = _attachedFile != null;
          final hasLink = _controllers['video_link']?.text.trim().isNotEmpty == true ||
              _controllers[field.key]?.text.trim().isNotEmpty == true;
          if (!hasFile && !hasLink) {
            newErrors[field.key] = _isVideoActivity
                ? 'Please attach a feedback video (max 60s) or provide a video link.'
                : '${field.label} is required.';
          }
        } else {
          final val = _controllers[field.key]?.text.trim() ?? '';
          if (val.isEmpty) {
            newErrors[field.key] = '${field.label} is required.';
          }
        }
      }
    }

    if (_isVideoActivity) {
      final hasFile = _attachedFile != null;
      final hasLink = _controllers['video_link']?.text.trim().isNotEmpty == true;
      if (!hasFile && !hasLink) {
        newErrors['video_attachment'] = 'Please attach a feedback video (max 60s) or provide a video link.';
      }
    }

    if (newErrors.isNotEmpty) {
      setState(() {
        _errors.clear();
        _errors.addAll(newErrors);
      });
      return;
    }

    Navigator.of(context).pop({
      'activity_code': widget.activity.code,
      'fields': fields,
      'proof_file': _attachedFile,
    });
  }

  String _formatIsoDate(DateTime d) => AppDateFormatter.toUtcDateString(d);

  String _formatDisplayDate(DateTime d) => AppDateFormatter.format(d);

  Future<void> _pickMedia({required bool isVideo, bool fromCamera = false}) async {
    final picker = ImagePicker();
    try {
      if (isVideo) {
        final picked = await picker.pickVideo(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        );
        if (picked != null) {
          await _processAndTrimVideo(File(picked.path));
        }
      } else {
        final picked = await picker.pickImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 85,
        );
        if (picked != null && mounted) {
          setState(() {
            _attachedFile = File(picked.path);
            _isVideoFile = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.showError(context, 'Unable to pick file. Please try again.');
      }
    }
  }

  Future<void> _processAndTrimVideo(File rawVideo) async {
    setState(() {
      _isProcessingVideo = true;
      _videoProcessingStatus = 'Analyzing video duration...';
    });

    try {
      final mediaInfo = await VideoCompress.getMediaInfo(rawVideo.path);
      final rawDurationMs = mediaInfo.duration ?? 0;
      final totalSeconds = (rawDurationMs / 1000).round();

      if (!mounted) return;

      int startSecond = 0;
      if (totalSeconds > 60) {
        setState(() => _isProcessingVideo = false);
        final selectedStart = await _showVideoTrimDialog(totalSeconds);
        if (selectedStart == null) return;
        startSecond = selectedStart;
      }

      if (!mounted) return;

      setState(() {
        _isProcessingVideo = true;
        _videoProcessingStatus = 'Compressing video (optimized for upload)...';
      });

      final info = await VideoCompress.compressVideo(
        rawVideo.path,
        quality: VideoQuality.MediumQuality,
        startTime: startSecond > 0 ? startSecond : null,
        duration: (totalSeconds > 60 || startSecond > 0) ? 60 : null,
        deleteOrigin: false,
        includeAudio: true,
      );

      if (info != null && info.file != null && mounted) {
        setState(() {
          _attachedFile = info.file;
          _isVideoFile = true;
          _isProcessingVideo = false;
        });
        AppSnackBar.showSuccess(
          context,
          'Feedback video processed successfully (${(totalSeconds > 60) ? "60s portion" : "$totalSeconds s"}).',
        );
      } else if (mounted) {
        setState(() {
          _attachedFile = rawVideo;
          _isVideoFile = true;
          _isProcessingVideo = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _attachedFile = rawVideo;
          _isVideoFile = true;
          _isProcessingVideo = false;
        });
      }
    }
  }

  Future<int?> _showVideoTrimDialog(int totalSeconds) {
    int currentStart = 0;
    final maxStart = (totalSeconds - 60).clamp(0, totalSeconds);

    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final endSecond = (currentStart + 60).clamp(0, totalSeconds);
          return AlertDialog(
            backgroundColor: AppColor.lightSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.cut_rounded, color: AppColor.primaryBlue, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('Trim Video to 60s', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your video is $totalSeconds seconds long. The maximum allowed limit is 60 seconds. Choose which portion to upload:',
                  style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColor.lightBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.lightBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Selected Range:', style: AppTypography.labelSmall),
                      Text(
                        '${currentStart}s — ${endSecond}s (60 sec)',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColor.primaryBlue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (maxStart > 0) ...[
                  Slider(
                    value: currentStart.toDouble(),
                    min: 0,
                    max: maxStart.toDouble(),
                    divisions: maxStart,
                    activeColor: AppColor.primaryBlue,
                    label: '${currentStart}s',
                    onChanged: (v) {
                      setDialogState(() => currentStart = v.round());
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Start (0s)', style: TextStyle(fontSize: 11, color: AppColor.lightTextTertiary)),
                      Text('End (${totalSeconds}s)', style: const TextStyle(fontSize: 11, color: AppColor.lightTextTertiary)),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, currentStart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Trim & Compress'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMediaPickerSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColor.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isVideoActivity) ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.videocam_rounded, color: AppColor.primaryBlue, size: 22),
                  ),
                  title: const Text('Choose Video from Gallery (Max 60s)', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Select a recorded video to compress & upload'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickMedia(isVideo: true, fromCamera: false);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.camera_rounded, color: Color(0xFF10B981), size: 22),
                  ),
                  title: const Text('Record Video with Camera', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Record a new video on your camera'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickMedia(isVideo: true, fromCamera: true);
                  },
                ),
              ] else ...[
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image_rounded, color: AppColor.primaryBlue, size: 22),
                  ),
                  title: const Text('Choose Photo / Document', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Select an image or payment receipt from gallery'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickMedia(isVideo: false, fromCamera: false);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF10B981), size: 22),
                  ),
                  title: const Text('Take Photo with Camera', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Capture a picture of receipt / proof'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickMedia(isVideo: false, fromCamera: true);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.activity.label,
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            if (widget.activity.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                widget.activity.description,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (widget.activity.fields.isEmpty) ...[
              Text('Description / Remarks', style: AppTypography.labelSmall),
              const SizedBox(height: 4),
              _buildTextField(
                controller: _controllers['description']!,
                hintText: 'Enter details of your activity...',
                isDark: isDark,
                fieldKey: 'description',
                errorText: _errors['description'],
              ),
            ] else
              ...widget.activity.fields.map((field) {
                final isFileField = field.type == 'file' ||
                    field.type == 'video' ||
                    field.key.contains('proof') ||
                    field.key.contains('file');
                final errorText = _errors[field.key] ??
                    (isFileField ? _errors['video_attachment'] : null);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(field.label, style: AppTypography.labelSmall),
                          if (field.required)
                            const Text(' *', style: TextStyle(color: AppColor.error, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (field.type == 'date')
                        _buildDatePicker(
                          currentDate: _dates[field.key] ?? DateTime.now(),
                          isDark: isDark,
                          fieldKey: field.key,
                          errorText: errorText,
                          onDateSelected: (d) => setState(() {
                            _dates[field.key] = d;
                            _errors.remove(field.key);
                          }),
                        )
                      else if (isFileField)
                        _buildFilePicker(
                          isDark: isDark,
                          fieldKey: field.key,
                          errorText: errorText,
                        )
                      else
                        _buildTextField(
                          controller: _controllers.putIfAbsent(
                            field.key,
                            () => TextEditingController(),
                          ),
                          hintText: field.placeholder ?? 'Enter ${field.label.toLowerCase()}',
                          isDark: isDark,
                          fieldKey: field.key,
                          errorText: errorText,
                          keyboardType: field.type == 'url'
                              ? TextInputType.url
                              : (field.type == 'phone' || field.key.contains('mobile')
                                  ? TextInputType.phone
                                  : (field.type == 'email' || field.key.contains('email')
                                      ? TextInputType.emailAddress
                                      : TextInputType.text)),
                        ),
                    ],
                  ),
                );
              }),
            if (_isVideoActivity) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('Video Link / URL (Optional if file attached)', style: AppTypography.labelSmall),
                ],
              ),
              const SizedBox(height: 4),
              _buildTextField(
                controller: _controllers['video_link'] ??= TextEditingController(),
                hintText: 'e.g. https://youtube.com/watch?v=... or Drive link',
                isDark: isDark,
                fieldKey: 'video_link',
                errorText: _errors['video_link'],
                keyboardType: TextInputType.url,
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _isProcessingVideo ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isProcessingVideo ? AppColor.primaryBlue.withValues(alpha: 0.6) : AppColor.primaryBlue,
                  disabledBackgroundColor: AppColor.primaryBlue.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isProcessingVideo
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Compressing & Uploading Video...',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ],
                      )
                    : const Text(
                        'Submit Claim Request',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    required String fieldKey,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError
                  ? AppColor.error
                  : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
              width: hasError ? 1.2 : 1.0,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTypography.bodyMedium,
            onChanged: (val) {
              if (_errors.containsKey(fieldKey)) {
                setState(() => _errors.remove(fieldKey));
              }
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        if (hasError) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, size: 12, color: AppColor.error),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: const TextStyle(color: AppColor.error, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDatePicker({
    required DateTime currentDate,
    required bool isDark,
    required String fieldKey,
    String? errorText,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    final displayDate = _formatDisplayDate(currentDate);
    final hasError = errorText != null && errorText.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: currentDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) onDateSelected(picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasError
                    ? AppColor.error
                    : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                width: hasError ? 1.2 : 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(displayDate, style: AppTypography.bodyMedium),
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColor.primaryBlue),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, size: 12, color: AppColor.error),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: const TextStyle(color: AppColor.error, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilePicker({
    required bool isDark,
    String? fieldKey,
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;

    if (_isProcessingVideo) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColor.primaryBlue.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _videoProcessingStatus ?? 'Processing video...',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_attachedFile != null) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
        ),
        child: Row(
          children: [
            Icon(
              _isVideoFile ? Icons.videocam_rounded : Icons.check_circle_rounded,
              size: 18,
              color: const Color(0xFF059669),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _attachedFile!.path.split(RegExp(r'[/\\]')).last,
                style: AppTypography.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 16),
              onPressed: () => setState(() {
                _attachedFile = null;
                _isVideoFile = false;
              }),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            _showMediaPickerSheet();
            if (fieldKey != null && _errors.containsKey(fieldKey)) {
              setState(() => _errors.remove(fieldKey));
            }
            if (_errors.containsKey('video_attachment')) {
              setState(() => _errors.remove('video_attachment'));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasError
                    ? AppColor.error
                    : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                width: hasError ? 1.2 : 1.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isVideoActivity ? Icons.video_library_rounded : Icons.attach_file_rounded,
                  size: 16,
                  color: hasError ? AppColor.error : AppColor.primaryBlue,
                ),
                const SizedBox(width: 6),
                Text(
                  _isVideoActivity
                      ? 'Attach Video or Proof File'
                      : 'Attach Proof File / Receipt',
                  style: AppTypography.bodySmall.copyWith(
                    color: hasError ? AppColor.error : AppColor.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, size: 12, color: AppColor.error),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorText,
                    style: const TextStyle(color: AppColor.error, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
