import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/datasources/location_remote_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/utils/date_input_formatter.dart';
import '../../../../core/widgets/app_date_picker_dialog.dart';
import '../../../../core/widgets/app_phone_field.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/city_picker_sheet.dart';
import '../../../../core/widgets/offline_prompt_dialog.dart';
import '../../../auth/presentation/widgets/country_code_sheet.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditPersonalInfoScreen({
    super.key,
    required this.profile,
  });

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final LocationRemoteDataSource _locationDataSource;
  String? _selectedCityId;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _displayNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _secondaryMobileController;
  late TextEditingController _cityNameController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _pincodeController;
  late TextEditingController _addressController;
  late TextEditingController _bioController;
  late TextEditingController _superpowerController;
  late TextEditingController _dobController;
  late TextEditingController _anniversaryController;

  String? _gender;
  DateTime? _dob;
  DateTime? _anniversaryDate;
  String? _preferredLanguage;

  final List<String> _genderOptions = ['male', 'female', 'other'];
  final List<String> _languageOptions = ['English', 'Hindi', 'Gujarati', 'Marathi', 'Other'];

  String _formatDisplayDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatIsoDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _locationDataSource = LocationRemoteDataSourceImpl(dioClient: DioClient());

    final p = widget.profile;
    _selectedCityId = p.city?.id?.toString();

    _firstNameController = TextEditingController(text: p.firstName ?? '');
    _lastNameController = TextEditingController(text: p.lastName ?? '');
    _displayNameController = TextEditingController(text: p.displayName); 
    _emailController = TextEditingController(text: p.email ?? '');
    _phoneController = TextEditingController(text: p.phone ?? '');
    _secondaryMobileController = TextEditingController(text: p.secondaryMobile ?? '');
    _cityNameController = TextEditingController(text: p.city?.name ?? p.city?.formattedLocation ?? '');
    _stateController = TextEditingController(text: p.state ?? '');
    _countryController = TextEditingController(text: p.country ?? '');
    _pincodeController = TextEditingController(text: p.pincode ?? '');
    _addressController = TextEditingController(text: p.address ?? '');
    _bioController = TextEditingController(text: p.bio ?? '');
    _superpowerController = TextEditingController(text: p.superpower ?? '');

    _gender = p.gender;
    if (p.dob != null && p.dob!.trim().isNotEmpty) {
      _dob = AppDateFormatter.parseFlexible(p.dob!);
    }
    _dobController = TextEditingController(
      text: _dob != null ? _formatDisplayDate(_dob!) : (p.dob ?? ''),
    );

    if (p.anniversaryDate != null && p.anniversaryDate!.trim().isNotEmpty) {
      _anniversaryDate = AppDateFormatter.parseFlexible(p.anniversaryDate!);
    }
    _anniversaryController = TextEditingController(
      text: _anniversaryDate != null ? _formatDisplayDate(_anniversaryDate!) : (p.anniversaryDate ?? ''),
    );

    _preferredLanguage = p.preferredLanguage ?? 'English';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _secondaryMobileController.dispose();
    _cityNameController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pincodeController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _superpowerController.dispose();
    _dobController.dispose();
    _anniversaryController.dispose();
    super.dispose();
  }

  Future<void> _pickCity() async {
    final picked = await CityPickerSheet.show(
      context,
      dataSource: _locationDataSource,
      selectedCityId: _selectedCityId,
    );
    if (picked != null) {
      setState(() {
        _selectedCityId = picked.id;
        _cityNameController.text = picked.name.isNotEmpty ? picked.name : picked.label;
        if (picked.state.isNotEmpty) {
          _stateController.text = picked.state;
        } else if (picked.stateCode.isNotEmpty) {
          _stateController.text = picked.stateCode;
        }
        if (picked.country.isNotEmpty) {
          _countryController.text = picked.country;
        } else if (picked.countryCode.isNotEmpty) {
          _countryController.text = picked.countryCode;
        }
      });
    }
  }

  Future<void> _pickDate({required bool isDob}) async {
    final now = DateTime.now();
    DateTime? currentParsed = isDob
        ? (AppDateFormatter.parseFlexible(_dobController.text.trim()) ?? _dob)
        : (AppDateFormatter.parseFlexible(_anniversaryController.text.trim()) ?? _anniversaryDate);

    final initialDate = isDob
        ? (currentParsed ?? DateTime(now.year - 25, 1, 1))
        : (currentParsed ?? DateTime(now.year - 5, 1, 1));

    final picked = await AppDatePickerDialog.show(
      context,
      title: isDob ? 'Select Date of Birth' : 'Select Anniversary Date',
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: DateTime(1940),
      lastDate: isDob ? now : DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        final formatted = _formatDisplayDate(picked);
        if (isDob) {
          _dob = picked;
          _dobController.text = formatted;
        } else {
          _anniversaryDate = picked;
          _anniversaryController.text = formatted;
        }
      });
    }
  }

  String? _validateDob(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = AppDateFormatter.parseFlexible(value.trim());
    if (parsed == null) {
      return 'Format: DD/MM/YYYY';
    }
    if (parsed.isAfter(DateTime.now())) {
      return 'DOB cannot be in future';
    }
    if (parsed.year < 1920) {
      return 'Invalid year';
    }
    return null;
  }

  String? _validateAnniversary(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = AppDateFormatter.parseFlexible(value.trim());
    if (parsed == null) {
      return 'Format: DD/MM/YYYY';
    }
    if (parsed.year < 1940 || parsed.year > DateTime.now().year + 1) {
      return 'Invalid year';
    }
    return null;
  }

  void _saveChanges() {
    if (!OfflineGuard.check(context, actionName: 'save profile changes')) return;
    if (!_formKey.currentState!.validate()) return;

    final parsedDob = _dobController.text.trim().isNotEmpty
        ? AppDateFormatter.parseFlexible(_dobController.text.trim())
        : null;
    final parsedAnniversary = _anniversaryController.text.trim().isNotEmpty
        ? AppDateFormatter.parseFlexible(_anniversaryController.text.trim())
        : null;

    final payload = <String, dynamic>{
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'display_name': _displayNameController.text.trim(),
      'secondary_mobile': _secondaryMobileController.text.trim(),
      'gender': _gender,
      'dob': parsedDob != null ? _formatIsoDate(parsedDob) : null,
      'anniversary_date': parsedAnniversary != null ? _formatIsoDate(parsedAnniversary) : null,
      if (_selectedCityId != null && _selectedCityId!.isNotEmpty) 'city_id': _selectedCityId,
      'city': _cityNameController.text.trim(),
      'city_of_residence': _cityNameController.text.trim(),
      'state': _stateController.text.trim(),
      'country': _countryController.text.trim(),
      'pincode': _pincodeController.text.trim(),
      'address': _addressController.text.trim(),
      'preferred_language': _preferredLanguage,
      'bio': _bioController.text.trim(),
      'superpower': _superpowerController.text.trim(),
    };

    context.read<ProfileEditBloc>().add(
          ProfileSaveSectionRequested(
            sectionName: 'Personal Information',
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
          'Personal Information',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
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
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            (current.status == ProfileEditStatus.saved ||
                current.status == ProfileEditStatus.failure),
        listener: (context, state) {
          if (state.status == ProfileEditStatus.saved) {
            AppSnackBar.showSuccess(
              context,
              state.successMessage ?? 'Personal information updated successfully!',
            );
            context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
            Navigator.of(context).pop();
          } else if (state.status == ProfileEditStatus.failure && state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
            context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
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
                  // Names Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _firstNameController,
                          label: 'First Name',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildTextField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _displayNameController,
                    label: 'Display Name',
                    validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Email (Read only if server managed)
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    enabled: false,
                    helperText: 'Email is associated with your account login',
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Phone & Secondary Mobile
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _phoneController,
                          label: 'Phone',
                          enabled: false,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildTextField(
                          controller: _secondaryMobileController,
                          label: 'Secondary Phone',
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Gender & Language
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Gender',
                          value: _gender,
                          items: _genderOptions,
                          onChanged: (v) => setState(() => _gender = v),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Language',
                          value: _preferredLanguage,
                          items: _languageOptions,
                          onChanged: (v) => setState(() => _preferredLanguage = v),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Dates Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDateField(
                          controller: _dobController,
                          label: 'Date of Birth',
                          validator: _validateDob,
                          onCalendarTap: () => _pickDate(isDob: true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildDateField(
                          controller: _anniversaryController,
                          label: 'Anniversary',
                          validator: _validateAnniversary,
                          onCalendarTap: () => _pickDate(isDob: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Location Section Title
                  Text(
                    'LOCATION DETAILS',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.textTertiary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  _buildTextField(
                    controller: _addressController,
                    label: 'Address',
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildPickerField(
                    label: 'City',
                    value: _cityNameController.text,
                    placeholder: 'Select City',
                    icon: Icons.location_city_rounded,
                    onTap: _pickCity,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _stateController,
                          label: 'State',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildTextField(
                          controller: _countryController,
                          label: 'Country',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  _buildTextField(
                    controller: _pincodeController,
                    label: 'Pincode',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // About & Superpower
                  Text(
                    'ABOUT & SUPERPOWER',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.textTertiary,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildTextField(
                    controller: _bioController,
                    label: 'Bio',
                    maxLines: 3,
                    helperText: 'A short summary about yourself',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTextField(
                    controller: _superpowerController,
                    label: 'Core Strength / Superpower',
                    helperText: 'e.g. Scaling B2B Sales, Product Design',
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Save Changes CTA
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
                                    fontWeight: FontWeight.w500,
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

  String _phoneCountryCode = '+91';
  String _phoneCountryFlag = '🇮🇳';

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    String? helperText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final isPhone = keyboardType == TextInputType.phone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: enabled,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          inputFormatters: isPhone
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  const NoLeadingZeroFormatter(),
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
          style: AppTypography.bodyMedium.copyWith(
            color: enabled ? AppColor.textPrimary : AppColor.textTertiary,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? AppColor.white : AppColor.backgroundSubtle,
            helperText: helperText,
            prefixIcon: isPhone
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: enabled
                        ? () async {
                            final picked = await CountryCodeSheet.show(context, _phoneCountryCode);
                            if (picked != null) {
                              setState(() {
                                _phoneCountryCode = picked.dialCode;
                                _phoneCountryFlag = picked.flag.isNotEmpty ? picked.flag : '🌐';
                              });
                            }
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_phoneCountryFlag, style: const TextStyle(fontSize: 15)),
                          const SizedBox(width: 4),
                          Text(
                            _phoneCountryCode,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColor.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(Icons.arrow_drop_down_rounded, size: 18, color: AppColor.textTertiary),
                          const SizedBox(width: 4),
                          Container(width: 1, height: 16, color: AppColor.borderSubtle),
                        ],
                      ),
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.borderSubtle),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide(color: AppColor.borderSubtle.withValues(alpha: 0.5)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPickerField({
    required String label,
    required String value,
    required String placeholder,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColor.borderSubtle),
            ),
            child: Row(
              children: [
                Icon(icon, size: 17, color: AppColor.primaryBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value.isNotEmpty ? value : placeholder,
                    style: AppTypography.bodyMedium.copyWith(
                      color: value.isNotEmpty ? AppColor.textPrimary : AppColor.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded, size: 22, color: AppColor.textTertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColor.borderSubtle),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: items.contains(value) ? value : null,
              hint: Text('Select', style: AppTypography.bodySmall.copyWith(color: AppColor.textTertiary)),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: AppTypography.bodySmall),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onCalendarTap,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            DateAutoSlashInputFormatter(),
          ],
          validator: validator,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColor.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'DD/MM/YYYY',
            hintStyle: AppTypography.bodySmall.copyWith(
              color: AppColor.textTertiary,
            ),
            filled: true,
            fillColor: AppColor.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_today_outlined,
                size: 17,
                color: AppColor.primaryBlue,
              ),
              onPressed: onCalendarTap,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }
}
