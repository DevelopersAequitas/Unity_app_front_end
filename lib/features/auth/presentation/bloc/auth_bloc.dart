import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/app_update_service.dart';
import '../../../../core/services/location_sync_service.dart';
import '../../../../core/services/user_presence_service.dart';
import '../../../../core/utils/app_error_handler.dart';
import '../../domain/usecases/get_cached_auth_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/request_otp_usecase.dart';
import '../../domain/usecases/request_whatsapp_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/verify_whatsapp_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RequestOtpUseCase requestOtpUseCase;
  final RequestWhatsappOtpUseCase requestWhatsappOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final VerifyWhatsappOtpUseCase verifyWhatsappOtpUseCase;
  final GetCachedAuthUseCase getCachedAuthUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.requestOtpUseCase,
    required this.requestWhatsappOtpUseCase,
    required this.verifyOtpUseCase,
    required this.verifyWhatsappOtpUseCase,
    required this.getCachedAuthUseCase,
    required this.logoutUseCase,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthRequestOtpSubmitted>(_onRequestOtpSubmitted);
    on<AuthVerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthResetState>(_onResetState);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final cached = await getCachedAuthUseCase();
      if (cached.user != null && cached.token != null) {
        debugPrint('\n====================================================');
        debugPrint('🔑 [AUTH] ACTIVE SESSION TOKEN:');
        debugPrint('Bearer ${cached.token}');
        debugPrint('====================================================\n');
        UserPresenceService.instance.markOnlineAndStart();
        LocationSyncService.instance.syncLocationIfPermitted();
        AppUpdateService.instance.syncMobileVersion();
        emit(AuthAuthenticated(user: cached.user!, token: cached.token!));
      } else {
        UserPresenceService.instance.markOfflineAndStop();
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      UserPresenceService.instance.markOfflineAndStop();
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onRequestOtpSubmitted(
    AuthRequestOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final cleanInput = event.identifier.trim();
    final isWhatsapp = event.channel == 'whatsapp';

    if (isWhatsapp) {
      if (cleanInput.isEmpty || cleanInput.length < 5) {
        emit(const AuthError('Please enter a valid phone number.'));
        return;
      }
    } else {
      if (cleanInput.isEmpty || !cleanInput.contains('@')) {
        emit(const AuthError('Please enter a valid email address.'));
        return;
      }
    }

    emit(const AuthLoading(message: 'Sending OTP...'));
    try {
      if (isWhatsapp) {
        await requestWhatsappOtpUseCase(cleanInput);
      } else {
        await requestOtpUseCase(cleanInput);
      }
      final dest = isWhatsapp ? 'WhatsApp' : 'email';
      emit(
        AuthOtpSentSuccess(
          identifier: cleanInput,
          channel: event.channel,
          message: 'OTP sent to your $dest.',
        ),
      );
    } catch (e, stackTrace) {
      final msg = AppErrorHandler.toUserFriendlyMessage(e, stackTrace);
      emit(AuthError(msg));
    }
  }

  Future<void> _onVerifyOtpSubmitted(
    AuthVerifyOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    final cleanOtp = event.otp.trim();
    if (cleanOtp.length < 4) {
      emit(const AuthError('Please enter the 4-digit verification code.'));
      return;
    }

    emit(const AuthLoading(message: 'Verifying code...'));
    try {
      final result = event.channel == 'whatsapp'
          ? await verifyWhatsappOtpUseCase(
              phone: event.identifier.trim(),
              otp: cleanOtp,
              deviceName: event.deviceName,
            )
          : await verifyOtpUseCase(
              email: event.identifier.trim(),
              otp: cleanOtp,
              deviceName: event.deviceName,
            );
      UserPresenceService.instance.markOnlineAndStart();
      LocationSyncService.instance.syncLocationIfPermitted();
      AppUpdateService.instance.syncMobileVersion();
      emit(AuthVerifySuccess(user: result.user, token: result.token));
    } catch (e, stackTrace) {
      final msg = AppErrorHandler.toUserFriendlyMessage(e, stackTrace);
      emit(AuthError(msg));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Logging out...'));
    try {
      await logoutUseCase();
    } catch (_) {}
    UserPresenceService.instance.markOfflineAndStop();
    emit(const AuthUnauthenticated());
  }

  void _onResetState(AuthResetState event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }
}
