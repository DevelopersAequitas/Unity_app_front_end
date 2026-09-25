import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_error_handler.dart';
import '../../domain/usecases/clear_registration_draft_usecase.dart';
import '../../domain/usecases/get_main_categories_usecase.dart';
import '../../domain/usecases/get_registration_draft_usecase.dart';
import '../../domain/usecases/get_subcategories_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/save_registration_draft_usecase.dart';
import '../../domain/usecases/validate_referral_code_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;
  final GetMainCategoriesUseCase getMainCategoriesUseCase;
  final GetSubcategoriesUseCase getSubcategoriesUseCase;
  final SaveRegistrationDraftUseCase saveRegistrationDraftUseCase;
  final GetRegistrationDraftUseCase getRegistrationDraftUseCase;
  final ClearRegistrationDraftUseCase? clearRegistrationDraftUseCase;
  final ValidateReferralCodeUseCase? validateReferralCodeUseCase;

  RegisterBloc({
    required this.registerUseCase,
    required this.getMainCategoriesUseCase,
    required this.getSubcategoriesUseCase,
    required this.saveRegistrationDraftUseCase,
    required this.getRegistrationDraftUseCase,
    this.clearRegistrationDraftUseCase,
    this.validateReferralCodeUseCase,
  }) : super(const RegisterState()) {
    on<RegisterDraftLoadRequested>(_onDraftLoadRequested);
    on<RegisterDraftSaveRequested>(_onDraftSaveRequested);
    on<RegisterMainCategoriesRequested>(_onMainCategoriesRequested);
    on<RegisterSubcategoriesRequested>(_onSubcategoriesRequested);
    on<RegisterReferralCodeValidationRequested>(_onReferralValidationRequested);
    on<RegisterReferralCodeCleared>(_onReferralCodeCleared);
    on<RegisterStep1Submitted>(_onStep1Submitted);
    on<RegisterStep2Submitted>(_onStep2Submitted);
    on<RegisterPreviousStepRequested>(_onPreviousStepRequested);
    on<RegisterResetState>(_onResetState);
  }

  Future<void> _onDraftLoadRequested(
    RegisterDraftLoadRequested event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      final draft = await getRegistrationDraftUseCase();
      if (draft != null) {
        emit(state.copyWith(params: draft, status: RegisterStatus.draftLoaded));
        if (draft.referralCode != null && draft.referralCode!.trim().isNotEmpty) {
          add(RegisterReferralCodeValidationRequested(draft.referralCode!));
        }
      }
    } catch (_) {}
  }

  Future<void> _onDraftSaveRequested(
    RegisterDraftSaveRequested event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      final updated = event.params;
      await saveRegistrationDraftUseCase(updated);
      emit(state.copyWith(params: updated));
    } catch (_) {}
  }

  Future<void> _onMainCategoriesRequested(
    RegisterMainCategoriesRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isCategoriesLoading: true));
    try {
      final list = await getMainCategoriesUseCase();
      emit(state.copyWith(mainCategories: list, isCategoriesLoading: false));
    } catch (_) {
      emit(state.copyWith(isCategoriesLoading: false));
    }
  }

  Future<void> _onSubcategoriesRequested(
    RegisterSubcategoriesRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isCategoriesLoading: true));
    try {
      final list = await getSubcategoriesUseCase(event.parentId);
      emit(state.copyWith(subCategories: list, isCategoriesLoading: false));
    } catch (_) {
      emit(state.copyWith(isCategoriesLoading: false));
    }
  }

  Future<void> _onReferralValidationRequested(
    RegisterReferralCodeValidationRequested event,
    Emitter<RegisterState> emit,
  ) async {
    final code = event.code.trim().toUpperCase();
    if (code.isEmpty) {
      emit(
        state.copyWith(
          isReferralValidating: false,
          clearReferralValidation: true,
          clearReferralValidationMessage: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isReferralValidating: true,
        clearReferralValidation: true,
        referralValidationMessage: null,
      ),
    );

    try {
      if (validateReferralCodeUseCase != null) {
        final result = await validateReferralCodeUseCase!(code);
        emit(
          state.copyWith(
            isReferralValidating: false,
            referralValidation: result,
            referralValidationMessage: result.valid
                ? 'Referral code verified: ${result.displayName}'
                : 'Invalid referral code',
          ),
        );
      } else {
        emit(state.copyWith(isReferralValidating: false));
      }
    } catch (_) {
      emit(
        state.copyWith(
          isReferralValidating: false,
          referralValidationMessage: 'Could not verify referral code',
        ),
      );
    }
  }

  void _onReferralCodeCleared(
    RegisterReferralCodeCleared event,
    Emitter<RegisterState> emit,
  ) {
    emit(
      state.copyWith(
        clearReferralValidation: true,
        clearReferralValidationMessage: true,
      ),
    );
  }

  void _onStep1Submitted(
    RegisterStep1Submitted event,
    Emitter<RegisterState> emit,
  ) {
    if (event.firstName.trim().isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please enter your first name.',
        ),
      );
      return;
    }
    if (event.lastName.trim().isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please enter your last name.',
        ),
      );
      return;
    }
    final email = event.email.trim();
    if (email.isEmpty || !email.contains('@')) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please enter a valid email address.',
        ),
      );
      return;
    }
    final cleanPhone = event.phone.replaceAll(RegExp(r'\D'), '');
    if (cleanPhone.isEmpty || cleanPhone.length < 5) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please enter a valid phone number.',
        ),
      );
      return;
    }
    final dob = event.dob.trim();
    if (dob.isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please select your date of birth.',
        ),
      );
      return;
    }
    final city = event.city.trim();
    if (city.isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please select your city.',
        ),
      );
      return;
    }
    final photo = event.profilePhotoId?.trim() ?? '';
    if (photo.isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please upload your profile photo.',
        ),
      );
      return;
    }

    final updated = state.params.copyWith(
      firstName: event.firstName.trim(),
      lastName: event.lastName.trim(),
      email: email,
      phone: cleanPhone,
      countryCode: event.countryCode,
      dob: dob,
      cityId: event.cityId,
      city: city,
      profilePhotoId: photo,
    );
    saveRegistrationDraftUseCase(updated);
    emit(
      state.copyWith(
        currentStep: 2,
        params: updated,
        status: RegisterStatus.stepReady,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onStep2Submitted(
    RegisterStep2Submitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (event.companyName.trim().isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please enter your company name.',
        ),
      );
      return;
    }
    if (event.mainCategoryId == null) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please select a main business category.',
        ),
      );
      return;
    }
    if (!event.isOtherCategory && event.categoryId == null) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please select a business category or Other.',
        ),
      );
      return;
    }
    if (event.isOtherCategory &&
        (event.otherCategoryName == null ||
            event.otherCategoryName!.trim().isEmpty)) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please enter your custom category name.',
        ),
      );
      return;
    }
    if (event.companyAddress.trim().isEmpty) {
      emit(
        state.copyWith(
          status: RegisterStatus.error,
          errorMessage: 'Please enter your company address.',
        ),
      );
      return;
    }

    final updated = state.params.copyWith(
      companyName: event.companyName.trim(),
      mainBusinessCategoryId: event.mainCategoryId,
      mainBusinessCategoryName: event.mainCategoryName,
      businessCategoryId: event.categoryId,
      businessCategoryName: event.categoryName,
      level1CategoryId: event.level1Id ?? event.mainCategoryId,
      level2CategoryId: event.level2Id,
      level3CategoryId: event.level3Id,
      level4CategoryId: event.level4Id ?? event.categoryId,
      isOtherCategory: event.isOtherCategory,
      otherCategoryName: event.otherCategoryName?.trim(),
      companyAddress: event.companyAddress.trim(),
      referralCode: event.referralCode?.trim(),
      latitude: event.latitude,
      longitude: event.longitude,
    );
    saveRegistrationDraftUseCase(updated);

    emit(
      state.copyWith(
        status: RegisterStatus.submitting,
        params: updated,
        errorMessage: null,
      ),
    );

    try {
      final result = await registerUseCase(updated);
      await clearRegistrationDraftUseCase?.call();
      emit(
        state.copyWith(
          status: RegisterStatus.success,
          successMessage: 'Registration successful.',
          user: result.user,
          token: result.token,
        ),
      );
    } catch (e, stackTrace) {
      final friendlyMsg = AppErrorHandler.toUserFriendlyMessage(e, stackTrace);
      emit(
        state.copyWith(status: RegisterStatus.error, errorMessage: friendlyMsg),
      );
    }
  }

  void _onPreviousStepRequested(
    RegisterPreviousStepRequested event,
    Emitter<RegisterState> emit,
  ) {
    if (state.currentStep > 1) {
      emit(
        state.copyWith(
          currentStep: state.currentStep - 1,
          status: RegisterStatus.stepReady,
          errorMessage: null,
        ),
      );
    }
  }

  void _onResetState(RegisterResetState event, Emitter<RegisterState> emit) {
    emit(const RegisterState());
  }
}
