import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/common_peer_selector_sheet.dart';
import '../../../../core/widgets/contact_picker_sheet.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../bloc/ask_response/ask_response_bloc.dart';
import '../bloc/ask_response/ask_response_event.dart';
import '../bloc/ask_response/ask_response_state.dart';
import '../widgets/ask_bottom_button.dart';
import '../widgets/ask_step_header.dart';

class AskExpressInterestScreen extends StatefulWidget {
  final AskMatchPeerEntity peer;
  final AskSubmissionEntity submission;
  final String askId;

  const AskExpressInterestScreen({
    super.key,
    required this.peer,
    required this.submission,
    required this.askId,
  });

  @override
  State<AskExpressInterestScreen> createState() =>
      _AskExpressInterestScreenState();
}

class _AskExpressInterestScreenState extends State<AskExpressInterestScreen> {
  // Stances: 'can_help_directly', 'know_someone', 'introduce_peer'
  String _stance = 'can_help_directly';

  // 1. Direct Help Fields
  final TextEditingController _bringController = TextEditingController();
  String _timeline = 'This month';

  // 2. Know Someone (External Contact) Fields
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _contactNoteController = TextEditingController();

  // 3. Introduce Peer Fields
  PeerEntity? _selectedPeer;
  final TextEditingController _introNoteController = TextEditingController();

  String get _flowCode => widget.submission.flow.code.toLowerCase().trim();
  bool get _isHelpFlow =>
      _flowCode == 'help' || _flowCode == 'advice' || _flowCode == 'get_help';
  bool get _isReferralFlow =>
      _flowCode == 'referral' ||
      _flowCode == 'introduction' ||
      _flowCode == 'intro' ||
      _flowCode == 'give_leads';

  @override
  void initState() {
    super.initState();
    if (_isHelpFlow) {
      _timeline = 'This week';
    } else if (_isReferralFlow) {
      _timeline = 'Immediate';
    } else {
      _timeline = 'This month';
    }
  }

  @override
  void dispose() {
    _bringController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    _contactEmailController.dispose();
    _contactNoteController.dispose();
    _introNoteController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    switch (_stance) {
      case 'can_help_directly':
        return _bringController.text.trim().isNotEmpty;
      case 'know_someone':
        return _contactNameController.text.trim().isNotEmpty &&
            _contactPhoneController.text.trim().isNotEmpty &&
            _contactNoteController.text.trim().isNotEmpty;
      case 'introduce_peer':
        return _selectedPeer != null &&
            _introNoteController.text.trim().isNotEmpty;
      default:
        return false;
    }
  }

  String get _buttonLabel {
    switch (_stance) {
      case 'can_help_directly':
        if (_isHelpFlow) return 'Send Advice & Help';
        if (_isReferralFlow) return 'Offer Introduction';
        return 'Send my interest';
      case 'know_someone':
        return 'Submit Referral';
      case 'introduce_peer':
        return 'Introduce Peer';
      default:
        return 'Submit';
    }
  }

  String get _stepTitle {
    if (_isHelpFlow) return 'Offer Help & Guidance';
    if (_isReferralFlow) return 'Provide Introduction';
    return 'Express interest';
  }

  String get _stepSubtitle {
    if (_isHelpFlow) {
      return 'Share your advice or connect them with the right help';
    }
    if (_isReferralFlow) {
      return 'Connect them with the right person or business';
    }
    return 'Tell them what you bring';
  }

  Future<void> _pickFromContacts() async {
    final result = await ContactPickerSheet.pickContact(context);
    if (result != null) {
      setState(() {
        if (result.name.isNotEmpty) {
          _contactNameController.text = result.name;
        }
        if (result.phone.isNotEmpty) {
          _contactPhoneController.text = result.phone;
        }
        if (result.email != null && result.email!.isNotEmpty) {
          _contactEmailController.text = result.email!;
        }
      });
    }
  }

  Future<void> _pickPeer() async {
    final selected = await CommonPeerSelectorSheet.show(
      context,
      title: 'Select Peer to Introduce',
    );
    if (selected != null) {
      setState(() {
        _selectedPeer = selected;
      });
    }
  }

  void _onSubmit() {
    if (!_canSubmit) return;

    if (_stance == 'can_help_directly') {
      context.read<AskResponseBloc>().add(
            AskResponseSubmitRequested(
              askId: widget.askId,
              responseType: 'can_help_directly',
              message: _bringController.text.trim(),
              timeline: _timeline,
            ),
          );
    } else if (_stance == 'know_someone') {
      context.read<AskResponseBloc>().add(
            AskResponseSubmitRequested(
              askId: widget.askId,
              responseType: 'know_someone',
              message: _contactNoteController.text.trim(),
              timeline: 'immediate',
              extraData: {
                'contact': {
                  'full_name': _contactNameController.text.trim(),
                  'phone': _contactPhoneController.text.trim(),
                  if (_contactEmailController.text.trim().isNotEmpty)
                    'email': _contactEmailController.text.trim(),
                  'note': _contactNoteController.text.trim(),
                },
              },
            ),
          );
    } else if (_stance == 'introduce_peer') {
      context.read<AskResponseBloc>().add(
            AskResponseSubmitRequested(
              askId: widget.askId,
              responseType: 'introduce_peer',
              message: _introNoteController.text.trim(),
              timeline: 'immediate',
              extraData: {
                'introduced_peer_id': _selectedPeer!.id,
                'introduced_peer_name': _selectedPeer!.displayName,
                'note': _introNoteController.text.trim(),
              },
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return BlocConsumer<AskResponseBloc, AskResponseState>(
      listener: (context, state) {
        if (state.status == AskResponseStatus.success) {
          final successMsg = _stance == 'can_help_directly'
              ? (_isHelpFlow
                  ? 'Advice & guidance sent successfully!'
                  : (_isReferralFlow
                      ? 'Introduction offer sent successfully!'
                      : 'Interest sent successfully!'))
              : (_stance == 'know_someone'
                  ? 'Referral submitted successfully!'
                  : 'Peer introduced successfully!');

          AppSnackBar.showSuccess(context, successMsg);
          Navigator.of(context).pop();
        } else if (state.status == AskResponseStatus.error) {
          AppSnackBar.showError(
            context,
            state.errorMessage ?? 'Unable to submit response. Please try again.',
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AskResponseStatus.loading;

        return Scaffold(
          backgroundColor:
              isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          appBar: AppCommonBar(
            title: widget.submission.flow.name.isNotEmpty
                ? widget.submission.flow.name
                : 'Ask',
            showBack: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                AskStepHeader(
                  title: _stepTitle,
                  subtitle: _stepSubtitle,
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Summary Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 0.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (widget.submission.flow.name.isNotEmpty &&
                                      widget.submission.flow.name.toLowerCase() !=
                                          widget.submission.type.name
                                              .toLowerCase()) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3.5),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColor.darkSurfaceSubtle
                                            : const Color(0xFFDBEAFE),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        widget.submission.flow.name,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? AppColor.primaryBlue
                                              : const Color(0xFF1E3A8A),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColor.badgeBlueBg,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      widget.submission.type.name.isNotEmpty
                                          ? widget.submission.type.name
                                          : 'General',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.primaryBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.submission.goal.isNotEmpty
                                    ? widget.submission.goal
                                    : 'Opportunity with ${widget.peer.name}',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Stance selection
                        Text(
                          'Your stance',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildStanceOption(
                          'can_help_directly',
                          _isHelpFlow
                              ? 'I can provide advice / help directly'
                              : (_isReferralFlow
                                  ? 'I can introduce directly / I know them'
                                  : 'I can help / collaborate directly'),
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildStanceOption(
                          'know_someone',
                          _isHelpFlow
                              ? 'I know an expert / someone'
                              : (_isReferralFlow
                                  ? 'I know someone connected'
                                  : 'I know someone'),
                          isDark,
                        ),
                        const SizedBox(height: 8),
                        _buildStanceOption(
                          'introduce_peer',
                          'I can introduce a peer',
                          isDark,
                        ),
                        const SizedBox(height: 16),

                        // Dynamic Form Content
                        if (_stance == 'can_help_directly') ...[
                          _buildDirectHelpSection(
                              isDark, cardBg, borderColor, titleColor),
                        ] else if (_stance == 'know_someone') ...[
                          _buildKnowSomeoneSection(
                              isDark, cardBg, borderColor, titleColor),
                        ] else if (_stance == 'introduce_peer') ...[
                          _buildIntroducePeerSection(
                              isDark, cardBg, borderColor, titleColor),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                AskBottomButton(
                  label: _buttonLabel,
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

  // 1. Direct Help Form Section
  Widget _buildDirectHelpSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color titleColor,
  ) {
    final label = _isHelpFlow
        ? 'Your Advice / How you can help *'
        : (_isReferralFlow
            ? 'How you can connect them *'
            : 'What I bring *');

    final hint = _isHelpFlow
        ? 'Share your guidance, solutions, or experience...'
        : (_isReferralFlow
            ? 'Describe how you know them or how you will introduce...'
            : 'Your strength, and one proof point');

    final timelineTitle = _isHelpFlow
        ? 'Availability'
        : (_isReferralFlow
            ? 'When can you introduce?'
            : 'When can you start?');

    final timelineOptions = _isHelpFlow
        ? ['Today', 'This week', 'This month', 'Flexible']
        : (_isReferralFlow
            ? ['Immediate', 'This week', 'This month']
            : ['This month', '3 months', 'Later']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextField(
            controller: _bringController,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            style: TextStyle(fontSize: 13.5, color: titleColor),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          timelineTitle,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: timelineOptions
              .map((opt) => _buildTimelinePill(opt, isDark))
              .toList(),
        ),
      ],
    );
  }

  // 2. Know Someone (External Contact) Form Section
  Widget _buildKnowSomeoneSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color titleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Contact Details',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            InkWell(
              onTap: _pickFromContacts,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColor.badgeBlueBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.contacts_rounded,
                      size: 13,
                      color: AppColor.primaryBlue,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Pick Contact',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildInputField(
          controller: _contactNameController,
          label: 'Full Name *',
          hint: 'e.g. John Doe',
          icon: Icons.person_outline_rounded,
          isDark: isDark,
          cardBg: cardBg,
          borderColor: borderColor,
          titleColor: titleColor,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          controller: _contactPhoneController,
          label: 'Phone Number *',
          hint: 'e.g. +91 98765 43210',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          isDark: isDark,
          cardBg: cardBg,
          borderColor: borderColor,
          titleColor: titleColor,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          controller: _contactEmailController,
          label: 'Email (Optional)',
          hint: 'e.g. john@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          isDark: isDark,
          cardBg: cardBg,
          borderColor: borderColor,
          titleColor: titleColor,
        ),
        const SizedBox(height: 10),
        _buildInputField(
          controller: _contactNoteController,
          label: 'Why do you recommend them? *',
          hint: 'Explain their experience and how they can help with this ask',
          icon: Icons.notes_rounded,
          maxLines: 3,
          isDark: isDark,
          cardBg: cardBg,
          borderColor: borderColor,
          titleColor: titleColor,
        ),
      ],
    );
  }

  // 3. Introduce Peer Form Section
  Widget _buildIntroducePeerSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color titleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Peer to Introduce *',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 8),
        if (_selectedPeer == null) ...[
          InkWell(
            onTap: _pickPeer,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColor.primaryBlue.withValues(alpha: 0.5),
                  width: 1.2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColor.badgeBlueBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_search_rounded,
                      color: AppColor.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Peer from Platform',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Tap to choose a connection or peer',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.primaryBlue, width: 1.2),
            ),
            child: Row(
              children: [
                AppAvatar(
                  imageUrl: _selectedPeer!.profilePhotoUrl,
                  name: _selectedPeer!.displayName,
                  size: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedPeer!.displayName,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_selectedPeer!.companyName != null &&
                          _selectedPeer!.companyName!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          _selectedPeer!.companyName!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _pickPeer,
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        _buildInputField(
          controller: _introNoteController,
          label: 'Introduction Note *',
          hint: 'Why are you introducing this peer for this ask?',
          icon: Icons.notes_rounded,
          maxLines: 3,
          isDark: isDark,
          cardBg: cardBg,
          borderColor: borderColor,
          titleColor: titleColor,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color titleColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          child: Row(
            crossAxisAlignment: maxLines > 1
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: maxLines > 1 ? 10 : 0),
                child: Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  keyboardType: keyboardType,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(fontSize: 13, color: titleColor),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStanceOption(String code, String label, bool isDark) {
    final isSelected = _stance == code;
    final borderColor = isSelected
        ? AppColor.primaryBlue
        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0));
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return InkWell(
      onTap: () => setState(() => _stance = code),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 0.8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColor.primaryBlue
                      : const Color(0xFF94A3B8),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.primaryBlue,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? Colors.white : AppColor.primaryBlue)
                      : titleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelinePill(String label, bool isDark) {
    final isSelected = _timeline == label;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => setState(() => _timeline = label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColor.brandGradient : null,
            color: isSelected
                ? null
                : (isDark ? const Color(0xFF1E293B) : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(
                    color: borderColor,
                    width: 0.8,
                  ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : titleColor,
            ),
          ),
        ),
      ),
    );
  }
}
