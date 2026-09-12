import 'package:flutter_test/flutter_test.dart';
import 'package:unity_app/features/auth/domain/entities/auth_token_entity.dart';
import 'package:unity_app/features/auth/domain/entities/register_params.dart';
import 'package:unity_app/features/auth/domain/entities/user_entity.dart';
import 'package:unity_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:unity_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:unity_app/features/auth/presentation/bloc/register_bloc.dart';
import 'package:unity_app/features/auth/presentation/bloc/register_event.dart';
import 'package:unity_app/features/auth/presentation/bloc/register_state.dart';

import 'package:unity_app/features/auth/domain/entities/category_item_entity.dart';
import 'package:unity_app/features/auth/domain/usecases/get_main_categories_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/get_registration_draft_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/get_subcategories_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/save_registration_draft_usecase.dart';

class MockRegisterRepository implements AuthRepository {
  RegisterParams? _draft;

  @override
  Future<void> requestOtp(String email, {String channel = 'email'}) async {}

  @override
  Future<({UserEntity user, AuthTokenEntity token})> verifyOtp({
    required String email,
    required String otp,
    required String deviceName,
  }) async {
    return (
      user: UserEntity(id: 'usr_1', email: email),
      token: const AuthTokenEntity(token: 'mock_jwt'),
    );
  }

  @override
  Future<({UserEntity user, AuthTokenEntity token})> register(
    RegisterParams params,
  ) async {
    if (params.email == 'fail@test.com') {
      throw Exception('Email already taken');
    }
    return (
      user: UserEntity(
        id: 'usr_reg_1',
        email: params.email,
        name: '${params.firstName} ${params.lastName}'.trim(),
      ),
      token: const AuthTokenEntity(token: 'token_sample'),
    );
  }

  @override
  Future<List<CategoryItemEntity>> getMainCategories() async {
    return [
      const CategoryItemEntity(id: 1, name: 'IT & Software'),
      const CategoryItemEntity(id: 2, name: 'Manufacturing'),
    ];
  }

  @override
  Future<List<CategoryItemEntity>> getSubcategories(dynamic parentId) async {
    return [
      const CategoryItemEntity(
        id: 101,
        name: 'Software Dev',
        level: 2,
        parentId: 1,
      ),
      const CategoryItemEntity(id: 'other', name: 'Other', isOther: true),
    ];
  }

  @override
  Future<void> saveRegistrationDraft(RegisterParams params) async {
    _draft = params;
  }

  @override
  Future<RegisterParams?> getRegistrationDraft() async {
    return _draft;
  }

  @override
  Future<void> clearRegistrationDraft() async {
    _draft = null;
  }

  @override
  Future<({UserEntity? user, AuthTokenEntity? token})> getCachedAuth() async {
    return (user: null, token: null);
  }

  @override
  Future<void> clearAuth() async {}
}

void main() {
  late RegisterBloc bloc;
  late MockRegisterRepository repo;

  setUp(() {
    repo = MockRegisterRepository();
    bloc = RegisterBloc(
      registerUseCase: RegisterUseCase(repo),
      getMainCategoriesUseCase: GetMainCategoriesUseCase(repo),
      getSubcategoriesUseCase: GetSubcategoriesUseCase(repo),
      saveRegistrationDraftUseCase: SaveRegistrationDraftUseCase(repo),
      getRegistrationDraftUseCase: GetRegistrationDraftUseCase(repo),
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is RegisterState at step 1', () {
    expect(bloc.state.currentStep, 1);
    expect(bloc.state.status, RegisterStatus.initial);
  });

  test('advances to step 2 on valid step 1 submission', () async {
    bloc.add(
      const RegisterStep1Submitted(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '9876543210',
        countryCode: '+91',
        dob: '1995-05-15',
        city: 'Mumbai',
        profilePhotoId: 'mock_path/photo.jpg',
      ),
    );

    await expectLater(
      bloc.stream,
      emits(
        predicate<RegisterState>((state) {
          return state.currentStep == 2 &&
              state.status == RegisterStatus.stepReady &&
              state.params.firstName == 'John' &&
              state.params.email == 'john@example.com' &&
              state.params.dob == '1995-05-15' &&
              state.params.city == 'Mumbai' &&
              state.params.profilePhotoId == 'mock_path/photo.jpg';
        }),
      ),
    );
  });

  test('emits error on invalid email in step 1', () async {
    bloc.add(
      const RegisterStep1Submitted(
        firstName: 'John',
        lastName: 'Doe',
        email: 'not-an-email',
        phone: '9876543210',
        countryCode: '+91',
        dob: '1995-05-15',
        city: 'Mumbai',
        profilePhotoId: 'mock_path/photo.jpg',
      ),
    );

    await expectLater(
      bloc.stream,
      emits(
        predicate<RegisterState>((state) {
          return state.status == RegisterStatus.error &&
              state.errorMessage == 'Please enter a valid email address.';
        }),
      ),
    );
  });

  test('emits error on empty DOB in step 1', () async {
    bloc.add(
      const RegisterStep1Submitted(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '9876543210',
        countryCode: '+91',
        dob: '',
        city: 'Mumbai',
        profilePhotoId: 'mock_path/photo.jpg',
      ),
    );

    await expectLater(
      bloc.stream,
      emits(
        predicate<RegisterState>((state) {
          return state.status == RegisterStatus.error &&
              state.errorMessage == 'Please select your date of birth.';
        }),
      ),
    );
  });

  test('emits error on empty city in step 1', () async {
    bloc.add(
      const RegisterStep1Submitted(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '9876543210',
        countryCode: '+91',
        dob: '1995-05-15',
        city: '',
        profilePhotoId: 'mock_path/photo.jpg',
      ),
    );

    await expectLater(
      bloc.stream,
      emits(
        predicate<RegisterState>((state) {
          return state.status == RegisterStatus.error &&
              state.errorMessage == 'Please select your city.';
        }),
      ),
    );
  });

  test('emits error on missing profile photo in step 1', () async {
    bloc.add(
      const RegisterStep1Submitted(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        phone: '9876543210',
        countryCode: '+91',
        dob: '1995-05-15',
        city: 'Mumbai',
        profilePhotoId: '',
      ),
    );

    await expectLater(
      bloc.stream,
      emits(
        predicate<RegisterState>((state) {
          return state.status == RegisterStatus.error &&
              state.errorMessage == 'Please upload your profile photo.';
        }),
      ),
    );
  });

  test('submits successfully in step 2 and emits success state', () async {
    // Step 1
    bloc.add(
      const RegisterStep1Submitted(
        firstName: 'Alice',
        lastName: 'Smith',
        email: 'alice@example.com',
        phone: '9876543210',
        countryCode: '+91',
        dob: '1995-05-15',
        city: 'Mumbai',
        profilePhotoId: 'path/avatar.png',
      ),
    );
    await Future.delayed(const Duration(milliseconds: 10));

    // Step 2
    bloc.add(
      const RegisterStep2Submitted(
        companyName: 'Acme Corp',
        mainCategoryId: 1,
        mainCategoryName: 'IT',
        categoryId: 1,
        categoryName: 'Software',
        companyAddress: '123 Main St',
        referralCode: 'REF123',
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<RegisterState>((s) => s.status == RegisterStatus.submitting),
        predicate<RegisterState>(
          (s) =>
              s.status == RegisterStatus.success &&
              s.user != null &&
              s.token != null,
        ),
      ]),
    );
  });
}
