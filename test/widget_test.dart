import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unity_app/core/theme/app_theme.dart';
import 'package:unity_app/core/widgets/app_text_field.dart';
import 'package:unity_app/core/widgets/peers_logo.dart';
import 'package:unity_app/core/widgets/primary_pill_button.dart';
import 'package:unity_app/features/auth/domain/entities/auth_token_entity.dart';
import 'package:unity_app/features/auth/domain/entities/user_entity.dart';
import 'package:unity_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:unity_app/features/auth/domain/usecases/get_cached_auth_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:unity_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unity_app/features/auth/presentation/screens/login_screen.dart';
import 'package:unity_app/features/auth/presentation/screens/register_screen.dart';
import 'package:unity_app/features/auth/presentation/screens/welcome_screen.dart';

import 'package:unity_app/features/auth/domain/entities/category_item_entity.dart';
import 'package:unity_app/features/auth/domain/entities/register_params.dart';
import 'package:unity_app/features/auth/domain/usecases/get_main_categories_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/get_registration_draft_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/get_subcategories_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/save_registration_draft_usecase.dart';
import 'package:unity_app/features/auth/presentation/bloc/register_bloc.dart';

class _FakeAuthRepository implements AuthRepository {
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
      user: UserEntity(id: '1', email: email),
      token: const AuthTokenEntity(token: 'mock'),
    );
  }

  @override
  Future<({UserEntity user, AuthTokenEntity token})> register(
    RegisterParams params,
  ) async {
    return (
      user: UserEntity(id: 'reg_1', email: params.email),
      token: const AuthTokenEntity(token: 'mock_token'),
    );
  }

  @override
  Future<List<CategoryItemEntity>> getMainCategories() async {
    return [const CategoryItemEntity(id: 1, name: 'IT & Software')];
  }

  @override
  Future<List<CategoryItemEntity>> getSubcategories(dynamic parentId) async {
    return [
      const CategoryItemEntity(id: 101, name: 'SaaS', level: 2, parentId: 1),
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
  testWidgets('WelcomeScreen renders key UI elements', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.lightTheme, home: const WelcomeScreen()),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().toUpperCase().contains(
              'PEERS ARE PARTNERS',
            ),
      ),
      findsOneWidget,
    );

    expect(find.text('Get Started'), findsOneWidget);
    expect(find.byType(PrimaryPillButton), findsOneWidget);
    expect(find.byType(PeersLogo), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('LoginScreen renders modern OTP screen with elements', (
    WidgetTester tester,
  ) async {
    final repo = _FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            requestOtpUseCase: RequestOtpUseCase(repo),
            verifyOtpUseCase: VerifyOtpUseCase(repo),
            getCachedAuthUseCase: GetCachedAuthUseCase(repo),
          ),
          child: const LoginScreen(),
        ),
      ),
    );

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('RegisterScreen renders Step 1 basic info elements', (
    WidgetTester tester,
  ) async {
    final repo = _FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: BlocProvider<RegisterBloc>(
          create: (_) => RegisterBloc(
            registerUseCase: RegisterUseCase(repo),
            getMainCategoriesUseCase: GetMainCategoriesUseCase(repo),
            getSubcategoriesUseCase: GetSubcategoriesUseCase(repo),
            saveRegistrationDraftUseCase: SaveRegistrationDraftUseCase(repo),
            getRegistrationDraftUseCase: GetRegistrationDraftUseCase(repo),
          ),
          child: const RegisterScreen(),
        ),
      ),
    );

    expect(find.text("Let's get started"), findsOneWidget);
    expect(
      find.text('Tell us a few basic details to create your account.'),
      findsOneWidget,
    );
    expect(find.text('1/2'), findsOneWidget);
    expect(find.text('First name'), findsOneWidget);
    expect(find.text('Last name'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);
    expect(find.text('Date of birth'), findsOneWidget);
    expect(find.text('City'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is RichText && w.text.toPlainText().contains('Add profile photo'),
      ),
      findsOneWidget,
    );
    expect(find.text('Continue'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
