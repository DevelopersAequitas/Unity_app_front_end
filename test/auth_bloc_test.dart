import 'package:flutter_test/flutter_test.dart';
import 'package:unity_app/features/auth/domain/entities/auth_token_entity.dart';
import 'package:unity_app/features/auth/domain/entities/user_entity.dart';
import 'package:unity_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:unity_app/features/auth/domain/usecases/get_cached_auth_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:unity_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:unity_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:unity_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:unity_app/features/auth/presentation/bloc/auth_state.dart';

import 'package:unity_app/features/auth/domain/entities/category_item_entity.dart';
import 'package:unity_app/features/auth/domain/entities/register_params.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> requestOtp(String email, {String channel = 'email'}) async {
    if (email == 'error@gmail.com') {
      throw Exception('Server error');
    }
  }

  @override
  Future<({UserEntity user, AuthTokenEntity token})> verifyOtp({
    required String email,
    required String otp,
    required String deviceName,
  }) async {
    if (otp == '0000') {
      throw Exception('Invalid OTP code');
    }
    return (
      user: UserEntity(id: 'usr_1', email: email),
      token: const AuthTokenEntity(token: 'mock_jwt'),
    );
  }

  @override
  Future<({UserEntity user, AuthTokenEntity token})> register(
    RegisterParams params,
  ) async {
    return (
      user: UserEntity(id: 'usr_reg', email: params.email),
      token: const AuthTokenEntity(token: 'mock_reg_jwt'),
    );
  }

  @override
  Future<List<CategoryItemEntity>> getMainCategories() async => [];

  @override
  Future<List<CategoryItemEntity>> getSubcategories(dynamic parentId) async =>
      [];

  @override
  Future<void> saveRegistrationDraft(RegisterParams params) async {}

  @override
  Future<RegisterParams?> getRegistrationDraft() async => null;

  @override
  Future<void> clearRegistrationDraft() async {}

  @override
  Future<({UserEntity? user, AuthTokenEntity? token})> getCachedAuth() async {
    return (user: null, token: null);
  }

  @override
  Future<void> clearAuth() async {}
}

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository repo;

  setUp(() {
    repo = MockAuthRepository();
    authBloc = AuthBloc(
      requestOtpUseCase: RequestOtpUseCase(repo),
      verifyOtpUseCase: VerifyOtpUseCase(repo),
      getCachedAuthUseCase: GetCachedAuthUseCase(repo),
    );
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state is AuthInitial', () {
    expect(authBloc.state, const AuthInitial());
  });

  test(
    'emits [AuthLoading, AuthOtpSentSuccess] on successful requestOtp',
    () async {
      final expected = [
        const AuthLoading(message: 'Sending OTP...'),
        const AuthOtpSentSuccess(
          email: 'test@gmail.com',
          channel: 'email',
          message: 'OTP sent to your email.',
        ),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));
      authBloc.add(const AuthRequestOtpSubmitted('test@gmail.com'));
    },
  );

  test(
    'emits [AuthLoading, AuthVerifySuccess] on successful verifyOtp',
    () async {
      final expected = [
        const AuthLoading(message: 'Verifying code...'),
        const AuthVerifySuccess(
          user: UserEntity(id: 'usr_1', email: 'test@gmail.com'),
          token: AuthTokenEntity(token: 'mock_jwt'),
        ),
      ];

      expectLater(authBloc.stream, emitsInOrder(expected));
      authBloc.add(
        const AuthVerifyOtpSubmitted(email: 'test@gmail.com', otp: '1234'),
      );
    },
  );
}
