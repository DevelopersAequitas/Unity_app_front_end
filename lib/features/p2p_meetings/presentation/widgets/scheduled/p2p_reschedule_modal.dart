import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';
import 'package:unity_app/core/widgets/app_snack_bar.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/reschedule_p2p_meeting_params.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/common/p2p_meeting_location_field.dart';

class P2pRescheduleModal extends StatefulWidget {
  final String requestId;
  final String currentPlace;
  final ValueChanged<RescheduleP2pMeetingParams> onSubmit;

  const P2pRescheduleModal({
    super.key,
    required this.requestId,
    required this.currentPlace,
    required this.onSubmit,
  });

  @override
  State<P2pRescheduleModal> createState() => _P2pRescheduleModalState();
}

class _P2pRescheduleModalState extends State<P2pRescheduleModal> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  late TextEditingController _placeCtrl;
  late TextEditingController _reasonCtrl;

  @override
  void initState() {
    super.initState();
    _placeCtrl = TextEditingController(text: widget.currentPlace);
    _reasonCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _placeCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null || !mounted) return;

    setState(() {
      _selectedDate = date;
      _selectedTime = time;
    });
  }

  String _formatDateTime() {
    if (_selectedDate == null || _selectedTime == null) return '';
    final y = _selectedDate!.year.toString().padLeft(4, '0');
    final m = _selectedDate!.month.toString().padLeft(2, '0');
    final d = _selectedDate!.day.toString().padLeft(2, '0');
    final hh = _selectedTime!.hour.toString().padLeft(2, '0');
    final mm = _selectedTime!.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm:00';
  }

  void _submit() {
    if (_selectedDate == null || _selectedTime == null) {
      AppSnackBar.showError(context, 'Please select a new date and time');
      return;
    }

    widget.onSubmit(RescheduleP2pMeetingParams(
      meetingRequestId: widget.requestId,
      newScheduledAt: _formatDateTime(),
      newPlace: _placeCtrl.text.trim().isEmpty ? null : _placeCtrl.text.trim(),
      reason: _reasonCtrl.text.trim().isEmpty ? null : _reasonCtrl.text.trim(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Propose Reschedule',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.lightBackground,
                    border: Border.all(color: AppColor.lightBorder),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: AppColor.primaryBlue,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate == null
                            ? 'Select New Date & Time'
                            : _formatDateTime(),
                        style: TextStyle(
                          fontSize: 13,
                          color: _selectedDate == null
                              ? AppColor.lightTextTertiary
                              : AppColor.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              P2pMeetingLocationField(
                controller: _placeCtrl,
                initialType: widget.currentPlace.toLowerCase().contains('meet') ||
                        widget.currentPlace.toLowerCase().contains('zoom') ||
                        widget.currentPlace.toLowerCase().contains('http')
                    ? 'Virtual'
                    : 'In-Person',
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _reasonCtrl,
                maxLines: 2,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  labelText: 'Reason for Rescheduling (optional)',
                  prefixIcon: const Icon(Icons.comment_outlined, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Send Reschedule Request',
                    style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
