import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';
import 'package:unity_app/core/widgets/location_picker_sheet.dart';

class P2pMeetingLocationField extends StatefulWidget {
  final TextEditingController controller;
  final String initialType;
  final ValueChanged<String>? onTypeChanged;

  const P2pMeetingLocationField({
    super.key,
    required this.controller,
    this.initialType = 'In-Person',
    this.onTypeChanged,
  });

  @override
  State<P2pMeetingLocationField> createState() => _P2pMeetingLocationFieldState();
}

class _P2pMeetingLocationFieldState extends State<P2pMeetingLocationField> {
  late String _meetingType;
  String? _selectedPlatform;

  @override
  void initState() {
    super.initState();
    _meetingType = widget.initialType;
    final lower = widget.controller.text.toLowerCase();
    if (lower.contains('meet') ||
        lower.contains('zoom') ||
        lower.contains('teams') ||
        lower.contains('http') ||
        lower.contains('whatsapp')) {
      _meetingType = 'Virtual';
    }
  }

  Future<void> _openMapPicker() async {
    final result = await LocationPickerSheet.show(
      context,
      initialAddress: widget.controller.text.trim().isNotEmpty
          ? widget.controller.text.trim()
          : null,
    );

    if (result != null && mounted) {
      setState(() {
        widget.controller.text = result.address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Meeting Mode Switcher ──
        Text(
          'Meeting Mode',
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 12.5,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(3.5),
          decoration: BoxDecoration(
            color: AppColor.lightBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.lightBorder, width: 0.9),
          ),
          child: Row(
            children: [
              // In-Person Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_meetingType != 'In-Person') {
                      setState(() {
                        _meetingType = 'In-Person';
                        _selectedPlatform = null;
                        widget.controller.clear();
                      });
                      widget.onTypeChanged?.call('In-Person');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _meetingType == 'In-Person'
                          ? AppColor.primaryBlue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: _meetingType == 'In-Person'
                              ? Colors.white
                              : AppColor.lightTextSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'In-Person',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _meetingType == 'In-Person'
                                ? Colors.white
                                : AppColor.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Virtual Tab
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (_meetingType != 'Virtual') {
                      setState(() {
                        _meetingType = 'Virtual';
                        _selectedPlatform = 'Google Meet';
                        // Keep controller empty or clear if it was an in-person place
                        if (!widget.controller.text.startsWith('http')) {
                          widget.controller.clear();
                        }
                      });
                      widget.onTypeChanged?.call('Virtual');
                    } 
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _meetingType == 'Virtual'
                          ? AppColor.primaryBlue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_outlined,
                          size: 15,
                          color: _meetingType == 'Virtual'
                              ? Colors.white
                              : AppColor.lightTextSecondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Virtual / Online',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _meetingType == 'Virtual'
                                ? Colors.white
                                : AppColor.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── 2. Content for Virtual Mode ──
        if (_meetingType == 'Virtual') ...[
          Text(
            'Virtual Platform / Link',
            style: AppTypography.labelSmall.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 12.5,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildVirtualChip('Google Meet', Icons.video_call_outlined),
                const SizedBox(width: 8),
                _buildVirtualChip('Zoom Meeting', Icons.videocam_outlined),
                const SizedBox(width: 8),
                _buildVirtualChip('MS Teams', Icons.groups_outlined),
                const SizedBox(width: 8),
                _buildVirtualChip('WhatsApp Call', Icons.call_outlined),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: widget.controller,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13,
              color: AppColor.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: _selectedPlatform != null
                  ? 'Enter ${_selectedPlatform!} link (e.g. https://...)'
                  : 'Select platform above or paste meeting link...',
              hintStyle: AppTypography.bodySmall.copyWith(
                fontSize: 12.5,
                color: AppColor.lightTextTertiary,
              ),
              prefixIcon: const Icon(
                Icons.link_rounded,
                size: 19,
                color: AppColor.primaryBlue,
              ),
              filled: true,
              fillColor: AppColor.lightSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColor.lightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColor.lightBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColor.primaryBlue),
              ),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                if (_selectedPlatform != null) {
                  return 'Please enter ${_selectedPlatform!} meeting link';
                }
                return 'Please enter meeting platform or link';
              }
              return null;
            },
          ),
        ],

        // ── 3. Content for In-Person Mode ──
        if (_meetingType == 'In-Person') ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meeting Place / Venue',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              GestureDetector(
                onTap: _openMapPicker,
                child: Row(
                  children: const [
                    Icon(Icons.map_outlined, size: 14, color: AppColor.primaryBlue),
                    SizedBox(width: 4),
                    Text(
                      'Pick on Map',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13,
              color: AppColor.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Type cafe/place name or pick on Map...',
              hintStyle: AppTypography.bodySmall.copyWith(
                fontSize: 12.5,
                color: AppColor.lightTextTertiary,
              ),
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                size: 19,
                color: AppColor.primaryBlue,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.map_outlined, size: 19, color: AppColor.primaryBlue),
                onPressed: _openMapPicker,
                tooltip: 'Select on Map',
              ),
              filled: true,
              fillColor: AppColor.lightSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColor.lightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColor.lightBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColor.primaryBlue),
              ),
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Please enter meeting place' : null,
          ),
        ],
      ],
    );
  }

  Widget _buildVirtualChip(String label, IconData icon) {
    final isSelected = _selectedPlatform == label ||
        (widget.controller.text.toLowerCase().contains(label.toLowerCase().split(' ').first));
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPlatform = label;
          // If controller previously had just a chip name, clear it
          if (widget.controller.text == 'Google Meet' ||
              widget.controller.text == 'Zoom Meeting' ||
              widget.controller.text == 'MS Teams' ||
              widget.controller.text == 'WhatsApp Call') {
            widget.controller.clear();
          }
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6.5),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryBlue : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColor.primaryBlue : AppColor.lightBorder,
            width: 0.9,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : AppColor.primaryBlue,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColor.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
