import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/hive_cache_store.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/location_picker_sheet.dart';
import '../../domain/entities/profile_entity.dart';
import '../bloc/profile_edit_bloc.dart';
import '../bloc/profile_edit_event.dart';
import '../bloc/profile_edit_state.dart';
import '../widgets/business_category_selector.dart';
import '../widgets/edit_business_text_fields.dart';
import '../widgets/profile_chip_input.dart';

class EditBusinessInfoScreen extends StatefulWidget {
  final ProfileEntity profile;

  const EditBusinessInfoScreen({super.key, required this.profile});

  @override
  State<EditBusinessInfoScreen> createState() => _EditBusinessInfoScreenState();
}

class _EditBusinessInfoScreenState extends State<EditBusinessInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _companyController;
  late TextEditingController _designationController;
  late TextEditingController _businessTypeController;
  late TextEditingController _companyTypeController;
  late TextEditingController _estYearController;
  late TextEditingController _annualRevenueController;
  late TextEditingController _teamSizeController;
  late TextEditingController _gstController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;
  late TextEditingController _pincodeController;
  late TextEditingController _productsController;

  List<String> _businessKeywords = [];

  // Map coordinates state
  double? _latitude;
  double? _longitude;

  // Category state
  int? _selectedMainCategoryId;
  String? _selectedMainCategory;
  dynamic _selectedSubCategoryId;
  String? _selectedSubCategory;
  bool _isOtherCategory = false;
  String? _otherCategoryName;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _printBearerToken();

    _companyController = TextEditingController(text: p.companyName ?? '');
    _designationController = TextEditingController(text: p.designation ?? '');
    _businessTypeController = TextEditingController(text: p.businessType ?? '');
    _companyTypeController = TextEditingController(text: p.companyType ?? '');
    _estYearController = TextEditingController(
      text: p.yearOfEstablishment != null ? '${p.yearOfEstablishment}' : '',
    );
    _annualRevenueController = TextEditingController(
      text: p.annualRevenueRange ?? '',
    );
    _teamSizeController = TextEditingController(
      text: p.numberOfEmployees ?? '',
    );
    _gstController = TextEditingController(text: p.gstNumber ?? '');
    _websiteController = TextEditingController(text: p.businessWebsite ?? '');
    _addressController = TextEditingController(text: p.businessAddress ?? '');
    _pincodeController = TextEditingController(text: p.businessPincode ?? '');
    _productsController = TextEditingController(
      text: p.productsServicesOffered ?? '',
    );
    _businessKeywords = List<String>.from(p.businessKeywords);

    _latitude = p.googleMapsLatitude;
    _longitude = p.googleMapsLongitude;

    _selectedMainCategory = p.mainBusinessCategory ?? p.businessCategory;
    _selectedMainCategoryId = p.mainBusinessCategoryId ?? p.businessCategoryId;
    _selectedSubCategory = p.businessSubCategory;
    _otherCategoryName = p.otherCategoryName;
    _isOtherCategory = p.isOtherCategory;
  }

  Future<void> _printBearerToken() async {
    try {
      final cacheStore = HiveCacheStore();
      final token = await cacheStore.get<String>(
        AppCacheBoxes.authBox,
        AppCacheKeys.authToken,
      );
      debugPrint('======================================================');
      debugPrint('CURRENT USER BEARER TOKEN: Bearer $token');
      debugPrint('======================================================');
    } catch (e) {
      debugPrint('Failed to retrieve bearer token: $e');
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _designationController.dispose();
    _businessTypeController.dispose();
    _companyTypeController.dispose();
    _estYearController.dispose();
    _annualRevenueController.dispose();
    _teamSizeController.dispose();
    _gstController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _productsController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation(BuildContext context) async {
    final result = await LocationPickerSheet.show(
      context,
      initialLatitude: _latitude,
      initialLongitude: _longitude,
      initialAddress: _addressController.text.trim(),
    );

    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        if (result.address.trim().isNotEmpty) {
          _addressController.text = result.address.trim();
        }
        if (result.pincode != null && result.pincode!.trim().isNotEmpty) {
          _pincodeController.text = result.pincode!.trim();
        } else {
          final pinMatch =
              RegExp(r'\b([1-9][0-9]{5})\b').firstMatch(result.address);
          if (pinMatch != null) {
            _pincodeController.text = pinMatch.group(1)!;
          }
        }
      });
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          'Company location pinned successfully.',
        );
      }
    }
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;

    final subCategoryValue = _isOtherCategory
        ? (_otherCategoryName?.trim() ?? '')
        : (_selectedSubCategory?.trim() ?? '');

    final payload = <String, dynamic>{
      'company_name': _companyController.text.trim(),
      'designation': _designationController.text.trim(),
      'company_type': _companyTypeController.text.trim(),
      'year_of_establishment': int.tryParse(_estYearController.text.trim()),
      'annual_revenue_range': _annualRevenueController.text.trim(),
      'number_of_employees': _teamSizeController.text.trim(),
      'gst_number': _gstController.text.trim(),
      'business_website': _websiteController.text.trim(),
      'business_address': _addressController.text.trim(),
      'business_pincode': _pincodeController.text.trim(),
      'google_maps_latitude': _latitude,
      'google_maps_longitude': _longitude,
      'latitude': _latitude,
      'longitude': _longitude,
      'products_services_offered': _productsController.text.trim(),
      'business_keywords': _businessKeywords,
      // Categories matching updated backend:
      'business_type': _selectedMainCategory,
      'main_business_category_id': _selectedMainCategoryId,
      'business_category_id': _isOtherCategory
          ? null
          : (_selectedSubCategoryId == 'other' || _selectedSubCategoryId == -1
              ? null
              : _selectedSubCategoryId),
      'business_sub_category': subCategoryValue,
      'is_other_category': _isOtherCategory,
      'other_category_name': _isOtherCategory ? _otherCategoryName?.trim() : null,
      'custom_category_name': _isOtherCategory ? _otherCategoryName?.trim() : null,
      'business_category': _isOtherCategory
          ? null
          : (_selectedSubCategoryId != null &&
                  _selectedSubCategoryId != 'other' &&
                  _selectedSubCategoryId != -1
              ? {
                  'id': _selectedSubCategoryId,
                  'name': subCategoryValue,
                }
              : null),
    };

    debugPrint('Submitting Business Info Payload: $payload');

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
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Business Information',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColor.lightTextPrimary,
          ),
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
              state.successMessage ?? 'Business info updated!',
            );
            context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
            Navigator.of(context).pop();
          } else if (state.status == ProfileEditStatus.failure &&
              state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
            context.read<ProfileEditBloc>().add(const ProfileEditResetRequested());
          }
        },
        builder: (context, state) {
          final isSaving = state.status == ProfileEditStatus.saving;
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditBusinessTextField(
                    controller: _companyController,
                    label: 'Company Name',
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  EditBusinessTextField(
                    controller: _designationController,
                    label: 'Designation / Role',
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  BusinessCategorySelector(
                    initialMainCategoryId: _selectedMainCategoryId,
                    initialMainCategory: _selectedMainCategory,
                    initialSubCategoryId: _selectedSubCategoryId,
                    initialSubCategory: _selectedSubCategory,
                    initialOtherCategory: _otherCategoryName,
                    isInitialOther: _isOtherCategory,
                    onChanged: (res) {
                      setState(() {
                        _selectedMainCategoryId = res.mainCategoryId;
                        _selectedMainCategory = res.mainCategoryName;
                        _businessTypeController.text = res.mainCategoryName ?? '';
                        _selectedSubCategoryId = res.subCategoryId;
                        _selectedSubCategory = res.subCategoryName;
                        _isOtherCategory = res.isOther;
                        _otherCategoryName = res.otherCategoryName;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: EditBusinessTextField(
                          controller: _companyTypeController,
                          label: 'Company Type',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: EditBusinessTextField(
                          controller: _estYearController,
                          label: 'Est. Year',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: EditBusinessTextField(
                          controller: _teamSizeController,
                          label: 'Team Size',
                          hintText: 'e.g. 1-10',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: EditBusinessTextField(
                          controller: _annualRevenueController,
                          label: 'Revenue Range',
                          hintText: 'e.g. 1-5 Cr',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  EditBusinessTextField(
                    controller: _gstController,
                    label: 'GST Number',
                  ),
                  const SizedBox(height: 12),
                  EditBusinessTextField(
                    controller: _websiteController,
                    label: 'Business Website',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 12),
                  EditBusinessTextField(
                    controller: _productsController,
                    label: 'Products / Services Offered',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  ProfileChipInput(
                    label: 'Business Keywords / Tags',
                    items: _businessKeywords,
                    hintText: 'e.g. SaaS, AI, Mobile App',
                    accentColor: AppColor.primaryBlue,
                    onChanged: (updated) =>
                        setState(() => _businessKeywords = updated),
                  ),
                  const SizedBox(height: 12),
                  EditBusinessTextField(
                    controller: _addressController,
                    label: 'Business Address',
                    maxLines: 2,
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppColor.lightTextSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.map_outlined,
                        color: AppColor.primaryBlue,
                        size: 22,
                      ),
                      tooltip: 'Pick location on Map',
                      onPressed: () => _pickLocation(context),
                    ),
                  ),
                  if (_latitude != null && _longitude != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.primaryBlue.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.my_location,
                            size: 14,
                            color: AppColor.primaryBlue,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pin: ${_latitude!.toStringAsFixed(4)}, ${_longitude!.toStringAsFixed(4)} (Geo-Tagged)',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _pickLocation(context),
                            child: const Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _pickLocation(context),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.touch_app_outlined,
                              size: 14,
                              color: AppColor.primaryBlue,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Pick company pin on map for Near Me Peers',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.primaryBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  EditBusinessTextField(
                    controller: _pincodeController,
                    label: 'Pincode',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: isSaving ? null : AppColor.brandGradient,
                      color: isSaving ? AppColor.lightBorder : null,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSaving
                          ? null
                          : [
                              BoxShadow(
                                color: AppColor.primaryPink.withValues(alpha: 0.28),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isSaving ? null : _saveChanges,
                        borderRadius: BorderRadius.circular(24),
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
