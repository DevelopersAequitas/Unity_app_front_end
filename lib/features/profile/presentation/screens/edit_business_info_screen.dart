import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';
import '../widgets/profile_chip_input.dart';

class EditBusinessInfoScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditBusinessInfoScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditBusinessInfoScreen> createState() => _EditBusinessInfoScreenState();
}

class _EditBusinessInfoScreenState extends State<EditBusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _companyNameController;
  late TextEditingController _designationController;
  late TextEditingController _businessTypeController;
  late TextEditingController _companyTypeController;
  late TextEditingController _yearOfEstablishmentController;
  late TextEditingController _annualRevenueController;
  late TextEditingController _numberOfEmployeesController;
  late TextEditingController _gstNumberController;
  late TextEditingController _businessWebsiteController;
  late TextEditingController _businessAddressController;
  late TextEditingController _businessPincodeController;
  late TextEditingController _businessSubCategoryController;
  late TextEditingController _productsServicesController;

  List<String> _businessKeywords = [];

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _companyNameController = TextEditingController(text: p.companyName ?? '');
    _designationController = TextEditingController(text: p.designation ?? '');
    _businessTypeController = TextEditingController(text: p.businessType ?? '');
    _companyTypeController = TextEditingController(text: p.companyType ?? '');
    _yearOfEstablishmentController =
        TextEditingController(text: p.yearOfEstablishment != null ? '${p.yearOfEstablishment}' : '');
    _annualRevenueController = TextEditingController(text: p.annualRevenueRange ?? '');
    _numberOfEmployeesController = TextEditingController(text: p.numberOfEmployees ?? '');
    _gstNumberController = TextEditingController(text: p.gstNumber ?? '');
    _businessWebsiteController = TextEditingController(text: p.businessWebsite ?? '');
    _businessAddressController = TextEditingController(text: p.businessAddress ?? '');
    _businessPincodeController = TextEditingController(text: p.businessPincode ?? '');
    _businessSubCategoryController =
        TextEditingController(text: p.businessSubCategory ?? p.otherCategoryName ?? '');
    _productsServicesController = TextEditingController(text: p.productsServicesOffered ?? '');
    _businessKeywords = List<String>.from(p.businessKeywords);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _designationController.dispose();
    _businessTypeController.dispose();
    _companyTypeController.dispose();
    _yearOfEstablishmentController.dispose();
    _annualRevenueController.dispose();
    _numberOfEmployeesController.dispose();
    _gstNumberController.dispose();
    _businessWebsiteController.dispose();
    _businessAddressController.dispose();
    _businessPincodeController.dispose();
    _businessSubCategoryController.dispose();
    _productsServicesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final estYear = int.tryParse(_yearOfEstablishmentController.text.trim());

    final payload = <String, dynamic>{
      'company_name': _companyNameController.text.trim(),
      'designation': _designationController.text.trim(),
      'business_type': _businessTypeController.text.trim(),
      'company_type': _companyTypeController.text.trim(),
      'year_of_establishment': estYear,
      'annual_revenue_range': _annualRevenueController.text.trim(),
      'number_of_employees': _numberOfEmployeesController.text.trim(),
      'gst_number': _gstNumberController.text.trim(),
      'business_website': _businessWebsiteController.text.trim(),
      'business_address': _businessAddressController.text.trim(),
      'business_pincode': _businessPincodeController.text.trim(),
      'business_sub_category': _businessSubCategoryController.text.trim(),
      'products_services_offered': _productsServicesController.text.trim(),
      'business_keywords': _businessKeywords,
    };

    context.read<ProfileEditBloc>().add(
          ProfileSaveSectionRequested(
            sectionName: 'Business Information',
            updateData: payload,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text(
          'Business Information',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColor.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColor.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.textPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: BlocConsumer<ProfileEditBloc, ProfileEditState>(
        listener: (context, state) {
          if (state.status == ProfileEditStatus.saved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage ?? 'Business information updated successfully!'),
                backgroundColor: const Color(0xFF10B981),
              ),
            );
            Navigator.of(context).pop();
          } else if (state.status == ProfileEditStatus.failure && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSaving = state.status == ProfileEditStatus.saving;

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _companyNameController,
                    label: 'Company Name',
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _designationController,
                    label: 'Designation / Role',
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _companyTypeController,
                          label: 'Company Type',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildTextField(
                          controller: _yearOfEstablishmentController,
                          label: 'Est. Year',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _businessTypeController,
                    label: 'Business Type',
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _numberOfEmployeesController,
                          label: 'Team Size',
                          hintText: 'e.g. 1-10',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildTextField(
                          controller: _annualRevenueController,
                          label: 'Revenue Range',
                          hintText: 'e.g. 1-5 Cr',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _gstNumberController,
                    label: 'GST Number',
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _businessWebsiteController,
                    label: 'Business Website',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _businessSubCategoryController,
                    label: 'Business Sub-Category',
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _productsServicesController,
                    label: 'Products / Services Offered',
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Business Keywords
                  ProfileChipInput(
                    label: 'Business Keywords / Tags',
                    items: _businessKeywords,
                    hintText: 'e.g. SaaS, AI, Mobile App',
                    accentColor: AppColor.primaryGradientEnd,
                    onChanged: (updated) {
                      setState(() {
                        _businessKeywords = updated;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Location Details
                  Text(
                    'BUSINESS ADDRESS',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.textTertiary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  _buildTextField(
                    controller: _businessAddressController,
                    label: 'Address',
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _businessPincodeController,
                    label: 'Pincode',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: AppColor.brandGradient,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isSaving ? null : _saveChanges,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        child: Center(
                          child: isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: AppTypography.labelLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTypography.bodyMedium.copyWith(color: AppColor.textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.white,
            hintText: hintText,
            hintStyle: AppTypography.bodySmall.copyWith(color: AppColor.textTertiary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.borderSubtle),
            ),
          ),
        ),
      ],
    );
  }
}
