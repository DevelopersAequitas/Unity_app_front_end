import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/constants/app_colors.dart';
import 'package:unity_app/core/widgets/common_peer_selector_sheet.dart';
import 'package:unity_app/features/p2p_meetings/domain/usecases/send_p2p_meeting_request_usecase.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/schedule_p2p_meeting_bloc.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/schedule_p2p_meeting_event.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/schedule_p2p_meeting_state.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/common/p2p_meeting_location_field.dart';

import 'package:unity_app/core/utils/app_date_formatter.dart';

class ScheduleP2pMeetingSheet extends StatefulWidget {
  final VoidCallback onSuccess;

  const ScheduleP2pMeetingSheet({super.key, required this.onSuccess});

  static Future<void> show(BuildContext context, {required VoidCallback onSuccess}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider(
        create: (c) => ScheduleP2pMeetingBloc(
          sendP2pMeetingRequestUseCase: c.read<SendP2pMeetingRequestUseCase>(),
        ),
        child: ScheduleP2pMeetingSheet(onSuccess: onSuccess),
      ),
    );
  }

  @override
  State<ScheduleP2pMeetingSheet> createState() => _ScheduleP2pMeetingSheetState();
}

class _ScheduleP2pMeetingSheetState extends State<ScheduleP2pMeetingSheet> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _placeCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  @override
  void dispose() {
    _placeCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPeer() async {
    final peer = await CommonPeerSelectorSheet.show(
      context,
      title: 'Select Peer to Schedule',
    );
    if (peer != null && mounted) {
      context.read<ScheduleP2pMeetingBloc>().add(ScheduleP2pMeetingPeerSelected(peer));
    }
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 11, minute: 0),
    );
    if (t == null || !mounted) return;
    setState(() {
      _selectedDate = d;
      _selectedTime = t;
    });
    final localDateTime = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    final utcFormatted = AppDateFormatter.toUtcString(localDateTime);
    context.read<ScheduleP2pMeetingBloc>().add(ScheduleP2pMeetingDateTimeChanged(utcFormatted));
  }

  String _formatDisplayDateTime() {
    if (_selectedDate == null || _selectedTime == null) return '';
    final localDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
    return AppDateFormatter.formatDateTime(localDateTime);
  }

  void _submit() {
    final bloc = context.read<ScheduleP2pMeetingBloc>();
    if (bloc.state.selectedPeer == null) {
      _showError('Please select a peer member');
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      _showError('Please select meeting date & time');
      return;
    }
    if (_placeCtrl.text.trim().isEmpty) {
      _showError('Please enter a meeting place');
      return;
    }

    bloc.add(ScheduleP2pMeetingPlaceChanged(_placeCtrl.text.trim()));
    bloc.add(ScheduleP2pMeetingMessageChanged(_messageCtrl.text.trim()));
    bloc.add(const ScheduleP2pMeetingSubmitted());
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleP2pMeetingBloc, ScheduleP2pMeetingState>(
      listener: (context, state) {
        if (state.status == ScheduleP2pMeetingStatus.success) {
          Navigator.pop(context);
          widget.onSuccess();
        } else if (state.status == ScheduleP2pMeetingStatus.failure && state.errorMessage != null) {
          _showError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ScheduleP2pMeetingStatus.submitting;
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Schedule P2P Meeting',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _PickerTile(
                  icon: Icons.person_outline,
                  label: state.selectedPeer?.displayName ?? 'Select Peer Member',
                  isSelected: state.selectedPeer != null,
                  onTap: _pickPeer,
                ),
                const SizedBox(height: 12),
                _PickerTile(
                  icon: Icons.calendar_today_outlined,
                  label: _selectedDate == null ? 'Select Date & Time' : _formatDisplayDateTime(),
                  isSelected: _selectedDate != null,
                  onTap: _pickDateTime,
                ),
                const SizedBox(height: 14),
                P2pMeetingLocationField(
                  controller: _placeCtrl,
                  initialType: 'In-Person',
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _messageCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Invitation Message (optional)',
                    prefixIcon: const Icon(Icons.message_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Send Invitation',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderLight),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
