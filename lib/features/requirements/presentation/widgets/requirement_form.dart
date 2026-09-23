import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/paywall_gate_helper.dart';
import '../../../../core/widgets/offline_prompt_dialog.dart';
import '../../../highlights/presentation/widgets/certification_info_banner.dart';
import '../../../highlights/presentation/widgets/post_ask_attachment_picker.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../bloc/requirements_bloc.dart';
import '../bloc/requirements_event.dart';
import '../bloc/requirements_state.dart';

class RequirementForm extends StatefulWidget {
  final VoidCallback? onSuccess;

  const RequirementForm({super.key, this.onSuccess});

  @override
  State<RequirementForm> createState() => _RequirementFormState();
}

class _RequirementFormState extends State<RequirementForm> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();

  String? _selectedCategory;
  String _selectedRegion = 'All India';
  File? _selectedAttachment;

  static const List<String> _categories = [
    'Business Leads',
    'Partnership Opportunities',
    'Job Opportunities',
    'Service Providers',
    'Investment Opportunities',
    'Other',
  ];

  static const List<String> _regions = [
    'All India',
    'North India',
    'South India',
    'East India',
    'West India',
    'Central India',
    'Northeast India',
  ];

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
  }

  void _prefillFromProfile() {
    final profileState = context.read<ProfileBloc>().state;
    if (profileState.profile == null) {
      context.read<ProfileBloc>().add(const ProfileFetchRequested());
      return;
    }
    final p = profileState.profile!;
    if (_cityController.text.isEmpty) {
      _cityController.text = p.city?.name ?? p.businessCity ?? p.state ?? '';
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _subjectController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedAttachment = null;
      _selectedCategory = null;
      _selectedRegion = 'All India';
    });
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if (!PaywallGateHelper.checkPro(context, message: 'Upgrade to Pro to post requirements.')) {
      return;
    }

    if (!OfflineGuard.check(context, actionName: 'post requirements')) {
      return;
    }

    context.read<RequirementsBloc>().add(
          CreateRequirementEvent(
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _selectedCategory!,
            regionLabel: _selectedRegion,
            cityName: _cityController.text.trim(),
            attachment: _selectedAttachment,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.profile != null) _prefillFromProfile();
          },
        ),
        BlocListener<RequirementsBloc, RequirementsState>(
          listenWhen: (prev, curr) =>
              prev.status != curr.status &&
              curr.status == RequirementsStatus.success,
          listener: (context, state) {
            _clearForm();
            widget.onSuccess?.call();
          },
        ),
      ],
      child: BlocBuilder<RequirementsBloc, RequirementsState>(
        builder: (context, state) {
          final isSubmitting = state.status == RequirementsStatus.submitting;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CertificationInfoBanner(
                    title: 'Post Business Requirement',
                    description:
                        'Share your requirements with peers across the network to find business leads, service providers, or partners.',
                    icon: Icons.assignment_turned_in_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Subject
                  _buildInputLabel('Subject *'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _subjectController,
                    decoration: _inputDecoration(
                      hint: 'e.g. Looking for UI/UX Designer for Web App',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Subject is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  _buildInputLabel('Category *'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    hint: Text(
                      'Select Category',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColor.textTertiary,
                      ),
                    ),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Category is required' : null,
                    decoration: _inputDecoration(),
                  ),
                  const SizedBox(height: 16),

                  // Region
                  _buildInputLabel('Region *'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRegion,
                    items: _regions
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedRegion = v);
                    },
                    decoration: _inputDecoration(),
                  ),
                  const SizedBox(height: 16),

                  // City
                  _buildInputLabel('City *'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cityController,
                    decoration: _inputDecoration(
                      hint: 'e.g. Mumbai, Maharashtra',
                      prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'City is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _buildInputLabel('Description *'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: _inputDecoration(
                      hint: 'Provide detailed specifications, timeline, budget, and requirements...',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Description is required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Media Attachment
                  _buildInputLabel('Media / Attachment (Optional)'),
                  const SizedBox(height: 6),
                  PostAskAttachmentPicker(
                    selectedImage: _selectedAttachment,
                    onImageSelected: (file) {
                      setState(() => _selectedAttachment = file);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Post Requirement',
                            style: AppTypography.titleSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: AppTypography.bodySmall.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColor.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMedium.copyWith(color: AppColor.textTertiary),
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.error),
      ),
    );
  }
}
