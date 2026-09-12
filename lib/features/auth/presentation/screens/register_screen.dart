import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/datasources/location_remote_datasource.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/auth_ambient_background.dart';
import '../../../../core/widgets/image_source_picker_sheet.dart';
import '../../../../core/widgets/location_picker_sheet.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/register_params.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';
import '../widgets/register_progress_header.dart';
import '../widgets/register_step_switcher.dart';
import 'register_form_controllers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = RegisterFormControllers();
  late final PageController _pageController;
  final _locationDataSource = LocationRemoteDataSourceImpl(
    dioClient: DioClient(),
  );

  int? _mainCategoryId;
  String? _mainCategoryName;
  int? _categoryId;
  String? _categoryName;
  bool _isOtherCategory = false;
  String? _selectedCityId;
  String? _selectedCity;
  String? _selectedDob;
  String? _profilePhotoId;
  double? _latitude;
  double? _longitude;
  bool _isDraftLoaded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _setupDraftAutoSave();
    final bloc = context.read<RegisterBloc>();
    bloc.add(const RegisterDraftLoadRequested());
    bloc.add(const RegisterMainCategoriesRequested());
  }

  void _setupDraftAutoSave() {
    _form.firstName.addListener(_autoSaveDraft);
    _form.lastName.addListener(_autoSaveDraft);
    _form.email.addListener(_autoSaveDraft);
    _form.phone.addListener(_autoSaveDraft);
    _form.companyName.addListener(_autoSaveDraft);
    _form.companyAddress.addListener(_autoSaveDraft);
    _form.otherCategory.addListener(_autoSaveDraft);
    _form.referral.addListener(_autoSaveDraft);
  }

  void _removeDraftAutoSave() {
    _form.firstName.removeListener(_autoSaveDraft);
    _form.lastName.removeListener(_autoSaveDraft);
    _form.email.removeListener(_autoSaveDraft);
    _form.phone.removeListener(_autoSaveDraft);
    _form.companyName.removeListener(_autoSaveDraft);
    _form.companyAddress.removeListener(_autoSaveDraft);
    _form.otherCategory.removeListener(_autoSaveDraft);
    _form.referral.removeListener(_autoSaveDraft);
  }

  void _autoSaveDraft() {
    if (!_isDraftLoaded) return;
    final isOther = _isOtherCategory ||
        (_categoryName != null &&
            (_categoryName!.trim().toLowerCase() == 'other' ||
                _categoryName!.trim().toLowerCase() == 'others'));
    final otherName = isOther ? _form.otherCategory.text.trim() : null;

    context.read<RegisterBloc>().add(
      RegisterDraftSaveRequested(
        RegisterParams(
          firstName: _form.firstName.text,
          lastName: _form.lastName.text,
          email: _form.email.text,
          phone: _form.phone.text,
          countryCode: _form.countryCode,
          dob: _selectedDob ?? '',
          cityId: _selectedCityId,
          city: _selectedCity ?? '',
          profilePhotoId: _profilePhotoId,
          companyName: _form.companyName.text,
          mainBusinessCategoryId: _mainCategoryId,
          mainBusinessCategoryName: _mainCategoryName,
          businessCategoryId: isOther ? null : _categoryId,
          businessCategoryName: isOther ? 'Other' : _categoryName,
          level1CategoryId: _mainCategoryId,
          level4CategoryId: isOther ? null : _categoryId,
          isOtherCategory: isOther,
          otherCategoryName: otherName,
          companyAddress: _form.companyAddress.text,
          latitude: _latitude,
          longitude: _longitude,
          referralCode: _form.referral.text.isNotEmpty
              ? _form.referral.text
              : null,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _removeDraftAutoSave();
    _pageController.dispose();
    _form.dispose();
    super.dispose();
  }

  void _onBack(BuildContext context, int currentStep) {
    if (currentStep > 1) {
      context.read<RegisterBloc>().add(const RegisterPreviousStepRequested());
    } else {
      Navigator.of(context).pop();
    }
  }

  void _submitStep1(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<RegisterBloc>().add(
      RegisterStep1Submitted(
        firstName: _form.firstName.text,
        lastName: _form.lastName.text,
        email: _form.email.text,
        phone: _form.phone.text,
        countryCode: _form.countryCode,
        dob: _selectedDob ?? '',
        cityId: _selectedCityId,
        city: _selectedCity ?? '',
        profilePhotoId: _profilePhotoId,
      ),
    );
  }

  void _submitStep2(BuildContext context) {
    FocusScope.of(context).unfocus();
    final isOther = _isOtherCategory ||
        (_categoryName != null &&
            (_categoryName!.trim().toLowerCase() == 'other' ||
                _categoryName!.trim().toLowerCase() == 'others'));
    final otherName = isOther ? _form.otherCategory.text.trim() : null;

    context.read<RegisterBloc>().add(
      RegisterStep2Submitted(
        companyName: _form.companyName.text,
        mainCategoryId: _mainCategoryId,
        mainCategoryName: _mainCategoryName,
        categoryId: isOther ? null : _categoryId,
        categoryName: isOther ? 'Other' : _categoryName,
        level1Id: _mainCategoryId,
        level4Id: isOther ? null : _categoryId,
        isOtherCategory: isOther,
        otherCategoryName: otherName,
        companyAddress: _form.companyAddress.text,
        latitude: _latitude,
        longitude: _longitude,
        referralCode: _form.referral.text,
      ),
    );
  }

  Future<void> _pickLocation(BuildContext context) async {
    final result = await LocationPickerSheet.show(
      context,
      initialLatitude: _latitude,
      initialLongitude: _longitude,
    );

    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        if (result.address.trim().isNotEmpty) {
          _form.companyAddress.text = result.address.trim();
        }
      });
      _autoSaveDraft();
      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          'Company location pinned successfully.',
        );
      }
    }
  }

  Future<void> _pickMainCategory(
    BuildContext context,
    RegisterState state,
  ) async {
    final picked = await RegisterFormControllers.pickCategory(
      context,
      title: 'Select Main Business Category',
      categories: state.mainCategories,
      selectedId: _mainCategoryId,
    );
    if (picked != null) {
      final newMainId = picked.id is int
          ? picked.id as int
          : int.tryParse(picked.id.toString());
      setState(() {
        _mainCategoryId = newMainId;
        _mainCategoryName = picked.name;
        _categoryId = null;
        _categoryName = null;
        _isOtherCategory = false;
        _form.otherCategory.clear();
      });
      _autoSaveDraft();
      if (context.mounted && newMainId != null) {
        context.read<RegisterBloc>().add(
          RegisterSubcategoriesRequested(newMainId),
        );
      }
    }
  }

  Future<void> _pickSubCategory(
    BuildContext context,
    RegisterState state,
  ) async {
    if (_mainCategoryId == null) {
      AppSnackBar.showError(context, 'Please select a main category first.');
      await _pickMainCategory(context, state);
      if (_mainCategoryId == null || !context.mounted) return;
    }

    final currentState = context.read<RegisterBloc>().state;
    final subList = currentState.subCategories.isNotEmpty
        ? currentState.subCategories
        : state.subCategories;

    final picked = await RegisterFormControllers.pickCategory(
      context,
      title: 'Select Business Category',
      categories: subList,
      selectedId: _isOtherCategory ? 'other' : _categoryId,
    );
    if (picked != null) {
      final isOther = picked.isOther ||
          picked.id == 'other' ||
          picked.name.trim().toLowerCase() == 'other' ||
          picked.name.trim().toLowerCase() == 'others';

      setState(() {
        _isOtherCategory = isOther;
        if (isOther) {
          _categoryId = null;
          _categoryName = 'Other';
        } else {
          _categoryId = picked.id is int
              ? picked.id as int
              : int.tryParse(picked.id.toString());
          _categoryName = picked.name;
          _form.otherCategory.clear();
        }
      });
      _autoSaveDraft();
    }
  }

  void _applyDraft(RegisterParams draft) {
    _form.populateFromDraft(draft);
    setState(() {
      if (draft.dob.isNotEmpty) _selectedDob = draft.dob;
      if (draft.city.isNotEmpty) _selectedCity = draft.city;
      if (draft.cityId != null && draft.cityId!.isNotEmpty) {
        _selectedCityId = draft.cityId;
      }
      if (draft.profilePhotoId != null && draft.profilePhotoId!.isNotEmpty) {
        _profilePhotoId = draft.profilePhotoId;
      }
      if (draft.mainBusinessCategoryId != null) {
        _mainCategoryId = draft.mainBusinessCategoryId;
        _mainCategoryName = draft.mainBusinessCategoryName;
      }
      if (draft.businessCategoryId != null) {
        _categoryId = draft.businessCategoryId;
        _categoryName = draft.businessCategoryName;
      }
      _isOtherCategory = draft.isOtherCategory;
      if (draft.otherCategoryName != null && draft.otherCategoryName!.isNotEmpty) {
        _form.otherCategory.text = draft.otherCategoryName!;
      }
      _latitude = draft.latitude;
      _longitude = draft.longitude;
      _isDraftLoaded = true;
    });

    if (_mainCategoryId != null && mounted) {
      context.read<RegisterBloc>().add(
        RegisterSubcategoriesRequested(_mainCategoryId),
      );
    }
  }

  void _onStateChanged(BuildContext context, RegisterState state) {
    if (!_isDraftLoaded &&
        (state.status == RegisterStatus.draftLoaded ||
            state.params != const RegisterParams())) {
      _applyDraft(state.params);
    } else if (!_isDraftLoaded && state.status == RegisterStatus.stepReady) {
      _isDraftLoaded = true;
    }

    if (_pageController.hasClients &&
        _pageController.page?.round() != state.currentStep - 1) {
      _pageController.animateToPage(
        state.currentStep - 1,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    }
    if (state.status == RegisterStatus.success) {
      AppSnackBar.showSuccess(
        context,
        state.successMessage ?? 'Registration successful.',
      );
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } else if (state.status == RegisterStatus.error &&
        state.errorMessage != null) {
      AppSnackBar.showError(context, state.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: _onStateChanged,
      builder: (context, state) {
        return PopScope(
          canPop: state.currentStep == 1,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && state.currentStep > 1) {
              _onBack(context, state.currentStep);
            }
          },
          child: Scaffold(
            body: AuthAmbientBackground(
              child: SafeArea(
                child: ResponsiveContainer(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: RegisterProgressHeader(
                          currentStep: state.currentStep,
                          onBack: () => _onBack(context, state.currentStep),
                        ),
                      ),
                      Expanded(
                        child: RegisterStepSwitcher(
                          pageController: _pageController,
                          state: state,
                          isLoading: state.status == RegisterStatus.submitting,
                          firstNameController: _form.firstName,
                          lastNameController: _form.lastName,
                          emailController: _form.email,
                          phoneController: _form.phone,
                          countryCode: _form.countryCode,
                          onCountryCodeChanged: (c) {
                            setState(() => _form.countryCode = c);
                            _autoSaveDraft();
                          },
                          companyNameController: _form.companyName,
                          companyAddressController: _form.companyAddress,
                          otherCategoryController: _form.otherCategory,
                          referralController: _form.referral,
                          mainCategoryName: _mainCategoryName,
                          categoryName: _categoryName,
                          isOtherCategory: _isOtherCategory,
                          city: _selectedCity,
                          dob: _selectedDob,
                          profilePhotoPath: _profilePhotoId,
                          latitude: _latitude,
                          longitude: _longitude,
                          onSelectMainCategory: () =>
                              _pickMainCategory(context, state),
                          onSelectCategory: () =>
                              _pickSubCategory(context, state),
                          onSelectCity: () async {
                            final sel = await RegisterFormControllers.pickCity(
                              context,
                              dataSource: _locationDataSource,
                              selectedCityId: _selectedCityId,
                            );
                            if (sel != null) {
                              setState(() {
                                _selectedCityId = sel.id;
                                _selectedCity = sel.label;
                              });
                              _autoSaveDraft();
                            }
                          },
                          onSelectDob: () async {
                            final sel =
                                await RegisterFormControllers.pickDateOfBirth(
                                  context,
                                );
                            if (sel != null) {
                              setState(() => _selectedDob = sel);
                              _autoSaveDraft();
                            }
                          },
                          onSelectPhoto: () async {
                            final file = await ImageSourcePickerSheet.show(
                              context,
                            );
                            if (file != null) {
                              setState(() => _profilePhotoId = file.path);
                              _autoSaveDraft();
                              if (context.mounted) {
                                AppSnackBar.showSuccess(
                                  context,
                                  'Profile photo selected.',
                                );
                              }
                            }
                          },
                          onPickLocation: () => _pickLocation(context),
                          onContinueStep1: () => _submitStep1(context),
                          onCreateAccount: () => _submitStep2(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
