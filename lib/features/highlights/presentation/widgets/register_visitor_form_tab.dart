import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/register_visitor/register_visitor_state.dart';
import 'register_visitor_form_fields.dart';

class RegisterVisitorFormTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController eventNameController;
  final TextEditingController visitorFullNameController;
  final TextEditingController visitorMobileController;
  final TextEditingController visitorEmailController;
  final TextEditingController visitorCityController;
  final TextEditingController visitorBusinessController;
  final TextEditingController noteController;
  final String eventType;
  final ValueChanged<String> onEventTypeChanged;
  final DateTime? eventDate;
  final VoidCallback onPickDate;
  final VoidCallback onPickEvent;
  final VoidCallback onPickCity;
  final String howKnown;
  final ValueChanged<String> onHowKnownChanged;
  final VoidCallback? onPickContact;
  final RegisterVisitorState state;
  final VoidCallback onSubmit;

  const RegisterVisitorFormTab({
    super.key,
    required this.formKey,
    required this.eventNameController,
    required this.visitorFullNameController,
    required this.visitorMobileController,
    required this.visitorEmailController,
    required this.visitorCityController,
    required this.visitorBusinessController,
    required this.noteController,
    required this.eventType,
    required this.onEventTypeChanged,
    required this.eventDate,
    required this.onPickDate,
    required this.onPickEvent,
    required this.onPickCity,
    required this.howKnown,
    required this.onHowKnownChanged,
    this.onPickContact,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitting = state.status == RegisterVisitorStatus.submitting;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RegisterVisitorFormFields(
              eventNameController: eventNameController,
              visitorFullNameController: visitorFullNameController,
              visitorMobileController: visitorMobileController,
              visitorEmailController: visitorEmailController,
              visitorCityController: visitorCityController,
              visitorBusinessController: visitorBusinessController,
              noteController: noteController,
              eventType: eventType,
              onEventTypeChanged: onEventTypeChanged,
              eventDate: eventDate,
              onPickDate: onPickDate,
              onPickEvent: onPickEvent,
              onPickCity: onPickCity,
              howKnown: howKnown,
              onHowKnownChanged: onHowKnownChanged,
              onPickContact: onPickContact,
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: isSubmitting ? null : onSubmit,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  gradient: AppColor.brandGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'Register Visitor',
                        style: AppTypography.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
