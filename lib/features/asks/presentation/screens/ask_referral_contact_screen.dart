import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/contact_picker_sheet.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../bloc/ask_response/ask_response_bloc.dart';
import '../bloc/ask_response/ask_response_event.dart';
import '../bloc/ask_response/ask_response_state.dart';
import '../widgets/ask_bottom_button.dart';
import '../widgets/ask_step_header.dart';
import '../widgets/ask_text_input_group.dart';

class AskReferralContactScreen extends StatefulWidget {
  final String askId;
  final AskMatchPeerEntity peer;
  final AskSubmissionEntity submission;

  const AskReferralContactScreen({
    super.key,
    required this.askId,
    required this.peer,
    required this.submission,
  });

  @override
  State<AskReferralContactScreen> createState() =>
      _AskReferralContactScreenState();
}

class _AskReferralContactScreenState extends State<AskReferralContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _noteController.text.trim().isNotEmpty;
  }

  Future<void> _pickFromContacts() async {
    final result = await ContactPickerSheet.pickContact(context);
    if (result != null) {
      setState(() {
        if (result.name.isNotEmpty) {
          _nameController.text = result.name;
        }
        if (result.phone.isNotEmpty) {
          _phoneController.text = result.phone;
        }
        if (result.email != null && result.email!.isNotEmpty) {
          _emailController.text = result.email!;
        }
      });
    }
  }

  void _onSubmit() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final note = _noteController.text.trim();

    context.read<AskResponseBloc>().add(
          AskResponseSubmitRequested(
            askId: widget.askId,
            responseType: 'know_someone',
            message: note,
            timeline: 'immediate',
            extraData: {
              'contact': {
                'full_name': name,
                'phone': phone,
                if (email.isNotEmpty) 'email': email,
                'note': note,
              },
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    final askGoal = widget.submission.effectiveGoal.isNotEmpty
        ? widget.submission.effectiveGoal
        : (widget.submission.goal.isNotEmpty
            ? widget.submission.goal
            : 'Collaboration Ask');

    return BlocConsumer<AskResponseBloc, AskResponseState>(
      listener: (context, state) {
        if (state.status == AskResponseStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Referral submitted successfully! Thank you.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColor.primaryBlue,
              duration: const Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop();
        } else if (state.status == AskResponseStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Failed to submit referral. Please try again.',
              ),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AskResponseStatus.loading;

        return Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          appBar: const AppCommonBar(
            title: 'I Know Someone',
            showBack: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const AskStepHeader(
                  title: 'Refer an External Contact',
                  subtitle: 'Share someone from your network who can help',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Target Ask Summary Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColor.badgeBlueBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  widget.submission.type.name.isNotEmpty
                                      ? widget.submission.type.name
                                      : 'Ask Referral',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.primaryBlue,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                askGoal,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Pick From Contacts Button
                        InkWell(
                          onTap: _pickFromContacts,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColor.darkSurfaceSubtle
                                  : AppColor.badgeBlueBg.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColor.primaryBlue.withValues(alpha: 0.35),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: AppColor.brandGradient,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.contacts_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pick from Contacts',
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? Colors.white
                                              : AppColor.primaryBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Auto-fill details from your phone book',
                                        style:
                                            AppTypography.bodySmall.copyWith(
                                          fontSize: 11.5,
                                          color: isDark
                                              ? const Color(0xFF94A3B8)
                                              : const Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: AppColor.primaryBlue,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Form Fields
                        AskTextInputGroup(
                          label: 'Full Name',
                          hintText: 'e.g. Ramesh Kumar',
                          controller: _nameController,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),
                        AskTextInputGroup(
                          label: 'Phone Number',
                          hintText: 'e.g. +91 98765 43210',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),
                        AskTextInputGroup(
                          label: 'Email Address (Optional)',
                          hintText: 'e.g. ramesh@example.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),
                        AskTextInputGroup(
                          label: 'Why are they a great match? (Note)',
                          hintText: 'Briefly describe how they can assist with this ask',
                          controller: _noteController,
                          maxLines: 3,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                AskBottomButton(
                  label: 'Submit Referral',
                  isLoading: isLoading,
                  onPressed: _canSubmit ? _onSubmit : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
